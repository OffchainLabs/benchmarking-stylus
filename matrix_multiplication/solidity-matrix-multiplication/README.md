# Matrix Multiplication in Solidity

This repository demonstrates matrix multiplication in Solidity, including comprehensive tests using the [Foundry](https://book.getfoundry.sh/)  framework. The tests validate the correctness of matrix multiplication for various dimensions, both in a simulated environment and on the Arbitrum Sepolia testnet.


## Overview

Matrix multiplication is a computationally intensive operation, especially on-chain. This project includes:

- MatrixMultiplication.sol → Accepts dynamic matrix input for flexible testing up to 30×30. Larger matrix sizes (e.g., 40×40 and beyond) exceed gas limits and cannot be executed on-chain due to the cubic growth of gas costs.

2. Foundry tests for local and on-chain validation.

3. Transaction sender scripts:
    - `matrix_tx_sender.sh` → Sends matrix multiplication transactions (10×10 to 40×40).
    - `matrix_hardcoded.sh` → Detects and runs multiplication **any hardcoded matrix size** from the contract.

## Prerequisites

1. **Foundry Installation**: Install Foundry by following the [Foundry installation guide](https://book.getfoundry.sh/getting-started/installation.html).

2. jq: A lightweight JSON parsing tool used to extract contract addresses from the script output. Install jq by following the [official installation guide](https://jqlang.org/download/) for your operating system.

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

1. Ensure the contract is compiled before deploying:

```bash
    forge build
```

2. Ensure the `.env` file exists in the root directory with:

```bash
    PRIVATE_KEY=0xYourPrivateKeyHere
    RPC_URL=https://sepolia-rollup.arbitrum.io/rpc
```

3. Run the Script for `10×10` to `30×30` Multiplication: This script deploys the contract and sends transactions for matrix sizes 10×10 to 30×30 dynamically.

```bash
    cd script
    bash matrix_tx_sender.sh
```
