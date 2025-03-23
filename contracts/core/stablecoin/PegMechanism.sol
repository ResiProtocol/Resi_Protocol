//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Importing the necessary libraries
import "@openzeppelin/contracts/access/Ownable.sol"; // Importing the Ownable contract from OpenZeppelin

// Import all the interfaces required for the stablecoin
import "../../interfaces/IOracleAggregator.sol"; // Importing the Oracle Aggregator interface
import "../../interfaces/IStabilityReserve.sol"; // Importing the Stability Reserve interface

/** 
 * @title PegMechanism
 * @dev This contract manages the peg mechanism for the stablecoin.
*/
contract PegMechanism is Ownable {
    // State variables for the PegMechanism contract
    uint256 public pegTarget; // The target peg value for the stablecoin (e.g., 1e18 for $1)
    uint256 public collateralRatio; // Dynamic collateral ratio (in basis points: 10000 = 100%)
    uint256 public maxCollateralRatio; // Maximum collateral ratio (in basis points)
    uint256 public minCollateralRatio; // Minimum collateral ratio (in basis points)
    uint256 public upperPegThreshold; // Upper threshold for peg adjustment
    uint256 public lowerPegThreshold; // Lower threshold for peg adjustment
    uint256 public emergencyPegThreshold; // Emergency threshold for peg 
    uint256 public lastAdjustmentTime; // Last time the peg was adjusted

    // Constants
    uint256 private constant BASIS_POINTS = 10000; // Basis points constant for calculations
    uint256 private constant PRICE_PRECISION = 1e18; // Price precision constant for calculations
    // Cooldown period for peg adjustments (to prevent market turbulence)
    uint256 public constant ADJUSTMENT_COOLDOWN = 6 hours;

    // Events

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
     * @notice Emitted when the peg target is updated
     * @dev This is fired during the updatePegTarget function
     * @param newPegTarget The new target value for the stablecoin peg
     */
    event PegTargetUpdated(uint256 newPegTarget);

    /** 
     * @notice Emitted when the collateral ratio is updated
     * @dev This is fired during the updateCollateralRatio function
     * @param newCollateralRatio The new required collateral ratio
     */
    event CollateralRatioUpdated(uint256 newCollateralRatio);

    /** 
     * @notice Emitted when the peg thresholds are updated
     * @dev This is fired during the updatePegThresholds function
     * @param upperPegThreshold The new upper peg threshold
     * @param lowerPegThreshold The new lower peg threshold
     * @param emergencyPegThreshold The new emergency peg threshold
     */
    event PegThresholdsUpdated(uint256 upperPegThreshold, uint256 lowerPegThreshold, uint256 emergencyPegThreshold);

    /** 
    * @notice Emitted when the stability reserve triggers an action
    * @dev This is fired during the adjustPeg function
    * @param currentPrice The current price of the stablecoin
    * @param pegTarget The target peg value for the stablecoin
    */
    event StabilityReserveAction(uint256 currentPrice, uint256 pegTarget);

    // Interfaces for external contracts
    IOracleAggregator public oracleAggregator; // Oracle Aggregator interface
    IStabilityReserve public stabilityReserve; // Stability Reserve interface

    // Constructor to initialize the PegMechanism contract
    constructor(uint256 _initialPegTarget) Ownable(msg.sender){
        pegTarget = _initialPegTarget; // Set the initial peg target
        collateralRatio = 10000; // Set the initial collateral ratio to 100%
        minCollateralRatio = 8000; // Set the minimum collateral ratio to 80%
        maxCollateralRatio = 12000; // Set the maximum collateral ratio to 120%
        upperPegThreshold = 10500; // Set the upper peg threshold to 105%
        lowerPegThreshold = 9500; // Set the lower peg threshold to 95%
        emergencyPegThreshold = 9000; // Set the emergency peg threshold to 90%
    }

    /**
     * @dev Set the oracle aggregator contract
     * @param _oracleAggregator Address of the oracle aggregator contract
    */
    function setOracleAggregator(address _oracleAggregator) external onlyOwner {
        require(_oracleAggregator != address(0), "Invalid oracle aggregator address"); // Check if the address is valid
        oracleAggregator = IOracleAggregator(_oracleAggregator); // Set the oracle aggregator contract
        emit OracleAggregatorSet(_oracleAggregator); // Emit the event
    }

    /**
     * @dev Set the stability reserve contract
     * @param _stabilityReserve Address of the stability reserve contract
    */
    function setStabilityReserve(address _stabilityReserve) external onlyOwner {
        require(_stabilityReserve != address(0), "Invalid stability reserve address"); // Check if the address is valid
        stabilityReserve = IStabilityReserve(_stabilityReserve); // Set the stability reserve contract
        emit StabilityReserveSet(_stabilityReserve); // Emit the event
    }

    /**
     * @dev Calculate the mint amount based on the collateral value and current peg target
     * @param collateralValue The value of the collateral
    */
    function calculateMintAmount(uint256 collateralValue) external view returns (uint256) {
        return (collateralValue * BASIS_POINTS) / (collateralRatio * pegTarget / PRICE_PRECISION);
    }

    /**
    * @dev Update the peg target value
    * @param _newPegTarget New peg target value
    */
    function updatePegTarget(uint256 _newPegTarget) external onlyOwner {
        // Check if the new peg target is valid
        require(_newPegTarget > 0, "Invalid peg target value - must be greater than 0");
        // Check if the new peg target is different from the current peg target
        // This prevents unnecessary updates which could lead to gas wastage
        require(_newPegTarget != pegTarget, "New peg target must be different from current peg target"); 
        pegTarget = _newPegTarget; // Update the peg target
        emit PegTargetUpdated(_newPegTarget); // Emit the event
    }

    /**
    * @dev Update the collateral ratio
    * @param _newCollateralRatio New collateral ratio (in basis points)
    */
    function updateCollateralRatio(uint256 _newCollateralRatio) external onlyOwner {
        // Check if the new collateral ratio is valid (>0) and is at least 50% (5000 basis points)
        require(_newCollateralRatio > 5000, "Collateral ratio must be greater than 50%");
        // Check if the new collateral ratio is different from the current collateral ratio
        // This prevents unnecessary updates which could lead to gas wastage
        require(_newCollateralRatio != collateralRatio, 
        "New collateral ratio must be different from current collateral ratio");

        collateralRatio = _newCollateralRatio; // Update the collateral ratio
        emit CollateralRatioUpdated(_newCollateralRatio); // Emit the event
    }

    /**
    * @dev Update the peg thresholds for the stablecoin
    * @param _upperPegThreshold New upper peg threshold
    * @param _lowerPegThreshold New lower peg threshold
    * @param _emergencyPegThreshold New emergency peg threshold 
    */
    function updatePegThresholds(uint256 _upperPegThreshold, uint256 _lowerPegThreshold, uint256 _emergencyPegThreshold)
    external onlyOwner {
        // Check if the new peg thresholds are valid (>0)
        require(_upperPegThreshold > 0 && _lowerPegThreshold > 0 && _emergencyPegThreshold > 0, 
        "Peg thresholds must be greater than 0");
        // Check if the upper peg threshold is greater than the lower peg threshold
        // and if the lower peg threshold is greater than the emergency peg threshold
        require(_upperPegThreshold > _lowerPegThreshold && _lowerPegThreshold > _emergencyPegThreshold,
        "Upper peg threshold must be greater than lower peg threshold and "
        "lower peg threshold must be greater than emergency peg threshold");
        upperPegThreshold = _upperPegThreshold; // Update the upper peg threshold
        lowerPegThreshold = _lowerPegThreshold; // Update the lower peg threshold
        emergencyPegThreshold = _emergencyPegThreshold; // Update the emergency peg threshold
        emit PegThresholdsUpdated(_upperPegThreshold, _lowerPegThreshold, _emergencyPegThreshold);
    }

    /** 
    * @notice Can only be called by stability reserve or governance
    * @dev Adjust peg in response to market conditions
    */
    function adjustPeg() external returns (bool) {
        require(
            msg.sender == address(stabilityReserve) || msg.sender == owner(),
            "Unauthorized caller"
        );
        require(block.timestamp >= lastAdjustmentTime + ADJUSTMENT_COOLDOWN, "Cooldown period not met");
        lastAdjustmentTime = block.timestamp; // Update the last adjustment time
        require(address(oracleAggregator) != address(0), "Oracle aggregator not set");

        // Get the current price of the stablecoin from the oracle aggregator
        uint256 currentPrice = oracleAggregator.getStablecoinPrice();

        // If the price is above peg, decrease collateral ratio to encourage minting (increase supply to reduce price)
        // If the price is below peg, increase collateral ratio to encourage burning (decrease supply to increase price)
        if (currentPrice > (pegTarget * upperPegThreshold) / BASIS_POINTS) { 
            // Decrease collateral ratio by 1%
            if(collateralRatio > minCollateralRatio){ // minimum collateral ratio is 51%
                collateralRatio -= 100; // Decrease collateral ratio by 1%
                emit CollateralRatioUpdated(collateralRatio); // Emit the event
                return true; // Indicate that an adjustment was made
            }

        } else if (currentPrice < (pegTarget * lowerPegThreshold) / BASIS_POINTS) { 
            // Increase collateral ratio by 1%
            collateralRatio += 100; // Increase collateral ratio by 1%
            emit CollateralRatioUpdated(collateralRatio); // Emit the event

            // If the price is significantly below peg, trigger stability reserve
            if(currentPrice < (pegTarget * emergencyPegThreshold) / BASIS_POINTS 
            && address(stabilityReserve) != address(0)){ 
                // if the price is significantly below peg
                stabilityReserve.triggerStabilityAction(); // Trigger the stability reserve mechanism
                emit StabilityReserveAction(currentPrice, pegTarget); // Emit the event
            }
            return true; // Indicate that an adjustment was made
        }

        return false; // Indicate that no adjustment was made
    }

}