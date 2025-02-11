// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MatrixMultiplication {
    function multiply(
        uint256[][] memory A,
        uint256[][] memory B
    ) public pure returns (uint256[][] memory) {
        uint256 n = A.length;
        require(n > 0 && B.length == n && B[0].length == n, "Invalid matrix dimensions");

        uint256[][] memory C = new uint256[][](n);
        for (uint256 i = 0; i < n; i++) {
            C[i] = new uint256[](n);
        }

        for (uint256 i = 0; i < n; i++) {
            for (uint256 j = 0; j < n; j++) {
                for (uint256 k = 0; k < n; k++) {
                    uint256 product;
                    unchecked {
                        product = A[i][k] * B[k][j]; // Allow multiplication without auto-revert
                    }
                    require(A[i][k] == 0 || product / A[i][k] == B[k][j], "Multiplication overflow");

                    uint256 sum;
                    unchecked {
                        sum = C[i][j] + product;
                    }
                    require(sum >= C[i][j], "Addition overflow");

                    C[i][j] = sum;
                }
            }
        }

        return C;
    }
}