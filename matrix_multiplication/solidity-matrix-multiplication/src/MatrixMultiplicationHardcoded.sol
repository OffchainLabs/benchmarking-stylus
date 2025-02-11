// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MatrixMultiplication {
    uint256[40][40] private A;
    uint256[40][40] private B;

    constructor() {
        // Initialize matrix A
        uint256 counter = 1;
        for (uint256 i = 0; i < 40; i++) {
            for (uint256 j = 0; j < 40; j++) {
                A[i][j] = counter % 10; // Keep values small to prevent unnecessary gas cost
                counter++;
            }
        }

        // Initialize matrix B
        counter = 1;
        for (uint256 i = 0; i < 40; i++) {
            for (uint256 j = 0; j < 40; j++) {
                B[i][j] = (counter * 2) % 10; // Example pattern
                counter++;
            }
        }
    }

    function multiply() public view returns (uint256[40][40] memory C) {
        for (uint256 i = 0; i < 40; i++) {
            for (uint256 j = 0; j < 40; j++) {
                uint256 sum = 0;
                for (uint256 k = 0; k < 40; k++) {
                    unchecked {
                        sum += A[i][k] * B[k][j]; // No risk of overflow with uint256
                    }
                }
                C[i][j] = sum;
            }
        }
        return C;
    }

}
