// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MerkleTree {
    bytes32[] public hashes; // Stores the entire Merkle tree
    bytes32 public root; // Merkle tree root hash

    // Constructor that takes in an array of transaction strings and builds the Merkle tree
    constructor(string[] memory transactions) {
        uint256 n = transactions.length;

        // Step 1: Hash the transactions and store as leaf nodes
        for (uint256 i = 0; i < n; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }

        uint256 offset = 0;

        // Step 2: Build the tree up to the root
        while (n > 1) {
            for (uint256 i = 0; i < n - 1; i += 2) {
                hashes.push(
                    keccak256(
                        abi.encodePacked(
                            hashes[offset + i], 
                            hashes[offset + i + 1]
                        )
                    )
                );
            }
            offset += n;
            n = n / 2;
        }

        // Step 3: Set the Merkle root
        root = hashes[hashes.length - 1];
    }

    // Verify if a given leaf is part of the Merkle tree at a given index
    function verify(
        bytes32[] memory proof, 
        bytes32 leaf, 
        uint256 index
    ) public view returns (bool) {
        bytes32 hash = leaf;

        // Traverse the Merkle tree and hash accordingly
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, proofElement));
            } else {
                hash = keccak256(abi.encodePacked(proofElement, hash));
            }

            index = index / 2;
        }

        // Check if the resulting hash matches the root
        return hash == root;
    }

    // Helper function to get the entire tree for debugging purposes
    function getTree() public view returns (bytes32[] memory) {
        return hashes;
    }
}
