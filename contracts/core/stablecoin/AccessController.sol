// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Importing the necessary libraries
import "@openzeppelin/contracts/access/AccessControl.sol"; // AccessControl contract from OpenZeppelin

/**
* @title AccessController
* @dev This contract manages access control for the stablecoin system.
*/
contract AccessController is AccessControl {
    // State variables of the contract
    bool public mintPaused; // Flag to pause minting (0 = not paused(active), 1 = paused)
    bool public burnPaused; // Flag to pause burning (0 = not paused(active), 1 = paused)
    // Flag to indicate if the contract is in emergency mode (0 = not in emergency mode, 1 = in emergency mode)
    bool public emergencyMode;

    // Roles for access control
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE"); // Role for pausing
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE"); // Role for admin


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
    constructor() {
        mintPaused = false; // Initialize minting as not paused
        burnPaused = false; // Initialize burning as not paused
        emergencyMode = false; // Initialize emergency mode as not active

        // Grant the deployer the default admin role
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // Grant the deployer the pauser role
        _grantRole(PAUSER_ROLE, msg.sender);
        // Grant the deployer the admin role
        _grantRole(ADMIN_ROLE, msg.sender);
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
     * @dev This function returns true if the caller has the pauser role
     * @param caller The address of the caller
     * @return bool True if pausing is allowed, false otherwise
     */
    function canPause(address caller) external view returns (bool) {
        // Check if the caller has the pauser or admin role 
        return hasRole(PAUSER_ROLE, caller) || hasRole(ADMIN_ROLE, caller); 
    }

    /** 
     * @notice Checks if unpausing is allowed
     * @dev This function returns true if the caller has the pauser role and not in emergency mode
     * @param caller The address of the caller
     * @return bool True if unpausing is allowed, false otherwise
     */
    function canUnpause(address caller) external view returns (bool) {
        // Check if the caller has the pauser role or admin role and the contract is not in emergency mode
        // This prevents the pauser from unpausing the contract during emergency mode
        return (hasRole(PAUSER_ROLE, caller) || hasRole(ADMIN_ROLE, caller)) && !emergencyMode;
    }

    /** 
     * @notice Checks if emergency shutdown is allowed
     * @dev This function returns true if the caller has the ADMIN_ROLE
     * @param caller The address of the caller
     * @return bool True if emergency shutdown is allowed, false otherwise
     */
    function canEmergencyShutdown(address caller) external view returns (bool) {
        return hasRole(ADMIN_ROLE, caller); // Check if the caller has the ADMIN_ROLE
    }

    /** 
    * @notice Checks if setting parameters is allowed
    * @dev This function returns true if the caller has the ADMIN_ROLE
    * @param caller The address of the caller
    * @return bool True if setting parameters is allowed, false otherwise
    */
    function canSetParams(address caller) external view returns (bool) {
        return hasRole(ADMIN_ROLE, caller); // Check if the caller has the ADMIN_ROLE
    }

    /**
    * @dev Pause or start minting
    * @param _statusMinting true to pause minting, false to start minting
    */
    function setMintPaused(bool _statusMinting) external {
        // Check if the caller has the pauser role or admin role
        require(hasRole(PAUSER_ROLE, msg.sender) || hasRole(ADMIN_ROLE, msg.sender),
        "Caller must have pauser or admin role");

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
    function setBurnPaused(bool _statusBurning) external {
        // Check if the caller has the pauser role or admin role
        require(hasRole(PAUSER_ROLE, msg.sender) || hasRole(ADMIN_ROLE, msg.sender),
        "Caller must have pauser or admin role");
        
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
    function setEmergencyMode(bool _statusEmergency) external onlyRole(ADMIN_ROLE) {
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