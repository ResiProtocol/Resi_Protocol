// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Importing the necessary libraries
import "@openzeppelin/contracts/access/Ownable.sol"; // Importing the Ownable contract from OpenZeppelin

/**
* @title AccessController
* @dev This contract manages access control for the stablecoin system.
*/
contract AccessController is Ownable {
    // State variables of the contract
    bool public mintPaused; // Flag to pause minting (0 = not paused(active), 1 = paused)
    bool public burnPaused; // Flag to pause burning (0 = not paused(active), 1 = paused)
    // Flag to indicate if the contract is in emergency mode (0 = not in emergency mode, 1 = in emergency mode)
    bool public emergencyMode;


    // Events

    /** 
     * @notice Emitted when minting is paused or unpaused
     * @dev This is fired during the setMintPaused function
     * @param status True if minting is paused, false otherwise
     */
    event MintPaused(bool status);

    /** 
     * @notice Emitted when burning is paused or unpaused
     * @dev This is fired during the setBurnPaused function
     * @param status True if burning is paused, false otherwise
     */
    event BurnPaused(bool status);

    /** 
     * @notice Emitted when the contract is paused
     * @dev This is fired during the setEmergencyMode function
     * @param timestamp The timestamp when the contract was paused
     */
    event EmergencyShutdown(uint256 timestamp);

    // constructor to initialize the access controller
    constructor() Ownable(msg.sender) {
        mintPaused = false; // Initialize minting as not paused
        burnPaused = false; // Initialize burning as not paused
        emergencyMode = false; // Initialize emergency mode as not active
    }

    /** 
     * @notice Checks if minting is allowed
     * @dev This function returns true if minting is not paused and not in emergency mode
     * @return bool True if minting is allowed, false otherwise
     */
    function canMint(address) external view returns (bool) {
        return !mintPaused && !emergencyMode; // Check if minting is allowed
    }

    /** 
     * @notice Checks if burning is allowed
     * @dev This function returns true if burning is not paused and not in emergency mode
     * @return bool True if burning is allowed, false otherwise
     */
    function canBurn(address) external view returns (bool) {
        return !burnPaused && !emergencyMode; // Check if burning is allowed
    }

    /** 
     * @notice Checks if pausing is allowed
     * @dev This function returns true if the caller is the owner
     * @param caller The address of the caller
     * @return bool True if pausing is allowed, false otherwise
     */
    function canPause(address caller) external view returns (bool) {
        return caller == owner(); // Check if the caller is the owner
    }

    /** 
     * @notice Checks if unpausing is allowed
     * @dev This function returns true if the caller is the owner and not in emergency mode
     * @param caller The address of the caller
     * @return bool True if unpausing is allowed, false otherwise
     */
    function canUnpause(address caller) external view returns (bool) {
        return caller == owner() && !emergencyMode; // Check if the caller is the owner and not in emergency mode
    }

    /** 
     * @notice Checks if emergency shutdown is allowed
     * @dev This function returns true if the caller is the owner
     * @param caller The address of the caller
     * @return bool True if emergency shutdown is allowed, false otherwise
     */
    function canEmergencyShutdown(address caller) external view returns (bool) {
        return caller == owner(); // Check if the caller is the owner
    }

    /**
    * @dev Pause or start minting
    * @param _statusMinting true to pause minting, false to start minting
    */
    function setMintPaused(bool _statusMinting) external onlyOwner {
        // Check if the new minting status is different from the current minting status
        // This prevents unnecessary updates which could lead to gas wastage
        require(_statusMinting != mintPaused, "New minting status must be different from current minting status");
        mintPaused = _statusMinting; // Set the minting status
        emit MintPaused(_statusMinting); // Emit the event
    }

    /**
    * @dev Pause or start burning
    * @param _statusBurning true to pause burning, false to start burning
    */
    function setBurnPaused(bool _statusBurning) external onlyOwner {
        // Check if the new burning status is different from the current burning status
        // This prevents unnecessary updates which could lead to gas wastage
        require(_statusBurning != burnPaused, "New burning status must be different from current burning status");
        burnPaused = _statusBurning; // Set the burning status
        emit BurnPaused(_statusBurning); // Emit the event
    }

    /** 
    * @dev Set the emergency mode status
    * @param _statusEmergency true to set emergency mode, false to unset emergency mode
    */
    function setEmergencyMode(bool _statusEmergency) external onlyOwner {
        // Check if the new emergency status is different from the current emergency status
        // This prevents unnecessary updates which could lead to gas wastage
        require(_statusEmergency != emergencyMode, 
        "New emergency status must be different from current emergency status");
        emergencyMode = _statusEmergency; // Set the emergency mode status

        if (_statusEmergency) {
            if(!mintPaused) {
                mintPaused = true; // Set minting to paused
                emit MintPaused(mintPaused); // Emit the event
            }
            if(!burnPaused) {
                burnPaused = true; // Set burning to paused
                emit BurnPaused(burnPaused); // Emit the event
            }
            emit EmergencyShutdown(block.timestamp); // Emit the event
        }
    }
}