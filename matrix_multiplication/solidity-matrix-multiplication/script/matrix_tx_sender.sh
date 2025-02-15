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

# Deploy the MatrixMultiplication contract
deploy_contract() {
    echo "🚀 Deploying MatrixMultiplication contract..."

    DEPLOY_OUTPUT=$(forge create \
        --rpc-url "$RPC_URL" \
        --private-key "$PRIVATE_KEY" \
        src/MatrixMultiplication.sol:MatrixMultiplication \
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

# Generate a random matrix of size NxN with values between 0 and 10
generate_matrix() {
    local size=$1
    local matrix="["
    for ((i=0; i<size; i++)); do
        row="["
        for ((j=0; j<size; j++)); do
            rand_value=$((RANDOM % 11)) # Random number between 0-10
            row+="$rand_value"
            if [ "$j" -lt $((size - 1)) ]; then
                row+=","
            fi
        done
        row+="]"
        matrix+="$row"
        if [ "$i" -lt $((size - 1)) ]; then
            matrix+=","
        fi
    done
    matrix+="]"
    echo "$matrix"
}

# Function to send the transaction
send_matrix_transaction() {
    local size=$1
    echo "🚀 Sending transaction for ${size}x${size} matrix multiplication..."

    # Generate two random matrices
    MATRIX_A=$(generate_matrix "$size")
    MATRIX_B=$(generate_matrix "$size")

    # Fetch current nonce dynamically
    NONCE=$(cast nonce "$ETH_FROM" --rpc-url "$RPC_URL")
    
    # Estimate gas limit (adjust based on actual contract needs)
    GAS_LIMIT=500000000

    # Send the transaction to call the multiply() function
    TX_HASH=$(cast send "$CONTRACT_ADDRESS" \
        "multiply(uint256[][],uint256[][])" \
        "$MATRIX_A" "$MATRIX_B" \
        --from "$ETH_FROM" --rpc-url "$RPC_URL" \
        --nonce "$NONCE" --gas-limit "$GAS_LIMIT" --private-key "$PRIVATE_KEY" 2>&1)

    if [[ "$TX_HASH" == *"out of gas"* ]]; then
        echo "❌ Out of Gas for ${size}x${size} matrix multiplication!"
    elif [[ "$TX_HASH" == *"Error"* ]]; then
        echo "❌ Failed: $TX_HASH"
    else
        echo "✅ Success: Transaction sent - Hash: $TX_HASH"
    fi
}

# Execute contract deployment
deploy_contract

# Test matrix sizes: 10, 20, 30, 40, 50
for SIZE in 10 20 30 40; do
    send_matrix_transaction "$SIZE"
done

echo "✅ All matrix multiplications attempted!"
