// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// Importing the required libraries
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // ERC20 interface
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; // SafeERC20 library for safe token transfers
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"; // Reentrancy guard to prevent reentrant calls
import "@openzeppelin/contracts/utils/Pausable.sol"; // Pausable contract to allow pausing of operations

// Importing the necessary interfaces
import "../../interfaces/IAccessController.sol"; // Access controller interface
import "../../interfaces/IOracleAggregator.sol"; // Oracle aggregator interface

/** 
 * @title CollateralPool
 * @dev This contract manages collateral for the RESI protocol.
 */
contract CollateralPool is ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20; // Using SafeERC20 for safe token transfers

    // Module interfaces
    IAccessController public accessController; // Access controller interface
    IOracleAggregator public oracleAggregator; // Oracle aggregator interface

    // Collateral configuration
    struct CollateralConfig {
        bool isSupported; // Indicates if the collateral type is supported
    }

}