#[cfg(feature = "export-abi")]
fn main() {
    merkle_tree_stylus::print_abi("MIT-OR-APACHE-2.0", "pragma solidity ^0.8.23;");
}