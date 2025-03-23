// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IStabilityReserve {

    /**
     * @dev Notify the stability reserve that a fee has been received
     * @param feeAmount The amount of the fee received.
    */
    function notifyFeeReceived(uint256 feeAmount) external;

    /**
    * @dev Trigger a stability action when the stablecoin is significantly off-peg.
    * @return success True if the stability action trigger was successful, false otherwise.
    */
    function triggerStabilityAction() external returns (bool success);

    /**
     * @dev Get the current balance of the stability reserve.
     * @return currentReserveBalance The current balance of the stability reserve.
     */
    function getCurrentReserveBalance() external view returns (uint256 currentReserveBalance);


    /** 
     * @dev Check if the stability reserve contains enough funds for an intervention.
     * @return hasSufficientFunds True if the stability reserve has sufficient funds, false otherwise.
    */
    function isReserveSufficient() external view returns (bool hasSufficientFunds);

    /**
     * @dev Get threshold at which the reserve activates.
     * @return threshold The threshold at which the reserve activates.
    */ 
    function getReserveActivationThreshold() external view returns (uint256 threshold);
}