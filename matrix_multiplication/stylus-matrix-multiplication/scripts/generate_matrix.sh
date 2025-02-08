#!/bin/bash

# Output directory
OUTPUT_DIR="data"
mkdir -p "$OUTPUT_DIR"

# Function to generate a JSON matrix
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
        echo "]," >> "$file"
    done
    echo "]" >> "$file"

    echo "✅ Generated $file"
}

# Generate 10x10 and 50x50 matrices
generate_matrix 10
generate_matrix 50

echo "All matrices generated successfully!"
