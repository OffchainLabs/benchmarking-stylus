# Matrix Multiplication in Stylus

This folder contains the Stylus implementation of matrix multiplication, optimized for efficient execution using Rust-based smart contracts on Arbitrum Stylus.

## Overview

1. Matrix multiplication is a computationally intensive operation, especially on-chain. This project includes:

   - `lib.rs` → Implements matrix multiplication using a pseudo-random number generator (PRNG) for matrix generation.

2. Transaction sender script:
   - `matrix_tx_sender.sh` → Sends matrix multiplication transactions (10×10 to 40x40), note that the script requires manual contract deployment before execution.

## Prerequisites

1. **Foundry Installation**: Install Foundry by following the [Foundry installation guide](https://book.getfoundry.sh/getting-started/installation.html).

2. **`cargo stylus` Installation**: Install `cargo stylus` using the following command.

```bash
    cargo install cargo-stylus
```

3. **jq**: A lightweight JSON parsing tool used to extract contract addresses from the script output. Install jq by following the [official installation guide](https://jqlang.org/download/) for your operating system.

## On-Chain Testing on Arbitrum Sepolia:

1. Copy the example env file:

```bash
    cp .env.example .env
```

Then, open `.env `and fill in the required fields:

```bash
    RPC_URL=https://sepolia-rollup.arbitrum.io/rpc
    PRIVATE_KEY=0xYourPrivateKeyHere
    STYLUS_CONTRACT_ADDRESS= # Leave empty until deployment
```

2. Deploy the contract: Before running transactions, manually deploy the contract:

```bash
    cargo stylus deploy \
        --endpoint "$RPC_URL" \
        --private-key "$PRIVATE_KEY"
```

Once deployment is complete, copy the contract address from the output and update `.env`.

3. Cache the contract: In order to cache the contract after deployment, run:

```bash
  cargo stylus cache bid \
    --private-key="$PRIVATE_KEY" \
    --endpoint="$RPC_URL" \
    $STYLUS_CONTRACT_ADDRESS 0

```

4. Run the Script for `10×10` to `40×40` Multiplication: Once the contract is deployed and cached, run the script:

```bash
    cd script
    bash matrix_tx_sender.sh
```

This script sends transactions for matrix sizes `10×10` to `40×40` dynamically, using PRNG to generate input matrices.
