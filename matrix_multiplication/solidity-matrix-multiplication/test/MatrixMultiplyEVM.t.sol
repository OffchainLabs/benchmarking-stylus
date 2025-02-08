// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
interface IMatrixMultiplication {
    function multiply(
        uint256[][] memory A,
        uint256[][] memory B
    ) external pure returns (uint256[][] memory);
}

contract MatrixMultiplyEVMTest is Test {
    IMatrixMultiplication matrix;

    address constant MATRIX_CONTRACT_ADDRESS =
        0x8dc4287894e7dbBb3550aE3DfFAdC0901E79fDF5; // Replace with your deployed contract address

    function setUp() public {
        // Set the deployed contract address
        matrix = IMatrixMultiplication(MATRIX_CONTRACT_ADDRESS);
    }

    /// @notice Test for 5x5 matrix multiplication
    function testMatrixMultiply5x5() view public {
        uint256[][] memory A = new uint256[][](5);
        for (uint256 i = 0; i < 5; i++) {
            A[i] = new uint256[](5);
        }
        uint256[][] memory B = new uint256[][](5);
        for (uint256 i = 0; i < 5; i++) {
            B[i] = new uint256[](5);
        }

        for (uint256 i = 0; i < 5; i++) {
            for (uint256 j = 0; j < 5; j++) {
                A[i][j] = uint256(i + j); // Larger values to increase computation
                B[i][j] = uint256(i + j + 1); // Larger values to increase computation
            }
        }

        // Perform the multiplication
        uint256[][] memory C = matrix.multiply(A, B);

        // Compute expected values dynamically
        for (uint256 i = 0; i < 5; i++) {
            for (uint256 j = 0; j < 5; j++) {
                uint256 expected = 0;
                for (uint256 k = 0; k < 5; k++) {
                    expected += A[i][k] * B[k][j];
                }
                assertEq(C[i][j], expected); // Validate correct multiplication
            }
        }
    }

    /// @notice Test for 10x10 matrix multiplication
    function testMatrixMultiply10x10() view public {
        uint256[][] memory A = new uint256[][](10);
        for (uint256 i = 0; i < 10; i++) {
            A[i] = new uint256[](10);
        }
        uint256[][] memory B = new uint256[][](10);
        for (uint256 i = 0; i < 10; i++) {
            B[i] = new uint256[](10);
        }

        for (uint256 i = 0; i < 10; i++) {
            for (uint256 j = 0; j < 10; j++) {
                A[i][j] = uint256(i + j); // Larger values to increase computation
                B[i][j] = uint256(i + j + 1); // Larger values to increase computation
            }
        }

        // Perform the multiplication
        uint256[][] memory C = matrix.multiply(A, B);

        // Compute expected values dynamically
    for (uint256 i = 0; i < 10; i++) {
        for (uint256 j = 0; j < 10; j++) {
            uint256 expected = 0;
            for (uint256 k = 0; k < 10; k++) {
                expected += A[i][k] * B[k][j]; // Correctly sum up the expected value
            }
            assertEq(C[i][j], expected, "Mismatch in 10x10 matrix multiplication");
        }
    }
}

    /// @notice Test for 50x50 matrix multiplication
    function testMatrixMultiply50x50() public view {
        // Allocate and initialize a 50x50 matrix A
        uint256[][] memory A = new uint256[][](50);
        for (uint256 i = 0; i < 50; i++) {
            A[i] = new uint256[](50);
        }
        uint256[][] memory B = new uint256[][](50);
        for (uint256 i = 0; i < 50; i++) {
            B[i] = new uint256[](50);
        }

        for (uint256 i = 0; i < 50; i++) {
            for (uint256 j = 0; j < 50; j++) {
                A[i][j] = uint256(i + j); // Larger values to increase computation
                B[i][j] = uint256(i + j + 1); // Larger values to increase computation
            }
        }

        // Perform the multiplication
        uint256[][] memory C = matrix.multiply(A, B);

            // Compute expected values dynamically
    for (uint256 i = 0; i < 50; i++) {
        for (uint256 j = 0; j < 50; j++) {
            uint256 expected = 0;
            for (uint256 k = 0; k < 50; k++) {
                expected += A[i][k] * B[k][j]; // Correctly sum up the expected value
            }
            assertEq(C[i][j], expected, "Mismatch in 10x10 matrix multiplication");
        }
    }
}
     /// @notice Test for 50x50 matrix multiplication
    function testMatrixMultiply100x100() public view {
        // Allocate and initialize a 50x50 matrix A
        uint256[][] memory A = new uint256[][](100);
        for (uint256 i = 0; i < 100; i++) {
            A[i] = new uint256[](100);
        }
        uint256[][] memory B = new uint256[][](100);
        for (uint256 i = 0; i < 100; i++) {
            B[i] = new uint256[](100);
        }

        for (uint256 i = 0; i < 100; i++) {
            for (uint256 j = 0; j < 100; j++) {
                A[i][j] = uint256(i + j); // Larger values to increase computation
                B[i][j] = uint256(i + j + 1); // Larger values to increase computation
            }
        }

        // Perform the multiplication
        uint256[][] memory C = matrix.multiply(A, B);

            // Compute expected values dynamically
    for (uint256 i = 0; i < 100; i++) {
        for (uint256 j = 0; j < 100; j++) {
            uint256 expected = 0;
            for (uint256 k = 0; k < 100; k++) {
                expected += A[i][k] * B[k][j]; // Correctly sum up the expected value
            }
            assertEq(C[i][j], expected, "Mismatch in 10x10 matrix multiplication");
        }
    }
}

    
}
