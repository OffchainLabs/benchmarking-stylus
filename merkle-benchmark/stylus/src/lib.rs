
#![cfg_attr(not(any(feature = "export-abi", test)), no_main)]
extern crate alloc;

use stylus_sdk::{prelude::*, storage::{StorageU256, StorageArray}, crypto::keccak};
use alloy_primitives::U256;

#[storage]
#[entrypoint]
pub struct MerkleTreeContract {
    pub leaves: StorageArray<StorageU256, 100>, // Storage array to hold leaves
    pub root: StorageU256,                      // Store the Merkle root
}

#[public]
impl MerkleTreeContract {
    /// Construct the entire Merkle tree from a batch of leaf values
    pub fn construct_tree(&mut self, leaf_values: Vec<U256>) {
        let n = leaf_values.len();
        assert!(n <= 100, "Too many leaves. Maximum is 100.");

        // Step 1: Store the leaf values in the storage array
        for (i, leaf_value) in leaf_values.into_iter().enumerate() {
            let mut storage_leaf = self.leaves.setter(i as u32).unwrap();
            storage_leaf.set(leaf_value);
        }

        // Step 2: Calculate and update the root of the Merkle tree
        self.update_root(); // This will compute the root based on all leaf values
    }

    /// Hash two nodes together and return the new parent node
    fn hash_nodes(&self, left: U256, right: U256) -> U256 {
        let combined = [&left.to_be_bytes::<32>()[..], &right.to_be_bytes::<32>()[..]].concat();
        keccak(combined).into() // Use `.into()` to convert FixedBytes<32> to U256
    }

    /// Calculate and update the Merkle root based on the current leaf values
    pub fn update_root(&mut self) {
        let mut nodes = vec![];
        for i in 0..self.leaves.len() {
            let storage_elem = self.leaves.get(i as u32).unwrap(); // Get StorageU256 element
            let leaf_value = storage_elem;                        // Use the StorageU256 directly
            nodes.push(leaf_value);
        }

        while nodes.len() > 1 {
            let mut next_level = vec![];
            for i in (0..nodes.len()).step_by(2) {
                let left = nodes[i];
                let right = if i + 1 < nodes.len() { nodes[i + 1] } else { left }; // Handle odd nodes
                next_level.push(self.hash_nodes(left, right));
            }
            nodes = next_level;
        }

        // Step 3: Update the root
        self.root.set(nodes[0]);
    }

    /// Get the current Merkle root
    pub fn get_root(&self) -> U256 {
        self.root.get()
    }

    /// Clear the Merkle tree leaves
    pub fn clear_tree(&mut self) {
        for i in 0..self.leaves.len() as u32 {
        }
    }
}