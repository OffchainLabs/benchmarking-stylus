#!/bin/bash

# Load environment variables from .env in the root directory
ENV_FILE="../.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "❌ Error: .env file not found at $ENV_FILE!"
    exit 1
fi

# Ensure required environment variables are set
if [ -z "$PRIVATE_KEY" ]; then
    echo "❌ Error: PRIVATE_KEY is not set in the .env file!"
    exit 1
fi

if [ -z "$RPC_URL" ]; then
    echo "❌ Error: RPC_URL is not set in the .env file!"
    exit 1
fi

# Define the contract path
CONTRACT_FILE=$(realpath ../src/MatrixMultiplicationHardcoded.sol)

if [ ! -f "$CONTRACT_FILE" ]; then
    echo "❌ Error: Contract file not found at expected path: $CONTRACT_FILE"
    ls -lah ../src/
    exit 1
fi

echo "🚀 Using contract: $CONTRACT_FILE"


# Small delay to prevent race conditions
sleep 1

# Detect matrix size from function parameters (macOS-compatible)
echo "🔍 Detecting matrix size from function parameters in $CONTRACT_FILE..."

MATRIX_SIZE=$(grep -oE 'uint256\[[0-9]+\]\[[0-9]+\]' "$CONTRACT_FILE" | head -n 1 | grep -oE '[0-9]+' | tail -n 1)


# If detection fails, set a default value
if [ -z "$MATRIX_SIZE" ]; then
    echo "⚠️ Warning: Could not detect matrix size, defaulting to 40."
    MATRIX_SIZE=40
fi

echo "✅ Matrix size detected: ${MATRIX_SIZE}x${MATRIX_SIZE}"

# Deploy the contract
deploy_contract() {
    echo "🚀 Deploying MatrixMultiplication contract..."

    DEPLOY_OUTPUT=$(forge create \
        --rpc-url "$RPC_URL" \
        --private-key "$PRIVATE_KEY" \
        "$CONTRACT_FILE:MatrixMultiplication" \
        --broadcast 2>&1)

    echo "$DEPLOY_OUTPUT"

    # Extract contract address from output
    CONTRACT_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -Eo 'Deployed to: 0x[a-fA-F0-9]{40}' | awk '{print $NF}')

    if [ -z "$CONTRACT_ADDRESS" ]; then
        echo "❌ Error: Failed to deploy contract!"
        exit 1
    fi

    echo "✅ Contract deployed at: $CONTRACT_ADDRESS"
}

# Fetch Ethereum address from private key
ETH_FROM=$(cast wallet address --private-key "$PRIVATE_KEY")
export ETH_FROM

# Function to send the transaction
send_matrix_transaction() {
    echo "🚀 Sending transaction for ${MATRIX_SIZE}x${MATRIX_SIZE} matrix multiplication..."

    # Fetch current nonce dynamically
    NONCE=$(cast nonce "$ETH_FROM" --rpc-url "$RPC_URL")

    # Estimate gas limit (adjust based on actual contract needs)
    GAS_LIMIT=500000000000

    # Send the transaction to call the multiply() function in the contract
    TX_HASH=$(cast send "$CONTRACT_ADDRESS" \
        "multiply()" \
        --from "$ETH_FROM" --rpc-url "$RPC_URL" \
        --nonce "$NONCE" --gas-limit "$GAS_LIMIT" --private-key "$PRIVATE_KEY" 2>&1)

    if [[ "$TX_HASH" == *"out of gas"* ]]; then
        echo "❌ Out of Gas for ${MATRIX_SIZE}x${MATRIX_SIZE} matrix multiplication!"
    elif [[ "$TX_HASH" == *"Error"* ]]; then
        echo "❌ Failed: $TX_HASH"
    else
        echo "✅ Success: Transaction sent - Hash: $TX_HASH"
    fi
}

# Execute contract deployment and function call
deploy_contract
send_matrix_transaction

echo "✅ All transactions attempted!"
