// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Importing the necessary libraries
import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // Importing the ERC20 standard from OpenZeppelin
import "@openzeppelin/contracts/access/Ownable.sol"; // Importing the Ownable contract from OpenZeppelin
// Importing the ReentrancyGuard contract from OpenZeppelin
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"; 
// Importing the Pausable contract from OpenZeppelin
import "@openzeppelin/contracts/utils/Pausable.sol"; // Importing the Pausable contract from OpenZeppelin

// Import all the interfaces required for the stablecoin
import "../../interfaces/ICollateralPool.sol"; // Importing the Collateral Pool interface
import "../../interfaces/IOracleAggregator.sol"; // Importing the Oracle Aggregator interface
import "../../interfaces/IStabilityReserve.sol"; // Importing the Stability Reserve interface
import "../../interfaces/IFeeManager.sol"; // Importing the Fee Manager interface
import "../../interfaces/IPegMechanism.sol"; // Importing the Peg Mechanism interface
import "../../interfaces/IVolumeController.sol"; // Importing the Volume Controller interface
import "../../interfaces/IAccessController.sol"; // Importing the Access Controller interface

contract StablecoinCore is ERC20, Ownable, ReentrancyGuard, Pausable {
    // Module interfaces
    IFeeManager public feeManager; // Fee Manager interface
    IPegMechanism public pegMechanism; // Peg Mechanism interface
    IVolumeController public volumeController; // Volume Controller interface
    IAccessController public accessController; // Access Controller interface

    // External contract interfaces
    ICollateralPool public collateralPool; // Collateral Pool interface
    IOracleAggregator public oracleAggregator; // Oracle Aggregator interface
    IStabilityReserve public stabilityReserve; // Stability Reserve interface

    // Constants
    uint256 private constant BASIS_POINTS = 10000; // Basis points constant for calculations
    uint256 private constant PRICE_PRECISION = 1e18; // Price precision constant for calculations

    // Events

    /** 
     * @notice Emitted when new stablecoins are minted
     * @param user The address that received the minted tokens
     * @param amount The amount of stablecoins minted
     */
    event Mint(address indexed user, uint256 amount);

    /** 
     * @notice Emitted when stablecoins are burned
     * @param user The address that burned the tokens
     * @param amount The amount of stablecoins burned
     */
    event Burn(address indexed user, uint256 amount);

    /** 
     * @notice Emitted when the collateral pool address is set
     * @dev This is fired during the setCollateralPool function
     * @param collateralPool The address of the new collateral pool
     */
    event CollateralPoolSet(address indexed collateralPool);

    /** 
     * @notice Emitted when the oracle aggregator address is set
     * @dev This is fired during the setOracleAggregator function
     * @param oracleAggregator The address of the new oracle aggregator
     */
    event OracleAggregatorSet(address indexed oracleAggregator);

    /**
     * @notice Emitted when the stability reserve address is set
     * @dev This is fired during the setStabilityReserve function
     * @param stabilityReserve The address of the new stability reserve
     */
    event StabilityReserveSet(address indexed stabilityReserve);

    /** 
     * @notice Emitted when the fee manager address is set
     * @dev This is fired during the setFeeManager function
     * @param feeManager The address of the new fee manager
     */
    event FeeManagerSet(address indexed feeManager);

    /** 
     * @notice Emitted when the peg mechanism address is set
     * @dev This is fired during the setPegMechanism function
     * @param pegMechanism The address of the new peg mechanism
     */
    event PegMechanismSet(address indexed pegMechanism);

    /** 
     * @notice Emitted when the volume controller address is set
     * @dev This is fired during the setVolumeController function
     * @param volumeController The address of the new volume controller
     */
    event VolumeControllerSet(address indexed volumeController);

    /** 
     * @notice Emitted when the access controller address is set
     * @dev This is fired during the setAccessController function
     * @param accessController The address of the new access controller
     */
    event AccessControllerSet(address indexed accessController);

    // Constructor for the StablecoinCore contract
    constructor(
        string memory name_,
        string memory symbol_,
        address _collateralPool,
        address _oracleAggregator,
        address _stabilityReserve,
        address _feeManager,
        address _pegMechanism,
        address _volumeController,
        address _accessController
    ) ERC20(name_, symbol_) Ownable(msg.sender){
        // Check whether the provided addresses are valid
        require(_collateralPool != address(0), "Invalid collateral pool address");
        require(_oracleAggregator != address(0), "Invalid oracle aggregator address");
        require(_stabilityReserve != address(0), "Invalid stability reserve address");
        require(_feeManager != address(0), "Invalid fee manager address");
        require(_pegMechanism != address(0), "Invalid peg mechanism address");
        require(_volumeController != address(0), "Invalid volume controller address");
        require(_accessController != address(0), "Invalid access controller address");

        // Set the external contract interfaces
        collateralPool = ICollateralPool(_collateralPool);
        oracleAggregator = IOracleAggregator(_oracleAggregator);
        stabilityReserve = IStabilityReserve(_stabilityReserve);

        // Set the module interfaces
        feeManager = IFeeManager(_feeManager);
        pegMechanism = IPegMechanism(_pegMechanism);
        volumeController = IVolumeController(_volumeController);
        accessController = IAccessController(_accessController);

        // Emit events for the set addresses
        emit CollateralPoolSet(_collateralPool);
        emit OracleAggregatorSet(_oracleAggregator);
        emit StabilityReserveSet(_stabilityReserve);
        emit FeeManagerSet(_feeManager);
        emit PegMechanismSet(_pegMechanism);
        emit VolumeControllerSet(_volumeController);
        emit AccessControllerSet(_accessController);
    }

    // Functions to update the module addresses (useful when modules need to be updated)
    
    /** 
    * @dev Updates the address of the fee manager
    * @param _newFeeManager The address of the new fee manager
    */
    function setFeeManager(address _newFeeManager) external onlyOwner {
        require(_newFeeManager != address(0), "Invalid fee manager address");
        feeManager = IFeeManager(_newFeeManager);
        emit FeeManagerSet(_newFeeManager);
    }

    /**
    * @dev Updates the address of the peg mechanism
    * @param _newPegMechanism The address of the new peg mechanism
    */
    function setPegMechanism(address _newPegMechanism) external onlyOwner {
        require(_newPegMechanism != address(0), "Invalid peg mechanism address");
        pegMechanism = IPegMechanism(_newPegMechanism);
        emit PegMechanismSet(_newPegMechanism);
    }

    /** 
    * @dev Updates the address of the volume controller
    * @param _newVolumeController The address of the new volume controller
    */
    function setVolumeController(address _newVolumeController) external onlyOwner {
        require(_newVolumeController != address(0), "Invalid volume controller address");
        volumeController = IVolumeController(_newVolumeController);
        emit VolumeControllerSet(_newVolumeController);
    }

    /**
    * @dev Updates the address of the access controller
    * @param _newAccessController The address of the new access controller
    */
    function setAccessController(address _newAccessController) external onlyOwner {
        require(_newAccessController != address(0), "Invalid access controller address");
        accessController = IAccessController(_newAccessController);
        emit AccessControllerSet(_newAccessController);
    }

    // Functions to update the external contract addresses (useful when external contracts need to be updated)

    /**
    * @dev Updates the address of the collateral pool
    * @param _newCollateralPool The address of the new collateral pool
    */
    function setCollateralPool(address _newCollateralPool) external onlyOwner {
        require(_newCollateralPool != address(0), "Invalid collateral pool address");
        collateralPool = ICollateralPool(_newCollateralPool);
        emit CollateralPoolSet(_newCollateralPool);
    }

    /**
    * @dev Updates the address of the oracle aggregator
    * @param _newOracleAggregator The address of the new oracle aggregator
    */
    function setOracleAggregator(address _newOracleAggregator) external onlyOwner {
        require(_newOracleAggregator != address(0), "Invalid oracle aggregator address");
        oracleAggregator = IOracleAggregator(_newOracleAggregator);
        emit OracleAggregatorSet(_newOracleAggregator);

        // Also update the oracle address in the peg mechanism
        pegMechanism.setOracleAggregator(_newOracleAggregator);
    }

    /**
    * @dev Updates the address of the stability reserve
    * @param _newStabilityReserve The address of the new stability reserve
    */
    function setStabilityReserve(address _newStabilityReserve) external onlyOwner {
        require(_newStabilityReserve != address(0), "Invalid stability reserve address");
        stabilityReserve = IStabilityReserve(_newStabilityReserve);
        emit StabilityReserveSet(_newStabilityReserve);

        // Also update the stability reserve address in the peg mechanism
        pegMechanism.setStabilityReserve(_newStabilityReserve);
    }

    // Emergency functions

    /** 
    * @notice Pauses all contract operations in an emergency
    * @dev This is a global pause that stops all operations regardless of mint/burn pause status
    */
    function pause() external {
        require(accessController.canPause(msg.sender), "Not authorized to pause");
        // Check if the contract is already paused
        require(!paused(), "Contract is already paused");
        _pause(); // Call the pause function from the Pausable contract
    }

    /**
    * @notice Unpauses all contract operations
    * @dev This is a global unpause that resumes all operations, but specific mint/burn pauses may still apply
    */
    function unpause() external {
        require(accessController.canUnpause(msg.sender), "Not authorized to unpause");
        // Check if the contract is already unpaused
        require(paused(), "Contract is already unpaused");
        _unpause();
    }

    /** 
    * @notice Emergency shutdown of the contract
    * @dev This function can only be called by the owner and will stop all operations
    */
    function emergencyShutdown() external {
        require(accessController.canEmergencyShutdown(msg.sender), "Not authorized to emergency shutdown");
        _pause(); // Call the pause function from the Pausable contract
        accessController.setEmergencyMode(true); // Set the emergency mode to true
    }

    /**
    * @dev Get the USD value of a collateral amount
    * @param collateralAmount Amount of collateral to be converted
    * @param collateralType Address of the collateral token
    * @return collateralValueUSD USD value of the collateral amount
    */
    function getCollateralValue(uint256 collateralAmount, address collateralType) 
    public view returns (uint256 collateralValueUSD) {
        // Get the price of the collateral in USD from the oracle aggregator
        uint256 collateralPrice = oracleAggregator.getCollateralPrice(collateralType);
        // Calculate the USD value of the collateral amount and return it
        return (collateralAmount * collateralPrice) / PRICE_PRECISION;
    }

    /** 
    * @dev Adjust the peg mechanism based on the current market conditions 
    * @return bool True if the peg adjustment was successful, false otherwise
    */
    function adjustPeg() external returns (bool) {
        return pegMechanism.adjustPeg(msg.sender);
    }

    /**
    * @dev Mint new stablecoins
    * @param collateralAmount Amount of collateral to be deposited
    * @param collateralType Address of the collateral token
    * @return amountMinted Amount of stablecoins minted
    */
    function mint(uint256 collateralAmount, address collateralType)
        external
        whenNotPaused
        nonReentrant
        returns (uint256 amountMinted)
    {
        // Check whether minting is allowed
        require(accessController.canMint(msg.sender), "Not authorized to mint");

        // Check if the collateral pool is set
        require(address(collateralPool) != address(0), "Collateral pool not set");
        // Check if the oracle aggregator is set
        require(address(oracleAggregator) != address(0), "Oracle aggregator not set");
        // Check if the stability reserve is set
        require(address(stabilityReserve) != address(0), "Stability reserve not set");
        // Check if the collateral amount is valid (>0)
        require(collateralAmount > 0, "Collateral amount must be greater than 0");
        // Ensure oracle has not detected any anomalies
        require(!oracleAggregator.hasAnomalyDetected(), "Anomaly detected by oracle");
        // Check if collateral type is supported
        require(collateralPool.isCollateralTypeSupported(collateralType), "Unsupported collateral type");

        // Check the volume controller for minting limits
        volumeController.checkAndUpdateMintVolume(msg.sender, collateralAmount);

        // Calculate the USD value of the collateral amount
        uint256 collateralValue = getCollateralValue(collateralAmount, collateralType);

        // Calculate the amount of stablecoins to mint based on the collateral value using the peg mechanism    
        uint256 maxMintableAmount = pegMechanism.calculateMintAmount(collateralValue);

        // Calculate the mint fee using the fee manager
        (uint256 amountAfterFee, uint256 feeAmount) = feeManager.calculateMintFee(maxMintableAmount);
        amountMinted = amountAfterFee;

        require(amountMinted > 0, "Mint amount must be greater than 0");

        // Transfer the collateral to the collateral pool
        bool success = collateralPool.depositCollateral(msg.sender, collateralType, collateralAmount);
        require(success, "Collateral deposit failed"); // Check if the deposit was successful

        // Allocate the minted stablecoins to the user
        _mint(msg.sender, amountMinted);

        // Transfer the stability fee to the stability reserve
        if (feeAmount > 0) {
            _mint(address(stabilityReserve), feeAmount); // Mint the stability fee to the stability reserve
            // Notify the stability reserve about the fee received
            stabilityReserve.notifyFeeReceived(feeAmount);
        }

        // Emit the mint event
        emit Mint(msg.sender, amountMinted); // Emit the mint event
    }

    /**
    * @dev Burn stablecoins to redeem collateral
    * @param stableAmount Amount of stablecoins to be burned
    * @param collateralType Address of the collateral token
    * @return collateralRedeemed Amount of collateral redeemed
    */
    function burn(uint256 stableAmount, address collateralType)
        external
        whenNotPaused
        nonReentrant
        returns (uint256 collateralRedeemed)
    {
        // Check whether burning is allowed
        require(accessController.canBurn(msg.sender), "Not authorized to burn");

        // Check if the collateral pool is set
        require(address(collateralPool) != address(0), "Collateral pool not set");
        // Check if the oracle aggregator is set
        require(address(oracleAggregator) != address(0), "Oracle aggregator not set");
        // Check if the stability reserve is set
        require(address(stabilityReserve) != address(0), "Stability reserve not set");
        // Check if the stable amount is valid (>0)
        require(stableAmount > 0, "Stable amount must be greater than 0");
        // Check if the user has enough stablecoins to burn
        require(balanceOf(msg.sender) >= stableAmount, "Insufficient stablecoin balance");

        // Check the volume controller for burn limits
        volumeController.checkAndUpdateBurnVolume(msg.sender, stableAmount);

        // Calculate the redemption fee using the fee manager
        (uint256 amountAfterFee, uint256 feeAmount) = feeManager.calculateRedemptionFee(stableAmount);

        // Calculate the amount of collateral to be redeemed
        uint256 collateralValue = (amountAfterFee * pegMechanism.pegTarget()) / PRICE_PRECISION;

      // Check if there is sufficient collateral in the pool
        require(collateralPool.getCollateralValue(collateralType) >= collateralValue,
        "Insufficient collateral in pool");

        // Calculate the collateral amount to be redeemed based on the collateral ratio
        collateralRedeemed = collateralPool.calculateCollateralAmount(collateralType, collateralValue);
        require(collateralRedeemed > 0, "Collateral amount must be greater than 0");

        _burn(msg.sender, stableAmount); // Burn the stablecoins from the user's balance

        // Transfer the collateral to the collateral pool to user
        bool success = collateralPool.withdrawCollateral(msg.sender, collateralType, collateralRedeemed);
        require(success, "Collateral withdrawal failed");

        // Transfer the redemption fee to the stability reserve
        if (feeAmount > 0) {
            _mint(address(stabilityReserve), feeAmount); // Mint the redemption fee to the stability reserve
            // Notify the stability reserve about the fee received
            stabilityReserve.notifyFeeReceived(feeAmount);
        }

        // Emit the burn event
        emit Burn(msg.sender, stableAmount); // Emit the burn event
    }
}