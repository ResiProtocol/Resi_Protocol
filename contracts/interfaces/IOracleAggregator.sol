// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IOracleAggregator {
    /**
     * @dev Get the validated price of the stablecoin.
     * @return price The current validated price of the stablecoin in USD (in 18 decimals).
     */
    function getStablecoinPrice() external view returns (uint256 price);

    /**
    * @dev Get the validated price of a specific collateral asset.
    * @param collateralType Address of the collateral token.
    * @return price The current validated price of the collateral asset in USD (in 18 decimals).
    */
    function getCollateralPrice(address collateralType) external view returns (uint256 price);

    /**
     * @dev Check if the oracle has reported any anomalies.
     * @return anomalyDetected True if there are anomalies, false otherwise.
     */
    function hasAnomalyDetected() external view returns (bool anomalyDetected);

    /** 
    * @dev Get the latest price data fom all oracles for a specific asset.
    * @param tokenAddress Address of the asset token. (zero address for stablecoin)
    * @return prices Array of reported prices from different oracles.
    * @return sources Array of oracle identifiers corresponding to the reported prices.
    */
    function getAllOraclePrices(address tokenAddress) 
    external view returns (uint256[] memory prices, string[] memory sources);
}