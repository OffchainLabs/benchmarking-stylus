#![cfg_attr(not(feature = "export-abi"), no_main)]
extern crate alloc;

use alloc::vec::Vec;
use stylus_sdk::prelude::*;

const M: u64 = 2u64.pow(31);
const A: u64 = 1103515245;
const C: u64 = 12345;

sol_storage! {
    #[entrypoint]
    pub struct MatrixMultiplication {}
}

// PRNG (Linear Congruential Generator)
struct Rng {
    seed: u64,
}

impl Rng {
    fn new(seed: u64) -> Self {
        Self { seed }
    }

    fn next(&mut self) -> u64 {
        self.seed = (A.wrapping_mul(self.seed).wrapping_add(C)) % M;
        self.seed
    }
}

#[public]
impl MatrixMultiplication {
    /// Generates an `n x n` matrix using a PRNG
    fn generate_matrix(seed: u64, n: u32) -> Vec<Vec<i64>> {
        let n_usize = n as usize; // Convert `u32` to `usize` for indexing
        let mut rng = Rng::new(seed);
        let mut matrix = Vec::with_capacity(n_usize);

        for _ in 0..n_usize {
            let mut row = Vec::with_capacity(n_usize);
            for _ in 0..n_usize {
                row.push((rng.next() % 100) as i64); // Random numbers in range [0, 99]
            }
            matrix.push(row);
        }

        matrix
    }

    /// Multiplies two `n x n` matrices
    pub fn multiply(n: u32, seed_a: u64, seed_b: u64) -> Vec<Vec<i64>> {
        let a = Self::generate_matrix(seed_a, n);
        let b = Self::generate_matrix(seed_b, n);
        
        let n_usize = n as usize; // Convert `u32` to `usize` for indexing
        let mut c: Vec<Vec<i64>> = vec![vec![0; n_usize]; n_usize];

        for i in 0..n_usize {
            for j in 0..n_usize {
                for k in 0..n_usize {
                    c[i][j] += a[i][k] * b[k][j];
                }
            }
        }

        c
    }
}
