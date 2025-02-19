// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MatrixMultiplication {
    // Constants for the Linear Congruential Generator (LCG)
    uint256 private constant M = 2 ** 31; // Modulus
    uint256 private constant A = 1103515245; // Multiplier
    uint256 private constant C = 12345; // Increment

    /**
     * @dev Generates an `n x n` matrix filled with pseudo-random numbers.
     * @param seed The initial seed value for the random number generator.
     * @param n The size of the matrix (n x n).
     * @return A dynamically generated `n x n` matrix.
     */
    function generateMatrix(
        uint256 seed,
        uint256 n
    ) internal pure returns (uint256[][] memory) {
        uint256[][] memory matrix = new uint256[][](n); // Allocate outer array
        for (uint256 i = 0; i < n; i++) {
            matrix[i] = new uint256[](n); // Allocate inner arrays
        }

        for (uint256 i = 0; i < n; i++) {
            for (uint256 j = 0; j < n; j++) {
                // Apply Linear Congruential Generator (LCG) formula
                seed = (A * seed + C) % M;
                matrix[i][j] = seed % 100; // Keep values in range [0, 99]
            }
        }

        return matrix;
    }

    /**
     * @dev Multiplies two `n x n` matrices generated from two different seeds.
     * @param n The size of the matrices (n x n).
     * @param seedA The seed for generating the first matrix.
     * @param seedB The seed for generating the second matrix.
     * @return resultMatrix The resulting `n x n` matrix after multiplication.
     */
    function multiply(
        uint256 n,
        uint256 seedA,
        uint256 seedB
    ) public pure returns (uint256[][] memory resultMatrix) {
        require(n > 0, "Invalid matrix size"); // Ensure matrix size is positive

        // Allocate memory for the result matrix
        resultMatrix = new uint256[][](n);
        for (uint256 i = 0; i < n; i++) {
            resultMatrix[i] = new uint256[](n);
        }

        // Generate matrices A and B using pseudo-random number generator
        uint256[][] memory matrixA = generateMatrix(seedA, n);
        uint256[][] memory matrixB = generateMatrix(seedB, n);

        // Perform matrix multiplication: C[i][j] = Σ (A[i][k] * B[k][j])
        for (uint256 i = 0; i < n; i++) {
            for (uint256 j = 0; j < n; j++) {
                uint256 sum = 0; // Initialize sum for C[i][j]
                for (uint256 k = 0; k < n; k++) {
                    uint256 product;
                    unchecked {
                        product = matrixA[i][k] * matrixB[k][j]; // Multiplication
                    }
                    // Ensure no overflow occurred in multiplication
                    require(
                        matrixA[i][k] == 0 ||
                            product / matrixA[i][k] == matrixB[k][j],
                        "Multiplication overflow"
                    );

                    unchecked {
                        sum += product; // Accumulate sum
                    }
                    require(sum >= product, "Addition overflow"); // Prevent overflow in addition
                }
                resultMatrix[i][j] = sum; // Store result in C[i][j]
            }
        }

        return resultMatrix; // Return the final matrix
    }
}
