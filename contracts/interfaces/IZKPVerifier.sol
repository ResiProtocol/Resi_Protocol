// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
* @title IZKPVerifier
* @dev Interface for Zero-Knowledge Proof Verifier
* This interface defines the functions for the ZKP Verifier contract 
* which is responsible for verifying zero-knowledge proofs.
*/
interface IZKPVerifier {

    /**
    * @dev Updates the address of the access controller
    * @param _newAccessController The address of the new access controller
    */
    function setAccessController(address _newAccessController) external;

    /** 
    * @dev A function that calls the minting verifier contract to verify the proof.
    * @param collateralAmount The amount of collateral involved in the minting process.
    * @param collateralType The type of collateral involved in the minting process.
    * @param proofData The data of the proof that needs to be verified.
    * @return result The result of the verification process.
    */
    function verifyMinting(uint256 collateralAmount, address collateralType, bytes calldata proofData)
    external returns (bool result);

    /** 
    * @dev A function that calls the burning verifier contract to verify the proof.
    * @param stableAmount The amount of collateral involved in the burning process.
    * @param collateralType The type of collateral involved in the burning process.
    * @param proofData The data of the proof that needs to be verified.
    * @return result The result of the verification process.
    */
    function verifyBurning(uint256 stableAmount, address collateralType, bytes calldata proofData)
    external returns (bool result);
}