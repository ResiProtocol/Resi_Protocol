// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Importing the necessary libraries
import "@openzeppelin/contracts/access/Ownable.sol"; // Importing the Ownable contract from OpenZeppelin

/**
 * @title VolumeController
 * @dev This contract manages the volume control for the stablecoin system. Helps prevent flash loan attacks
 */
 contract VolumeController is Ownable {
    // State variables of the contract
    uint256 public mintVolumeLimit; // Maximum mint volume limit
    uint256 public burnVolumeLimit; // Maximum burn volume limit
    uint256 public lastMintResetTime; // Last time the mint volume was reset
    uint256 public lastBurnResetTime; // Last time the burn volume was reset
    uint256 public mintVolumeInPeriod; // Total mint volume in the current period
    uint256 public burnVolumeInPeriod; // Total burn volume in the current period
    uint256 public accountVolumeLimitPercentage = 2000; // 20% of the total mint/burn volume limit
    // Mapping for user volume limits
    mapping(address => uint256) public userMintVolume; // User mint volume tracking
    mapping(address => uint256) public userBurnVolume; // User burn volume tracking
    mapping(address => uint256) public lastUserMintReset; // Last time the user mint volume was reset
    mapping(address => uint256) public lastUserBurnReset; // Last time the user burn volume was reset

    // Constants
    uint256 private constant BASIS_POINTS = 10000; // Basis points constant for calculations
    // Cooldown period for minting and burning volume resets
    uint256 public constant VOLUME_RESET_COOLDOWN = 1 hours;

    /** 
    * @notice Emitted when the mint/burn volume limits are updated
    * @dev This is fired during the updateVolumeLimits function
    * @param mintVolumeLimit The new mint volume limit
    * @param burnVolumeLimit The new burn volume limit
    */
    event VolumeLimitsUpdated(uint256 mintVolumeLimit, uint256 burnVolumeLimit);

    // Constructor to initialize the volume controller
    constructor(uint256 _mintVolumeLimit, uint256 _burnVolumeLimit) Ownable(msg.sender) {
        mintVolumeLimit = _mintVolumeLimit; // Initialize mint volume limit
        burnVolumeLimit = _burnVolumeLimit; // Initialize burn volume limit
    }

    /** 
    * @notice Updates the mint volume limits
    * @dev This function checks and updates the mint volume for the system and the user
    * @param user The address of the user whose mint volume is being checked
    * @param amount The amount of mint volume to check
    */
    function checkAndUpdateMintVolume(
        address user,
        uint256 amount
    ) external {
        // Check if block time has passed the cooldown period for mint volume reset
        if (block.timestamp >= lastMintResetTime + VOLUME_RESET_COOLDOWN) {
            mintVolumeInPeriod = 0; // Reset the mint volume in period
            lastMintResetTime = block.timestamp; // Update the last mint reset time
        }
        
        // Check if block time has passed the cooldown period for user mint volume reset
        if (block.timestamp >= lastUserMintReset[user] + VOLUME_RESET_COOLDOWN) {
            userMintVolume[user] = 0; // Reset the user mint volume
            lastUserMintReset[user] = block.timestamp; // Update the last user mint reset time
        }
        
        // Check if the mint volume limit has been reached
        require(mintVolumeInPeriod + amount <= mintVolumeLimit, "Mint volume limit reached");
        
        // Calculate the user limit based on the account volume limit percentage
        uint256 userLimit = (mintVolumeLimit * accountVolumeLimitPercentage) / BASIS_POINTS;
        // Check if the user mint volume limit has been reached
        require(userMintVolume[user] + amount <= userLimit, "User mint volume limit reached");
        
        userMintVolume[user] += amount; // Update the user mint volume
        mintVolumeInPeriod += amount; // Update the mint volume in period
    }

    /** 
    * @notice Updates the burn volume limits
    * @dev This function checks and updates the burn volume for the system and the user
    * @param user The address of the user whose burn volume is being checked
    * @param amount The amount of burn volume to check
    */
    function checkAndUpdateBurnVolume(address user, uint256 amount) external {
        // Check if block time has passed the cooldown period for burn volume reset
        if (block.timestamp >= lastBurnResetTime + VOLUME_RESET_COOLDOWN) {
            burnVolumeInPeriod = 0; // Reset the burn volume in period
            lastBurnResetTime = block.timestamp; // Update the last burn reset time
        }
        
        // Check if block time has passed the cooldown period for user burn volume reset
        if (block.timestamp >= lastUserBurnReset[user] + VOLUME_RESET_COOLDOWN) {
            userBurnVolume[user] = 0; // Reset the user burn volume
            lastUserBurnReset[user] = block.timestamp; // Update the last user burn reset time
        }
        
        // Check if the burn volume limit has been reached
        require(burnVolumeInPeriod + amount <= burnVolumeLimit, "Burn volume limit reached");
        
        // Calculate the user limit based on the account volume limit percentage
        uint256 userLimit = (burnVolumeLimit * accountVolumeLimitPercentage) / BASIS_POINTS;
        // Check if the user burn volume limit has been reached
        require(userBurnVolume[user] + amount <= userLimit, "User burn volume limit reached");
        
        userBurnVolume[user] += amount; // Update the user burn volume
        burnVolumeInPeriod += amount; // Update the burn volume in period
    }

    /** 
    * @notice Updates the mint and burn volume limits
    * @dev This function allows the owner to update the volume limits
    * @param _mintVolumeLimit The new mint volume limit
    * @param _burnVolumeLimit The new burn volume limit
    */
    function updateVolumeLimits(uint256 _mintVolumeLimit, uint256 _burnVolumeLimit) external onlyOwner {
        // Check if the new mint and burn volume limits are greater than 0
        require(_mintVolumeLimit > 0 && _burnVolumeLimit > 0, "Volume limits must be greater than 0");
        // Ensure the new limits are different from the current limits
        // This prevents unnecessary updates which could lead to gas wastage
        require(_mintVolumeLimit != mintVolumeLimit, 
        "New mint volume limit must be different from current mint volume limit");
        require(_burnVolumeLimit != burnVolumeLimit, 
        "New burn volume limit must be different from current burn volume limit");
        
        mintVolumeLimit = _mintVolumeLimit; // Update the mint volume limit
        burnVolumeLimit = _burnVolumeLimit; // Update the burn volume limit
        emit VolumeLimitsUpdated(_mintVolumeLimit, _burnVolumeLimit); // Emit the event
    }
 }
