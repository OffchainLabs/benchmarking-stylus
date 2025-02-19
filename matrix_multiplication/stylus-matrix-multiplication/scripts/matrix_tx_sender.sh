#!/bin/bash

# Load environment variables from .env in the root directory
ENV_FILE="../.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "❌ Error: .env file not found at $ENV_FILE!"
    exit 1
fi

# Ensure necessary environment variables are set
if [ -z "$PRIVATE_KEY" ] || [ -z "$SEPOLIA_RPC" ] || [ -z "$CONTRACT_ADDRESS" ]; then
    echo "❌ Error: Missing required environment variables!"
    exit 1
fi

# Fetch Ethereum address from private key
ETH_FROM=$(cast wallet address --private-key "$PRIVATE_KEY")
export ETH_FROM

send_matrix_transaction() {
    local size=$1
    local seed_a=42  # Fixed seed for matrix A
    local seed_b=84  # Fixed seed for matrix B

    echo "🚀 Sending transaction for ${size}x${size} matrix with seeds ($seed_a, $seed_b)..."

    # Fetch current nonce dynamically
    NONCE=$(cast nonce "$ETH_FROM" --rpc-url "$SEPOLIA_RPC")

    # Estimate gas limit
    GAS_LIMIT=5000000

    # Send transaction calling `multiply(uint32, uint64, uint64)`
    TX_HASH=$(cast send "$CONTRACT_ADDRESS" \
        "multiply(uint32,uint64,uint64)" "$size" "$seed_a" "$seed_b" \
        --from "$ETH_FROM" --rpc-url "$SEPOLIA_RPC" \
        --nonce "$NONCE" --gas-limit "$GAS_LIMIT" --private-key "$PRIVATE_KEY" 2>&1)

    # Check transaction result
    if [[ "$TX_HASH" == *"out of gas"* ]]; then
        echo "❌ Out of Gas for ${size}x${size} matrix!"
    else
        echo "✅ Success: $TX_HASH"
    fi
}

# Send transactions for different matrix sizes
for size in 10 20 30 40 50 60 70; do
    send_matrix_transaction "$size"
done

echo "✅ All transactions attempted!"
