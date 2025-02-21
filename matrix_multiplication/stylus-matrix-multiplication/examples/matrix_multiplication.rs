use ethers::{
    middleware::SignerMiddleware,
    prelude::abigen,
    providers::{Http, Middleware, Provider},
    signers::{LocalWallet, Signer},
    types::Address,
};
use dotenv::dotenv;
use eyre::Result;
use rand::Rng;
use std::{env, str::FromStr, sync::Arc};


const PRIV_KEY: &str = "PRIV_KEY";
const RPC_URL: &str = "RPC_URL";
const STYLUS_CONTRACT_ADDRESS: &str = "STYLUS_CONTRACT_ADDRESS";

abigen!(
    MatrixMultiplication,
    r#"[
        function multiply(int64[][] a, int64[][] b) external pure returns (int64[][])
    ]"#
);

#[tokio::main]
async fn main() -> Result<()> {
    dotenv().ok();

    // Read environment variables
    let priv_key = env::var(PRIV_KEY).expect(&format!("No {} env var set", PRIV_KEY));
    let rpc_url = env::var(RPC_URL).expect(&format!("No {} env var set", RPC_URL));
    let contract_address = env::var(STYLUS_CONTRACT_ADDRESS)
        .expect(&format!("No {} env var set", STYLUS_CONTRACT_ADDRESS));

    // Set up the provider and wallet
    let provider = Provider::<Http>::try_from(rpc_url)?;
    let address: Address = contract_address.parse()?;
    let wallet = LocalWallet::from_str(&priv_key)?;
    let chain_id = provider.get_chainid().await?.as_u64();
    let client = Arc::new(SignerMiddleware::new(
        provider,
        wallet.clone().with_chain_id(chain_id),
    ));

    // Instantiate the MatrixMultiplication contract
    let matrix = MatrixMultiplication::new(address, client);

    // Run 10x10 test
    println!("\n🔹 Running 10x10 matrix multiplication...");
    run_test(&matrix, 10, "random").await?;

    // Run 50x50 test
    println!("\n🔹 Running 50x50 matrix multiplication...");
    run_test(&matrix, 50, "sum").await?;

    Ok(())
}

/// Helper function to generate a matrix with **random values** within a given range
fn generate_random_matrix(rows: usize, cols: usize, min: i64, max: i64) -> Vec<Vec<i64>> {
    let mut rng = rand::thread_rng();
    (0..rows)
        .map(|_| (0..cols).map(|_| rng.gen_range(min..=max)).collect())
        .collect()
}

/// Helper function to generate a matrix where each element is `i + j`
fn generate_matrix_sum(rows: usize, cols: usize) -> Vec<Vec<i64>> {
    (0..rows)
        .map(|i| (0..cols).map(|j| (i + j) as i64).collect())
        .collect()
}

/// Helper function to generate a matrix where each element is `i - j`
fn generate_matrix_diff(rows: usize, cols: usize) -> Vec<Vec<i64>> {
    (0..rows)
        .map(|i| (0..cols).map(|j| (i - j) as i64).collect())
        .collect()
}

/// Verifies the correctness of the matrix multiplication result
fn verify_result(result: Vec<Vec<i64>>, expected_value: i64, size: usize) -> bool {
    for row in 0..size {
        for col in 0..size {
            if result[row][col] != expected_value {
                return false;
            }
        }
    }
    true
}

/// Runs a matrix multiplication test for a given size with a specified matrix generation type
async fn run_test(
    matrix: &MatrixMultiplication<SignerMiddleware<Provider<Http>, LocalWallet>>,
    size: usize,
    matrix_type: &str,
) -> Result<()> {
    let (a, b) = match matrix_type {
        "random" => (
            generate_random_matrix(size, size, -10, 10),
            generate_random_matrix(size, size, 1, 5),
        ),
        "sum" => (generate_matrix_sum(size, size), generate_matrix_sum(size, size)),
        "diff" => (generate_matrix_diff(size, size), generate_matrix_diff(size, size)),
        _ => (generate_random_matrix(size, size, 1, 5), generate_random_matrix(size, size, 1, 5)),
    };

    println!("🟢 Matrix A:");
    print_matrix(&a);
    println!("🟢 Matrix B:");
    print_matrix(&b);

    // Estimate gas
    println!("Estimating gas for {}x{}...", size, size);
    let gas_estimate = matrix.multiply(a.clone(), b.clone()).estimate_gas().await?;
    println!("⚡ Gas estimate for {}x{} matrix multiplication: {}", size, size, gas_estimate);

    // Execute matrix multiplication
    println!("Executing {}x{} matrix multiplication...", size, size);
    let result = matrix.multiply(a.clone(), b.clone()).call().await?;
    println!("🔵 {}x{} Matrix multiplication result:", size, size);
    print_matrix(&result);

    Ok(())
}

/// Helper function to print matrices neatly
fn print_matrix(matrix: &Vec<Vec<i64>>) {
    for row in matrix.iter().take(5) {
        println!("{:?}", row.iter().take(5).collect::<Vec<_>>()); // Show only first 5x5 for readability
    }
    println!("...");
}
