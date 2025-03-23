// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title IAccessController
 * @dev Interface for the Access Controller contract.
 * This contract is responsible for managing access control and permissions within the system.
 */
interface IAccessController {

    /**
     * @dev This function returns true if minting is not paused and not in emergency mode
     * @return bool True if minting is allowed, false otherwise
     */
    function canMint(address user) external view returns (bool);

    /**
     * @dev This function returns true if burning is not paused and not in emergency mode
     * @return bool True if burning is allowed, false otherwise
     */
    function canBurn(address user) external view returns (bool);

    /**
     * @dev This function returns true if the caller is the owner
     * @param caller The address of the caller
     * @return bool True if pausing is allowed, false otherwise
     */
    function canPause(address caller) external view returns (bool);

    /**
     * @dev This function returns true if the caller is the owner and not in emergency mode
     * @param caller The address of the caller
     * @return bool True if unpausing is allowed, false otherwise
     */
    function canUnpause(address caller) external view returns (bool);
    
    /**
     * @dev This function returns true if the caller is the owner and not in emergency mode
     * @param caller The address of the caller
     * @return bool True if emergency shutdown is allowed, false otherwise
     */
    function canEmergencyShutdown(address caller) external view returns (bool);


    /**
    * @dev Pause or start minting
    * @param _statusMinting true to pause minting, false to start minting
    */
    function setMintPaused(bool _statusMinting) external;
    
    /**
    * @dev Pause or start burning
    * @param _statusBurning true to pause burning, false to start burning
    */
    function setBurnPaused(bool _statusBurning) external;

    /** 
    * @dev Set the emergency mode status
    * @param _statusEmergency true to set emergency mode, false to unset emergency mode
    */
    function setEmergencyMode(bool _statusEmergency) external;
}