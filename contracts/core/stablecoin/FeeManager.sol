// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Importing the necessary libraries
import "@openzeppelin/contracts/access/Ownable.sol"; // Importing the Ownable contract from OpenZeppelin

/**
 * @title FeeManager
 * @dev This contract manages the fees for a stablecoin system. 
*/
contract FeeManager is Ownable {
    // State variables of the contract
    uint256 public stabilityFee; // Fee charged on minting (in basis points)
    uint256 public redemptionFee; // Fee charged on redemption (in basis points)

    // Constants
    uint256 private constant BASIS_POINTS = 10000; // Basis points constant for calculations

    /** 
     * @notice Emitted when the stability fee is updated
     * @dev This is fired during the updateStabilityFee function
     * @param newStabilityFee The new fee applied for stability maintenance
     */
    event StabilityFeeUpdated(uint256 newStabilityFee);

    /** 
     * @notice Emitted when the redemption fee is updated
     * @dev This is fired during the updateRedemptionFee function
     * @param newRedemptionFee The new fee applied when redeeming collateral
     */
    event RedemptionFeeUpdated(uint256 newRedemptionFee);

    // Constructor to initialize the FeeManager contract
    constructor() Ownable(msg.sender) {
        stabilityFee = 50; // Initial stability fee set to 0.5%
        redemptionFee = 30; // Initial redemption fee set to 0.3%
    }

    /** 
     * @dev Calculate the mint fee (Stability Fee) based on the amount
     * @param amount The amount to be minted
     * @return amountAfterFee The amount after the stability fee is deducted
     * @return feeAmount The amount of the stability fee charged
    */
    function calculateMintFee(uint256 amount) external view returns (uint256 amountAfterFee, uint256 feeAmount) {
        feeAmount = (amount * stabilityFee) / BASIS_POINTS; // Calculate the fee amount
        amountAfterFee = amount - feeAmount; // Calculate the amount after fee deduction
    }

    /** 
    * @dev Calculate the redemption fee based on the amount
    * @param amount The amount to be redeemed
    * @return amountAfterFee The amount after the redemption fee is deducted
    * @return feeAmount The amount of the redemption fee charged
    */
    function calculateRedemptionFee(uint256 amount) external view returns (uint256 amountAfterFee, uint256 feeAmount) {
        feeAmount = (amount * redemptionFee) / BASIS_POINTS; // Calculate the fee amount
        amountAfterFee = amount - feeAmount; // Calculate the amount after fee deduction
    }

    /** 
    * @dev Update the stability fee
    * @param _newStabilityFee New stability fee (in basis points)
    */
    function updateStabilityFee(uint256 _newStabilityFee) external onlyOwner {
        // Check if the new stability fee is valid (>0) and is at most 10% (1000 basis points)
        require(_newStabilityFee > 0 && _newStabilityFee <= 1000, "Stability fee must be between 0 and 10%");
        // Check if the new stability fee is different from the current stability fee
        // This prevents unnecessary updates which could lead to gas wastage
        require(_newStabilityFee != stabilityFee, "New stability fee must be different from current stability fee");

        stabilityFee = _newStabilityFee; // Update the stability fee
        emit StabilityFeeUpdated(_newStabilityFee); // Emit the event
    }

    /**
    * @dev Update the redemption fee
    * @param _newRedemptionFee New redemption fee (in basis points)
    */
    function updateRedemptionFee(uint256 _newRedemptionFee) external onlyOwner {
        // Check if the new redemption fee is valid (>0) and is at most 5% (500 basis points)
        require(_newRedemptionFee > 0 && _newRedemptionFee <= 500, "Redemption fee must be between 0 and 5%");
        // Check if the new redemption fee is different from the current redemption fee
        // This prevents unnecessary updates which could lead to gas wastage
        require(_newRedemptionFee != redemptionFee, "New redemption fee must be different from current redemption fee");

        redemptionFee = _newRedemptionFee; // Update the redemption fee
        emit RedemptionFeeUpdated(_newRedemptionFee); // Emit the event
    }

}