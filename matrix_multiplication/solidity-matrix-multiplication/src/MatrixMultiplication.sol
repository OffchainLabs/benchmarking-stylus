// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MatrixMultiplication {
    function multiply(
        int256[][] memory A,
        int256[][] memory B
    ) public pure returns (int256[][] memory) {
        uint256 n = A.length;
        require(n > 0 && B.length == n && B[0].length == n, "Invalid matrix dimensions");

        int256[][] memory C = new int256[][](n);
        for (uint256 i = 0; i < n; i++) {
            C[i] = new int256[](n);
        }

        for (uint256 i = 0; i < n; i++) {
            for (uint256 j = 0; j < n; j++) {
                for (uint256 k = 0; k < n; k++) {
                    C[i][j] += A[i][k] * B[k][j];
                }
            }
        }

        return C;
    }
}