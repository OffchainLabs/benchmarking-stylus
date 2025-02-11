# Matrix Multiplication in Solidity

This repository demonstrates matrix multiplication in Solidity, including comprehensive tests using the [Foundry](https://book.getfoundry.sh/)  framework. The tests validate the correctness of matrix multiplication for various dimensions, both in a simulated environment and on the Arbitrum Sepolia testnet.


## Overview

Matrix multiplication is a computationally intensive operation, especially on-chain. This project includes:

1. Two Solidity implementations:
    - `MatrixMultiplicationHardcoded.sol` →  Uses a hardcoded matrix to bypass calldata size limitations.
    - `MatrixMultiplication.sol` → Accepts dynamic matrix input for flexible testing up to 40×40.

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

3. Run the Script for `10×10` to `40×40` Multiplication:

This script deploys the contract and sends transactions for matrix sizes 10×10 to 40×40 dynamically.

```bash
    cd script
    bash matrix_tx_sender.sh
```

3. Handling Hardcoded Matrices of Any Size

Arbitrum enforces a calldata size limit of `131072` bytes, but larger matrices (e.g., 50×50) exceed this limit.

✅ Solution: The `MatrixMultiplicationHardcoded.sol` contract pre-defines a hardcoded matrix inside the contract to bypass this limit.

Run the script for **any hardcoded matrix size**:

```bash
    bash matrix_hardcoded.sh
```

## What Each Script Does

| Script                   | Purpose |
|--------------------------|---------|
| `matrix_tx_sender.sh`     | Deploys `MatrixMultiplication.sol` and runs **10×10 to 40×40** dynamically. |
| `matrix_hardcoded.sh`  | Deploys `MatrixMultiplicationHardcoded.sol` and runs any hardcoded matrix size detected from the contract. |


### Conclusion

🚀 Happy Benchmarking! 🚀