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

# Function to generate a random 256-bit seed
generate_seed() {
    echo $(( RANDOM * RANDOM * RANDOM * RANDOM )) # Generates a pseudo-random large number
}

# Function to send the transaction with PRNG-based matrix generation
send_matrix_transaction() {
    local size=$1
    echo "🚀 Sending transaction for ${size}x${size} matrix multiplication..."

    # Generate two random seeds
    SEED_A=$(generate_seed)
    SEED_B=$(generate_seed)

    # Fetch current nonce dynamically
    NONCE=$(cast nonce "$ETH_FROM" --rpc-url "$RPC_URL")

    # Adjust gas limit dynamically based on matrix size
    if [ "$size" -le 10 ]; then
        GAS_LIMIT=5000000
    elif [ "$size" -le 20 ]; then
        GAS_LIMIT=15000000  # Increased for 20x20
    elif [ "$size" -le 30 ]; then
        GAS_LIMIT=25000000  # Increased for 30x30
    elif [ "$size" -le 40 ]; then
        GAS_LIMIT=32000000  # Max block gas limit
    else
        echo "❌ Matrix size too large for on-chain computation!"
        return
    fi

    # Send the transaction to call the multiply() function
    TX_HASH=$(cast send "$CONTRACT_ADDRESS" \
        "multiply(uint256,uint256,uint256)" \
        "$size" "$SEED_A" "$SEED_B" \
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

# Test matrix sizes: 10, 20, 30, 40
for SIZE in 10 20 30 40; do
    send_matrix_transaction "$SIZE"
done

echo "✅ All matrix multiplications attempted!"
