// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title IVolumeController
 * @dev Interface for the VolumeController contract.
 * This contract manages the volume control for the stablecoin system to prevent flash loan attacks.
 */
interface IVolumeController {

    /**
     * @dev Getter function to retrieve the current mint volume limit.
     * @return The current mint volume limit value.
     */
    function mintVolumeLimit() external view returns (uint256);
    
    /**
     * @dev Getter function to retrieve the current burn volume limit.
     * @return The current burn volume limit value.
     */
    function burnVolumeLimit() external view returns (uint256);

    /**
     * @dev This function checks and updates the mint volume for the system and the user
     * @param user The address of the user whose mint volume is being checked
     * @param amount The amount of mint volume to check
     */
    function checkAndUpdateMintVolume(address user, uint256 amount) external;

    /**
     * @dev This function checks and updates the burn volume for the system and the user
     * @param user The address of the user whose burn volume is being checked
     * @param amount The amount of burn volume to check
     */
    function checkAndUpdateBurnVolume(address user, uint256 amount) external;
    
    /**
     * @dev This function updates the volume limits for minting and burning
     * @param _mintVolumeLimit The new mint volume limit
     * @param _burnVolumeLimit The new burn volume limit
     */
    function updateVolumeLimits(uint256 _mintVolumeLimit, uint256 _burnVolumeLimit) external;
}