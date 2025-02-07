// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
interface IMatrixMultiplication {
    function multiply(
        int256[][] memory A,
        int256[][] memory B
    ) external pure returns (int256[][] memory);
}

contract MatrixMultiplyEVMTest is Test {
    IMatrixMultiplication matrix;

    address constant MATRIX_CONTRACT_ADDRESS =
        0x52258Bb3C17fAe945a3cbA4a56ceBE8807ef8F9D; // Replace with your deployed contract address

    function setUp() public {
        // Set the deployed contract address
        matrix = IMatrixMultiplication(MATRIX_CONTRACT_ADDRESS);
    }

    /// @notice Test for 5x5 matrix multiplication
    function testMatrixMultiply5x5() view public {
        int256[][] memory A = new int256[][](5);
        for (uint256 i = 0; i < 5; i++) {
            A[i] = new int256[](5);
        }
        int256[][] memory B = new int256[][](5);
        for (uint256 i = 0; i < 5; i++) {
            B[i] = new int256[](5);
        }

        for (uint256 i = 0; i < 5; i++) {
            for (uint256 j = 0; j < 5; j++) {
                A[i][j] = int256(i + j); // Larger values to increase computation
                B[i][j] = int256(i - j); // Larger values to increase computation
            }
        }

        // Perform the multiplication
        int256[][] memory C = matrix.multiply(A, B);

        // Compute expected values dynamically
        for (uint256 i = 0; i < 5; i++) {
            for (uint256 j = 0; j < 5; j++) {
                int256 expected = 0;
                for (uint256 k = 0; k < 5; k++) {
                    expected += A[i][k] * B[k][j];
                }
                assertEq(C[i][j], expected); // Validate correct multiplication
            }
        }
    }

    /// @notice Test for 10x10 matrix multiplication
    function testMatrixMultiply10x10() view public {
        int256[][] memory A = new int256[][](10);
        for (uint256 i = 0; i < 10; i++) {
            A[i] = new int256[](10);
        }
        int256[][] memory B = new int256[][](10);
        for (uint256 i = 0; i < 10; i++) {
            B[i] = new int256[](10);
        }

        for (uint256 i = 0; i < 10; i++) {
            for (uint256 j = 0; j < 10; j++) {
                A[i][j] = int256(i + j); // Larger values to increase computation
                B[i][j] = int256(i - j); // Larger values to increase computation
            }
        }

        // Perform the multiplication
        int256[][] memory C = matrix.multiply(A, B);

        // Validate the result matrix C
        // Each element in the resulting matrix C should be the sum of 50 terms (1 * 1)
        for (uint256 i = 0; i < 10; i++) {
            for (uint256 j = 0; j < 10; j++) {
                assertEq(C[i][j], 10); // Each cell in C should equal 50
            }
        }
    }

    /// @notice Test for 50x50 matrix multiplication
    function testMatrixMultiply50x50() public view {
        // Allocate and initialize a 50x50 matrix A
        int256[][] memory A = new int256[][](50);
        for (uint256 i = 0; i < 50; i++) {
            A[i] = new int256[](50);
        }
        int256[][] memory B = new int256[][](50);
        for (uint256 i = 0; i < 50; i++) {
            B[i] = new int256[](50);
        }

        for (uint256 i = 0; i < 50; i++) {
            for (uint256 j = 0; j < 50; j++) {
                A[i][j] = int256(i + j); // Larger values to increase computation
                B[i][j] = int256(i - j); // Larger values to increase computation
            }
        }

        // Perform the multiplication
        int256[][] memory C = matrix.multiply(A, B);

        // Validate the result matrix C
        // Each element in the resulting matrix C should be the sum of 50 terms (1 * 1)
        for (uint256 i = 0; i < 50; i++) {
            for (uint256 j = 0; j < 50; j++) {
                assertEq(C[i][j], 50); // Each cell in C should equal 50
            }
        }
    }

    

    
}
