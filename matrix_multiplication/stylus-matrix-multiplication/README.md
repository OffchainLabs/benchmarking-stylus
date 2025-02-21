# Matrix Multiplication in Stylus

This folder contains the Stylus implementation of matrix multiplication, optimized for efficient execution using Rust-based smart contracts on Arbitrum Stylus.

## Overview

1. Matrix multiplication is a computationally intensive operation, especially on-chain. This project includes:

   - `lib.rs` → Implements matrix multiplication using a pseudo-random number generator (PRNG) for matrix generation.

2. Transaction sender script:
   - `matrix_tx_sender.sh` → This script deploys the contract, caches it to decrease transaction costs, and sends matrix multiplication transactions (10×10 to 40x40).
   
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
```

3. Run the Script for `10×10` to `40×40` Multiplication: This script deploys the contract and sends transactions for matrix sizes `10×10` to `40×40` dynamically, using PRNG to generate input matrices.

```bash
    cd script
    bash matrix_tx_sender.sh
```