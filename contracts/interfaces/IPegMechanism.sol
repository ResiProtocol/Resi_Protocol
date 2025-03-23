// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title IPegMechanism
 * @dev Interface for the Peg Mechanism contract.
 * This contract is responsible for managing the peg mechanism of the stablecoin system.
*/
interface IPegMechanism {
    /**
     * @dev Getter function to retrieve the current peg target.
     * @return The current peg target value.
     */
    function pegTarget() external view returns (uint256);


    /**
     * @dev Getter function to retrieve the current collateral ratio.
     * @return The current collateral ratio value.
    */
    function collateralRatio() external view returns (uint256);

    /** 
     * @dev Calculate the mint amount based on the collateral value.
     * @param collateralValue The value of the collateral.
     * @return The calculated mint amount.
    */
    function calculateMintAmount(uint256 collateralValue) external view returns (uint256);

    /** 
     * @dev Adjust the peg mechanism based on the current market conditions.
     * @param caller The address of the caller.
     * @return A boolean indicating success or failure.
     */
    function adjustPeg(address caller) external returns (bool);

    /**  
     * @dev Set the address of the oracle aggregator.
     * @param _oracleAggregator The address of the oracle aggregator contract.
    */
    function setOracleAggregator(address _oracleAggregator) external;

    /** 
     * @dev Set the address of the stability reserve.
     * @param _stabilityReserve The address of the stability reserve contract.
    */
    function setStabilityReserve(address _stabilityReserve) external;

    /** 
     * @dev Update the peg target
     * @param _newPegTarget The new peg target value.
    */
    function updatePegTarget(uint256 _newPegTarget) external;
    
    /**
     * @dev Update the collateral ratio
     * @param _newCollateralRatio The new collateral ratio value.
    */
    function updateCollateralRatio(uint256 _newCollateralRatio) external;

    /**
     * @dev Update the peg thresholds
     * @param _upperPegThreshold The new upper peg threshold value.
     * @param _lowerPegThreshold The new lower peg threshold value.
     * @param _emergencyPegThreshold The new emergency peg threshold value.
    */
    function updatePegThresholds(uint256 _upperPegThreshold, uint256 _lowerPegThreshold, 
    uint256 _emergencyPegThreshold) external;
}