# Matrix Multiplication in Solidity

This folder contains matrix multiplication in Solidity, including comprehensive tests using the [Foundry](https://book.getfoundry.sh/) framework. The tests validate the correctness of matrix multiplication for various dimensions, both in a simulated environment and on the Arbitrum Sepolia testnet.

## Overview

1. Matrix multiplication is a computationally intensive operation, especially on-chain. This project includes:

   - `MatrixMultiplication.sol` → Implements matrix multiplication using pseudo-random number generation (PRNG) to generate test matrices dynamically. The contract accepts a matrix size n and two seed values to generate matrices up to 40×40. Larger sizes exceed gas limits and cannot be executed on-chain due to cubic gas cost growth.

2. Foundry tests for local and on-chain validation.

3. Transaction sender script:
   - `matrix_tx_sender.sh` → This script deploys the contract and sends matrix multiplication transactions (10×10 to 40x40).

## Prerequisites

1. **Foundry Installation**: Install Foundry by following the [Foundry installation guide](https://book.getfoundry.sh/getting-started/installation.html).

2. **jq**: A lightweight JSON parsing tool used to extract contract addresses from the script output. Install jq by following the [official installation guide](https://jqlang.org/download/) for your operating system.

## Local Testing (Using Foundry)

1. Clone the repository:

```bash
    git clone https://github.com/OffchainLabs/benchmarking-stylus.git
    cd mareix_multiplication
```

2. Build the project:

```bash
    forge build
```

3. Run the tests:

```bash
    forge test
```

These tests simulate matrix operations without EVM constraints, enabling the validation of larger matrices (e.g., 50x50).

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
