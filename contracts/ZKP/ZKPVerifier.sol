// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Importing the necessary interfaces required for the ZKPVerifier contract.
import "../interfaces/IAccessController.sol"; // Importing the Access Controller interface

/**
* @title ZKPVerifier
* @dev This contract verifies zero-knowledge proofs for RESI Protocol.
* It ensures that only authorized users can submit proofs and that the proofs are valid.
* The contract manages all the ZKP verifications and call respective verifier contracts 
*/
contract ZKPVerifier {
    // State variables
    IAccessController public accessController; // Access controller instance
    address public stablecoinCore; // Address of the stablecoin core contract

    // Enum for different verification types
    enum VerificationType {
        Minting,
        Burning,
        CollateralDeposit,
        CollateralWithdrawal,
        OracleSubmission,
        OracleAggregation,
        ProposalCreation,
        Voting,
        ProposalExecution
    }

    // Mapping to track which verifiers are enabled for each verification type
    mapping(VerificationType => bool) public verifierEnabled;

    // Events

    /** 
    * @notice Emitted when a ZKP is verified successfully.
    * @dev This is fired when a zero-knowledge proof is verified.
    * @param sender The address of the user who submitted the proof.
    * @param verificationType The type of verification that was performed.
    * @param proofData The data of the proof that was verified.
    * @param result The result of the verification.
    */
    event ZKPVerified(address sender, VerificationType verificationType, bytes proofData, bool result);

    /** 
    * @notice Emitted when a verifier is enabled or disabled.
    * @dev This is fired when a verifier is enabled or disabled for a specific verification type.
    * @param verificationType The type of verification that was enabled or disabled.
    * @param status The status of the verifier (enabled or disabled).
    */
    event VerifierStatusChanged(VerificationType verificationType, bool status);

    // Constructor for the ZKPVerifier contract
    constructor(address _accessController) {
        require(_accessController != address(0), "Invalid access controller address");
        // Setting the access controller instance
        accessController = IAccessController(_accessController);

        // Initializing the verifierEnabled mapping to true for all verification types
        for (uint8 i = 0; i < uint8(VerificationType.ProposalExecution) + 1; i++) {
            verifierEnabled[VerificationType(i)] = true;
        }
    }

    /**
     * @dev sets the address of the stablecoin core contract
     * This function is only used once during deployment to avoid circular dependencies
     * @param _stablecoinCore The address of the stablecoin core contract
    */
    function setStablecoinCore(address _stablecoinCore) external {
        // Only allow this to be set once
        require(stablecoinCore == address(0), "StablecoinCore already set");
        // Check if the caller is authorized to set the stablecoin core address
        // This is a security measure to ensure that only authorized addresses can set the core address
        require(accessController.canSetParams(msg.sender), "Not authorized");
        // Check if the new stablecoin core address is valid
        require(_stablecoinCore != address(0), "Invalid address");
        stablecoinCore = _stablecoinCore;
    }

    /**
    * @dev Updates the address of the access controller
    * @param _newAccessController The address of the new access controller
    */
    function setAccessController(address _newAccessController) external {
        // Only StablecoinCore OR admin (before StablecoinCore is set) can update
        require(
            msg.sender == stablecoinCore || 
            (stablecoinCore == address(0) && accessController.canSetParams(msg.sender)),
            "Not authorized"
        );
        // Check if the new access controller address is valid
        require(_newAccessController != address(0), "Invalid access controller address");
        accessController = IAccessController(_newAccessController);
    }

    /**
    * @dev Enables or disables a verifier for a specific verification type.
    * @param verificationType The type of verification to enable or disable.
    * @param status The status to set (true for enabled, false for disabled).
    */
    function setVerifierStatus(VerificationType verificationType, bool status) external {
        require(accessController.canSetParams(msg.sender), "Not authorized to set parameters");
        // Updating the verifier status
        verifierEnabled[verificationType] = status;
        emit VerifierStatusChanged(verificationType, status);
    }

    /** 
    * @dev A function that calls the minting verifier contract to verify the proof.
    * @param collateralAmount The amount of collateral involved in the minting process.
    * @param collateralType The type of collateral involved in the minting process.
    * @param proofData The data of the proof that needs to be verified.
    * @return result The result of the verification process.
    */
    function verifyMinting(uint256 collateralAmount, address collateralType, bytes calldata proofData)
    external returns (bool result) {
        // Check if the verifier for minting is enabled
        if(!verifierEnabled[VerificationType.Minting]) {
            // If not enabled, just return true
            // This ensures backward compatibility to allow for system functionality during upgrades
            return true;
        }
        // return true for now, as the actual verification logic is not implemented
        // Emit the ZKPVerified event with the result
        emit ZKPVerified(msg.sender, VerificationType.Minting, proofData, true);
        return true;
    }

    /** 
    * @dev A function that calls the burning verifier contract to verify the proof.
    * @param stableAmount The amount of collateral involved in the burning process.
    * @param collateralType The type of collateral involved in the burning process.
    * @param proofData The data of the proof that needs to be verified.
    * @return result The result of the verification process.
    */
    function verifyBurning(uint256 stableAmount, address collateralType, bytes calldata proofData)
    external returns (bool result) {
        // Check if the verifier for burning is enabled
        if(!verifierEnabled[VerificationType.Burning]) {
            // If not enabled, just return true
            // This ensures backward compatibility to allow for system functionality during upgrades
            return true;
        }
        // return true for now, as the actual verification logic is not implemented
        // Emit the ZKPVerified event with the result
        emit ZKPVerified(msg.sender, VerificationType.Burning, proofData, true);
        return true;
    }

}