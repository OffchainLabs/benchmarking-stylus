// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/MerkleTree.sol";
contract MerkleTreeTest is Test {
    MerkleTree merkleTree;

    /// @dev Set up the test with a sample set of transactions to create a small Merkle tree.
    function setUp() public {
        string[] memory transactions =  new string[](4);
        transactions[0] = "alice -> bob";
        transactions[1] = "bob -> dave";
        transactions[2] = "carol -> alice";
        transactions[3] = "dave -> bob";

        merkleTree = new MerkleTree(transactions);
    }
    
    /// @dev Test if the root is computed correctly for the given set of transactions.
    function testMerkleRoot() public view{
        // Expected root value for the given transactions
        bytes32 expectedRoot = 0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7;
        assertEq(merkleTree.root(), expectedRoot, "Merkle root does not match the expected value");
    }

    /// @dev Test the verification function for a specific leaf ("carol -> alice") and its proof.
    function testVerifyProof() public view{
        // Proof for the third leaf ("carol -> alice") at index 2
        bytes32[] memory proof =  new bytes32[](2);
        proof[0] = 0x8da9e1c820f9dbd1589fd6585872bc1063588625729e7ab0797cfc63a00bd950;
        proof[1] = 0x995788ffc103b987ad50f5e5707fd094419eb12d9552cc423bd0cd86a3861433;

        // Leaf to be verified and its index in the original transactions
        bytes32 leaf = 0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b;
        // The index of the leaf in the original array (2 in this case)
        uint256 index = 2;

        // Call the verify function and check if the proof is valid
        bool result = merkleTree.verify(proof, leaf, index);
        assertTrue(result, "Proof verification failed for the third leaf");
    }

    /// @dev Test the verification function using an invalid proof (should fail).
    function testInvalidProof() public view {
        // Invalid proof for the third leaf
        bytes32[] memory proof =  new bytes32[](2);
        proof[0] = 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
        proof[1] = 0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb;

        bytes32 leaf = 0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b;
        uint256 index = 2;

        bool result = merkleTree.verify(proof, leaf, index);
        assertFalse(result, "Invalid proof should fail verification"); 
    }

    /// @dev Test the verification function with an empty proof (should fail).
    function testEmptyProof() public view {
        // Empty proof for the third leaf (invalid case)
        bytes32[] memory proof =  new bytes32[](1);
        bytes32 leaf = 0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b;
        uint256 index = 2;

        bool result = merkleTree.verify(proof, leaf, index);
        assertFalse(result, "Empty proof should fail verification");
    }

    /// @dev Test if the complete Merkle tree structure has the expected number of nodes.
    function testGetTree() public view{
        bytes32[] memory tree = merkleTree.getTree();
        assertEq(tree.length,7,  "Merkle tree node count mismatch: Expected 7 nodes"); // 4 leaves + 2 internal nodes + 1 root
    }

    /// @dev Test the Merkle root computation for a larger tree with 8 transactions.
    function testLargerTree() public {
        // Create a new set of 8 transactions
        string[] memory transactions =  new string[](8);
        transactions[0] = "alice -> bob";
        transactions[1] = "bob -> dave";
        transactions[2] = "carol -> alice";
        transactions[3] = "dave -> bob";
        transactions[4] = "eve -> frank";
        transactions[5] = "frank -> grace";
        transactions[6] = "grace -> eve";
        transactions[7] = "bob -> alice";

        // Create a new Merkle tree with these transactions
        MerkleTree largeMerkleTree = new MerkleTree(transactions);

        // Expected root for the larger Merkle tree
        bytes32 largeExpectedRoot = 0x938ea61fa3259ef3bda864920d6796bc85ab76197f1005a1770c74cbbdc50180;
        assertEq(largeMerkleTree.root(), largeExpectedRoot, "Larger Merkle tree root does not match the expected value");
    }

}