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

generate_matrix() {
    local size=$1
    local file="$OUTPUT_DIR/matrix_${size}x${size}.json"

    echo "[" > "$file"
    for ((i=0; i<size; i++)); do
        echo -n "    [" >> "$file"
        for ((j=0; j<size; j++)); do
            echo -n "$(( (i * j + RANDOM) % 10 ))" >> "$file"
            if [[ $j -lt $((size - 1)) ]]; then
                echo -n ", " >> "$file"
            fi
        done
        if [[ $i -lt $((size - 1)) ]]; then
            echo "]," >> "$file"
        else
            echo "]" >> "$file"
        fi
    done
    echo "]" >> "$file"

    echo "✅ Generated $file"
}

send_matrix_transaction() {
    local size=$1
    local matrix_file="$OUTPUT_DIR/matrix_${size}x${size}.json"

    MATRIX_A=$(jq -c . "$matrix_file")
    MATRIX_B=$(jq -c . "$matrix_file")

    echo "🚀 Sending transaction for ${size}x${size} matrix..."

    # Fetch current nonce dynamically
    NONCE=$(cast nonce "$ETH_FROM" --rpc-url "$SEPOLIA_RPC")
    
    # Estimate gas limit
    GAS_LIMIT=$(cast estimate "$CONTRACT_ADDRESS" \
        "multiply(uint256[][],uint256[][])" "$MATRIX_A" "$MATRIX_B" \
        --rpc-url "$SEPOLIA_RPC" 2>/dev/null)

    TX_HASH=$(cast send "$CONTRACT_ADDRESS" \
        "multiply(uint256[][],uint256[][])" \
        "$MATRIX_A" "$MATRIX_B" \
        --from "$ETH_FROM" --rpc-url "$SEPOLIA_RPC" \
        --nonce "$NONCE" --gas-limit "$GAS_LIMIT" --private-key "$PRIVATE_KEY" 2>&1)

    if [[ "$TX_HASH" == *"out of gas"* ]]; then
        echo "❌ Out of Gas for ${size}x${size} matrix!"
    else
        echo "✅ Success: $TX_HASH"
    fi
}

# Generate matrices
for size in 10 20 30 40 50; do
    generate_matrix "$size"
done

# Send transactions
for size in 10 20 30 40 50; do
    send_matrix_transaction "$size"
done

echo "✅ All transactions attempted!"
