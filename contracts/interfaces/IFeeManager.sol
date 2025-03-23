// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title IFeeManager
 * @dev Interface for the Fee Manager contract.
 * This contract is responsible for managing fees associated with the stablecoin system.
 */
interface IFeeManager {
    /** 
     * @dev Getter function to retrieve the current stability fee.
     * @return The current stability fee as a percentage (in basis points, 10000 = 100%).
    */
    function stabilityFee() external view returns (uint256);

    /** 
     * @dev Getter function to retrieve the current redemption fee.
     * @return The current redemption fee as a percentage (in basis points, 10000 = 100%).
    */
    function redemptionFee() external view returns (uint256);

    /**
     * @dev Calculate the mint fee (Stability fee) for a given amount.
     * @param amount The amount to mint.
     * @return amountAfterFee The amount after applying the mint fee.
     * @return feeAmount The fee amount deducted from the original amount.
    */
    function calculateMintFee(uint256 amount) external view returns (uint256 amountAfterFee, uint256 feeAmount);

    /**
     * @dev Calculate the redemption fee for a given amount.
     * @param amount The amount to redeem.
     * @return amountAfterFee The amount after applying the redemption fee.
     * @return feeAmount The fee amount deducted from the original amount.
    */
    function calculateRedemptionFee(uint256 amount) external view returns (uint256 amountAfterFee, uint256 feeAmount);

    /**
     * @dev Update the stability fee.
     * @param _newStabilityFee The new stability fee to set (in basis points, 10000 = 100%).
    */
    function updateStabilityFee(uint256 _newStabilityFee) external;
    
    /**
     * @dev Update the redemption fee.
     * @param _newRedemptionFee The new redemption fee to set (in basis points, 10000 = 100%).
    */
    function updateRedemptionFee(uint256 _newRedemptionFee) external;
}