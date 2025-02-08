# Matrix Multiplication in Solidity

This repository demonstrates matrix multiplication in Solidity, including comprehensive tests using the [Foundry](https://book.getfoundry.sh/) framework. The tests validate the correctness of matrix multiplication for various dimensions, both in a simulated environment and on the Ethereum Sepolia testnet.


## Overview

Matrix multiplication is a computationally intensive operation, especially on-chain. This project includes:

1. **A Solidity implementation of matrix multiplication.**
2. **Foundry tests for local and on-chain validation.**
3. **A transaction sender script (`matrix_tx_sender.sh`) to generate matrices and interact with the deployed contract.**

## Prerequisites

1. **Foundry Installation**: Install Foundry by following the [Foundry installation guide](https://book.getfoundry.sh/getting-started/installation.html).

2. Setup Infura or Another RPC Provider: Create an Infura project (or use an alternative RPC provider) to get an RPC URL for the Sepolia testnet.

3. jq: A lightweight JSON parsing tool used to extract contract addresses from the script output. Install jq by following the [official installation guide](https://jqlang.org/download/) for your operating system.

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

## On-Chain Testing on Sepolia:

1. Ensure the contract is compiled before deploying:

```bash
    forge build
```

2. Deploy the contract: Use the `forge create` command to deploy the `MatrixMultiplication` contract to the Sepolia testnet:

```bash
    forge create \
    --rpc-url https://sepolia.infura.io/v3/<your-infura-project-id> \
    --private-key <your-private-key> \
    src/MatrixMultiplication.sol:MatrixMultiplication \
    --broadcast
```

Explanation of flags:

`--rpc-url`: The RPC URL for the Ethereum network (e.g., Sepolia).

`--private-key`: The private key of the deploying account. Note: Ensure this key is secured and not exposed.

`<contract-path>:<contract-name>`: Specifies the contract's source file and contract name (e.g., src/MatrixMultiplication.sol:MatrixMultiplication).

`--broadcast`: Broadcasts the transaction to the network.


3. Grab the deployed contract address: After deployment, Foundry will output the contract address. For example:

```bash
    Deployed contract to: 0x52258Bb3C17fAe945a3cbA4a56ceBE8807ef8F9D
```

4. Sending matrix transactions: Once the contract is deployed, use `matrix_tx_sender.sh` to:
- Generate matrices
- Send transactions to the deployed contract

### Setup

1. Ensure the `.env` file exists in the root directory (outside the script folder) with the following values:

```bash
    PRIVATE_KEY=0xYourPrivateKeyHere
    SEPOLIA_RPC=https://sepolia.infura.io/v3/<your-infura-project-id>
    CONTRACT_ADDRESS=0x52258Bb3C17fAe945a3cbA4a56ceBE8807ef8F9D
```

2. Run the script from the `script` folder:

```bash
    cd script
    bash matrix_tx_sender.sh
```

#### What This Script Does

✅ Generates JSON files representing random matrices.
✅ Sends transactions to multiply matrices on-chain.
✅ Automatically estimates gas and manages nonces.