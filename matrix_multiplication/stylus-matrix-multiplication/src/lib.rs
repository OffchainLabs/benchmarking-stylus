#![cfg_attr(not(feature = "export-abi"), no_main)]
extern crate alloc;

use alloc::vec::Vec;
use stylus_sdk::prelude::*;

sol_storage! {
    #[entrypoint]
    pub struct MatrixMultiplication {}
}

#[public]
impl MatrixMultiplication {
    /// Multiplies two square matrices of size `n x n`
    pub fn multiply(a: Vec<Vec<i64>>, b: Vec<Vec<i64>>) -> Vec<Vec<i64>> {
        let n = a.len();

        // Ensure valid square matrix dimensions
        assert!(n > 0 && b.len() == n && b[0].len() == n, "Invalid matrix dimensions");

        // Initialize output matrix
        let mut c: Vec<Vec<i64>> = vec![vec![0; n]; n];

        // Perform matrix multiplication
        for i in 0..n {
            for j in 0..n {
                for k in 0..n {
                    c[i][j] += a[i][k] * b[k][j];
                }
            }
        }

        c
    }
}
