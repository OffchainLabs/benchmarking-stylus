// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// NOTE: These tests are designed to run in the Forge testing environment and are expected to pass
// because Forge does not impose the same computation or gas limitations as the Ethereum Virtual Machine (EVM).


import "forge-std/Test.sol";
import "../src/MatrixMultiplication.sol";

contract MatrixMultiplicationTest is Test {
    MatrixMultiplication public matrix;

    // Setup function to initialize the contract before each test
    function setUp() public {
        matrix = new MatrixMultiplication();
    }

    // Test 2x2 matrix multiplication
    function testMatrixMultiply2x2() public view {
        // Allocate and initialize a 2x2 matrix A
        uint256[][] memory A = new uint256[][](2);
        A[0] = new uint256[](2);
        A[1] = new uint256[](2);

        A[0][0] = 2;
        A[0][1] = 0;
        A[1][0] = 3;
        A[1][1] = 4;

        // Allocate and initialize a 2x2 matrix B
        uint256[][] memory B = new uint256[][](2);
        B[0] = new uint256[](2);
        B[1] = new uint256[](2);

        B[0][0] = 2;
        B[0][1] = 0;
        B[1][0] = 1;
        B[1][1] = 2;

        // Multiply matrices on-chain
        uint256[][] memory C = matrix.multiply(A, B);

        // Validate results
        assertEq(C[0][0], 4); // 2*2 + 0*1
        assertEq(C[0][1], 0); // 2*0 + 0*2
        assertEq(C[1][0], 10); // 3*2 + 4*1
        assertEq(C[1][1], 8); // 3*0 + 4*2
    }

    function testMatrixMultiply3x3() public view {
        // Allocate and initialize a 3x3 matrix A
        uint256[][] memory A = new uint256[][](3);
        A[0] = new uint256[](3);
        A[1] = new uint256[](3);
        A[2] = new uint256[](3);

        A[0][0] = 1;
        A[0][1] = 2;
        A[0][2] = 3;
        A[1][0] = 4;
        A[1][1] = 5;
        A[1][2] = 6;
        A[2][0] = 7;
        A[2][1] = 8;
        A[2][2] = 9;

        // Allocate and initialize a 3x3 matrix B
        uint256[][] memory B = new uint256[][](3);
        B[0] = new uint256[](3);
        B[1] = new uint256[](3);
        B[2] = new uint256[](3);

        B[0][0] = 9;
        B[0][1] = 8;
        B[0][2] = 7;
        B[1][0] = 6;
        B[1][1] = 5;
        B[1][2] = 4;
        B[2][0] = 3;
        B[2][1] = 2;
        B[2][2] = 1;

        // Multiply matrices on-chain
        uint256[][] memory C = matrix.multiply(A, B);

        // Validate the result matrix C
        // First row of C
        assertEq(C[0][0], 30); // 1*9 + 2*6 + 3*3
        assertEq(C[0][1], 24); // 1*8 + 2*5 + 3*2
        assertEq(C[0][2], 18); // 1*7 + 2*4 + 3*1

        // Second row of C
        assertEq(C[1][0], 84); // 4*9 + 5*6 + 6*3
        assertEq(C[1][1], 69); // 4*8 + 5*5 + 6*2
        assertEq(C[1][2], 54); // 4*7 + 5*4 + 6*1

        // Third row of C
        assertEq(C[2][0], 138); // 7*9 + 8*6 + 9*3
        assertEq(C[2][1], 114); // 7*8 + 8*5 + 9*2
        assertEq(C[2][2], 90); // 7*7 + 8*4 + 9*1
    }

    function testMatrixMultiply10x10() public view {
        // Allocate and initialize a 10x10 matrix A
        uint256[][] memory A = new uint256[][](10);
        for (uint256 i = 0; i < 10; i++) {
            A[i] = new uint256[](10);
        }

        // Fill values for matrix A (arbitrary values for testing)
        for (uint256 i = 0; i < 10; i++) {
            for (uint256 j = 0; j < 10; j++) {
                A[i][j] = 1; // Example: A[i][j] = i + j
            }
        }

        // Allocate and initialize a 10x10 matrix B
        uint256[][] memory B = new uint256[][](10);

        //Allocate each rvalues for matrix B (arbitrary values for testing)
        for (uint256 i = 0; i < 10; i++) {
            B[i] = new uint256[](10);
        }
        for (uint256 i = 0; i < 10; i++) {
            for (uint256 j = 0; j < 10; j++) {
                B[i][j] = 1; // Example: B[i][j] = i - j
            }
        }

        // Perform the multiplication
        uint256[][] memory C = matrix.multiply(A, B);

        // Validate the result matrix C
        for (uint256 i = 0; i < 10; i++) {
            for (uint256 j = 0; j < 10; j++) {
                assertEq(C[i][j], 10); // Each element of C should be 10 (1 * 1 summed over 10 terms)
            }
        }
    }
    function testMatrixMultiply50x50() view public {
        // Allocate and initialize a 50x50 matrix A
        uint256[][] memory A = new uint256[][](50);
        for (uint256 i = 0; i < 50; i++) {
            A[i] = new uint256[](50);
        }

        // Fill values for matrix A (arbitrary values for testing)
        for (uint256 i = 0; i < 50; i++) {
            for (uint256 j = 0; j < 50; j++) {
                A[i][j] = 1; // Example: A[i][j] = i + j
            }
        }

        // Allocate and initialize a 150x50 matrix B
        uint256[][] memory B = new uint256[][](50);

        //Allocate each rvalues for matrix B (arbitrary values for testing)
        for (uint256 i = 0; i < 50; i++) {
            B[i] = new uint256[](50);
        }
        for (uint256 i = 0; i < 50; i++) {
            for (uint256 j = 0; j < 50; j++) {
                B[i][j] = 1; // Example: B[i][j] = i - j
            }
        }

        // Perform the multiplication
        uint256[][] memory C = matrix.multiply(A, B);

        // Validate the result matrix C
        for (uint256 i = 0; i < 10; i++) {
            for (uint256 j = 0; j < 10; j++) {
                assertEq(C[i][j], 50); // Each element of C should be 10 (1 * 1 summed over 50 terms)
            }
        }
    }
}
