#![cfg_attr(not(feature = "export-abi"), no_main)]
extern crate alloc;

use alloc::vec::Vec;
use stylus_sdk::prelude::*;


// Constants for the Linear Congruential Generator (LCG)
const M: u64 = 2u64.pow(31); // Modulus
const A: u64 = 1103515245;   // Multiplier
const C: u64 = 12345;        // Increment

// Define the contract storage using `sol_storage!`
sol_storage! {
    #[entrypoint] // Marks this struct as the contract entry point
    pub struct MatrixMultiplication {} // No state variables since all functions are pure
}

// Pseudo-random number generator (PRNG) using the Linear Congruential Generator (LCG)
struct Rng {
    seed: u64,
}

impl Rng {
    /// Creates a new PRNG instance with a given seed
    fn new(seed: u64) -> Self {
        Self { seed }
    }

    /// Generates the next pseudo-random number using LCG formula
    fn next(&mut self) -> u64 {
        self.seed = (A.wrapping_mul(self.seed).wrapping_add(C)) % M; // Prevents overflow issues
        self.seed
    }
}

#[public] // Exposes functions publicly for contract interaction
impl MatrixMultiplication {
    /// Generates an `n x n` matrix filled with pseudo-random numbers
    fn generate_matrix(seed: u64, n: u32) -> Vec<Vec<i64>> {
        let n_usize = n as usize; // Convert `u32` to `usize` for safe indexing
        let mut rng = Rng::new(seed); // Initialize PRNG with given seed
        let mut matrix = Vec::with_capacity(n_usize); // Preallocate space for the matrix

        for _ in 0..n_usize {
            let mut row = Vec::with_capacity(n_usize); // Preallocate space for the row
            for _ in 0..n_usize {
                row.push((rng.next() % 100) as i64); // Generate numbers in range [0, 99]
            }
            matrix.push(row); // Append row to the matrix
        }

        matrix
    }

    /// Multiplies two `n x n` matrices
    pub fn multiply(n: u32, seed_a: u64, seed_b: u64) -> Vec<Vec<i64>> {
        let a = Self::generate_matrix(seed_a, n); // Generate matrix A
        let b = Self::generate_matrix(seed_b, n); // Generate matrix B

        let n_usize = n as usize; // Convert `u32` to `usize` for safe indexing
        let mut c: Vec<Vec<i64>> = vec![vec![0; n_usize]; n_usize]; // Initialize result matrix with zeros

        // Perform matrix multiplication: C[i][j] = Σ (A[i][k] * B[k][j])
        for i in 0..n_usize {
            for j in 0..n_usize {
                for k in 0..n_usize {
                    c[i][j] += a[i][k] * b[k][j]; // Accumulate product sum
                }
            }
        }

        c // Return the resulting matrix
    }
}