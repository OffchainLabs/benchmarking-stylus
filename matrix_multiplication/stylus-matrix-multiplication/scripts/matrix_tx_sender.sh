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
if [ -z "$PRIVATE_KEY" ] || [ -z "$RPC_URL" ]; then
    echo "❌ Error: Missing required environment variables!"
    exit 1
fi

# Move to the root directory before running the deployment
cd "$(dirname "$0")/.." || exit 1

# Deploy the contract and retrieve the deployed address
DEPLOY_OUTPUT=$(cargo stylus deploy --endpoint "$RPC_URL" --private-key "$PRIVATE_KEY" 2>&1)
if [[ "$DEPLOY_OUTPUT" == *"Error"* ]]; then
    echo "❌ Contract deployment failed!"
    echo "$DEPLOY_OUTPUT"
    exit 1
fi

# Extract contract address from deployment output
CONTRACT_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep -oE '0x[a-fA-F0-9]{40}' | head -n 1)
if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "❌ Failed to extract contract address!"
    exit 1
fi

echo "✅ Contract deployed at: $CONTRACT_ADDRESS"
export CONTRACT_ADDRESS

# Attempt to cache the deployed contract
CACHE_OUTPUT=$(cargo stylus cache bid \
    --private-key="$PRIVATE_KEY" \
    --endpoint="$RPC_URL" \
    "$CONTRACT_ADDRESS" 0 2>&1)

if [[ "$CACHE_OUTPUT" == *"Stylus contract is already cached"* ]]; then
    echo "ℹ️ Contract is already cached. Skipping caching step."
elif [[ "$CACHE_OUTPUT" == *"Error"* ]]; then
    echo "❌ Contract caching failed!"
    echo "$CACHE_OUTPUT"
    exit 1
else
    echo "✅ Contract cached successfully!"
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
    NONCE=$(cast nonce "$ETH_FROM" --rpc-url "$RPC_URL")

    # Estimate gas limit
    GAS_LIMIT=5000000

    # Send transaction calling `multiply(uint32, uint64, uint64)`
    TX_HASH=$(cast send "$CONTRACT_ADDRESS" \
        "multiply(uint32,uint64,uint64)" "$size" "$seed_a" "$seed_b" \
        --from "$ETH_FROM" --rpc-url "$RPC_URL" \
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
