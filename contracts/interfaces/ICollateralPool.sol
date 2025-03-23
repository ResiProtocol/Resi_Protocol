// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface ICollateralPool {
    /**
    * @dev Deposit collateral into the pool.
    * @param from Address depositing the collateral.
    * @param collateralType Address of the collateral token.
    * @param amount Amount of collateral to deposit.
    * @return success Boolean indicating success of the operation. (true if successful)
    */
    function depositCollateral(address from, address collateralType, uint256 amount) external returns (bool success);

    /**
    * @dev Withdraw collateral from the pool.
    * @param to Address receiving the collateral.
    * @param collateralType Address of the collateral token.
    * @param amount Amount of collateral to withdraw.
    * @return success Boolean indicating success of the operation. (true if successful)
    */
    function withdrawCollateral(address to, address collateralType, uint256 amount) external returns (bool success);

    /**
    * @dev Calculate the amount of collateral tokens needed for a given USD value.
    * @param collateralType Address of the collateral token.
    * @param usdValue The USD value to convert.
    * @return amount The amount of collateral tokens needed.
    */
    function calculateCollateralAmount(address collateralType, uint256 usdValue) external view returns (uint256 amount);

    /**
    * @dev Get the total USD value of all collateral in the pool.
    * @return totalValue The total USD value of all collateral.
    */
    function getTotalCollateralValue() external view returns (uint256 totalValue);

    /**
    * @dev Get the total USD value of a specific collateral type in the pool.
    * @param collateralType Address of the collateral token.
    * @return totalValue The total USD value of the specified collateral type.
    */
    function getCollateralValue(address collateralType) external view returns (uint256 totalValue);

    /**
    * @dev Check if a specific collateral type is supported.
    * @param collateralType Address of the collateral token.
    * @return isSupported Boolean indicating if the collateral type is supported.
    */
    function isCollateralTypeSupported(address collateralType) external view returns (bool isSupported);

    /**
    * @dev Get the collateral ratio for a specific collateral type.
    * @param collateralType Address of the collateral token.
    * @return collateralRatio The collateral ratio for the specified collateral type (in basis points, 10000 = 100%).
    */
    function getCollateralRatio(address collateralType) external view returns (uint256 collateralRatio);
}