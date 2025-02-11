#!/bin/bash

# Load environment variables from .env in the root directory
ENV_FILE="../.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "❌ Error: .env file not found at $ENV_FILE!"
    exit 1
fi

# Ensure PRIVATE_KEY is set
if [ -z "$PRIVATE_KEY" ]; then
    echo "❌ Error: PRIVATE_KEY is not set in the .env file!"
    exit 1
fi

# Ensure SEPOLIA_RPC is set
if [ -z "$SEPOLIA_RPC" ]; then
    echo "❌ Error: SEPOLIA_RPC is not set in the .env file!"
    exit 1
fi

# Ensure CONTRACT_ADDRESS is set
if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "❌ Error: CONTRACT_ADDRESS is not set in the .env file!"
    exit 1
fi

# Fetch Ethereum address from private key
ETH_FROM=$(cast wallet address --private-key "$PRIVATE_KEY")
export ETH_FROM

# Define output directory
OUTPUT_DIR="data"
mkdir -p "$OUTPUT_DIR"

send_matrix_transaction() {
    echo "🚀 Sending transaction for 50x50 matrix..."

    # Fetch current nonce dynamically
    NONCE=$(cast nonce "$ETH_FROM" --rpc-url "$SEPOLIA_RPC")
    
    # Set a reasonable gas limit for matrix multiplication
    GAS_LIMIT=5000000

    # Send the transaction (no matrix data needed since it's hardcoded)
    TX_HASH=$(cast send "$CONTRACT_ADDRESS" \
        "multiply()" \
        --from "$ETH_FROM" --rpc-url "$SEPOLIA_RPC" \
        --nonce "$NONCE" --gas-limit "$GAS_LIMIT" --private-key "$PRIVATE_KEY" 2>&1)

    if [[ "$TX_HASH" == *"out of gas"* ]]; then
        echo "❌ Out of Gas!"
    elif [[ "$TX_HASH" == *"Error"* ]]; then
        echo "❌ Failed: $TX_HASH"
    else
        echo "✅ Success: Transaction sent - Hash: $TX_HASH"
    fi

    # Add a sleep between transactions to allow the nonce to update
    sleep 5
}

# Send transaction for the hardcoded 50x50 matrix
send_matrix_transaction

echo "✅ All transactions attempted!"
