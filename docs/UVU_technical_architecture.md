# UVU Technical Architecture

## Engineering a Decentralized Unit of Value for the RESI Stable Asset

### 1. Introduction

The Universal Value Unit (UVU) is a programmable, dynamic reference unit designed to serve as a non-fiat value anchor for the RESI stable asset. Unlike fiat-pegged stablecoins that inherit centralization risks, UVU is composed of real-time on-chain and decentralized off-chain data sources that represent economic utility, not political monetary instruments.

#### Core Design Principles:

- Long-term peg resilience through diversified asset baskets
- On-chain transparency with verifiable composition
- Progressive decentralization via governance-managed transitions
- Composability across DeFi protocols with standardized interfaces

#### Target Users:

- DeFi protocols seeking stable settlement layers
- DAOs requiring treasury diversification
- Developers building payment applications
- End users seeking inflation resistance

---

### 2. UVU Composition (v1)

UVU is defined as a weighted index of two distinct baskets, with specific composition and rebalancing rules.

#### 2.1. Crypto-Native Utility Basket (60%)

**Purpose:** Represents fundamental services and capabilities that power decentralized ecosystems — computation, storage, labor, and settlement security.

**Rationale:** Stablecoins should reflect real digital productivity, not speculative market hype or artificial scarcity. This basket makes RESI meaningfully tied to what drives the decentralized economy.

**Subcomponents and Initial Weights:**

| Category             | Example Assets                              | Current Weight | Why It Matters                                                                      |
| -------------------- | ------------------------------------------- | -------------- | ----------------------------------------------------------------------------------- |
| Compute              | Akash (AKT), Render (RNDR), The Graph (GRT) | 15%            | Represents decentralized processing power used in AI, apps, and data indexing       |
| Storage              | Filecoin (FIL), Arweave (AR)                | 15%            | Stores the data that powers smart contracts, dApps, and Web3                        |
| Bandwidth & Access   | Helium (HNT), NKN (NKN)                     | 10%            | Facilitates decentralized communication, node relaying, and borderless access       |
| Security/Settlement  | Staked ETH (stETH), Rocketpool (rETH)       | 15%            | Represents network trust, validator uptime, and finality mechanisms                 |
| Labor/Work Streaming | Superfluid (SF), Braintrust (BTRST)         | 5%             | Tokenizes human labor and DAO contribution — a proxy for decentralized productivity |

**Weight Calculation Formula:**

```
Asset_i weight = (Market_Cap_i × Utility_Score_i × Liquidity_Factor_i) / Σ(Market_Cap × Utility_Score × Liquidity_Factor)
```

Where:

- `Market_Cap_i`: The market capitalization of asset i
- `Utility_Score_i`: A score from 1-10 representing actual on-chain usage
- `Liquidity_Factor_i`: A score from 0.1-1 representing market depth

**Data Feed Methodology:**

- **Primary Sources:** On-chain price feeds from Chainlink, Redstone, and UVU-specific oracles
- **Update Frequency:** Hourly for price data, daily for weight recalculation
- **Manipulation Protection:**
  - Time-weighted average prices over 24-hour periods
  - Outlier rejection algorithm (drop highest/lowest 5%)
  - 3% maximum daily weight drift (larger changes require governance)

**Example Calculation:**  
For a basket with Filecoin (FIL) and The Graph (GRT):

- FIL: Market Cap = $2.5B, Utility Score = 8, Liquidity = 0.9
- GRT: Market Cap = $1.8B, Utility Score = 7, Liquidity = 0.8

```
FIL weight = (2.5B × 8 × 0.9) / [(2.5B × 8 × 0.9) + (1.8B × 7 × 0.8)] = 0.6 or 60%
GRT weight = (1.8B × 7 × 0.8) / [(2.5B × 8 × 0.9) + (1.8B × 7 × 0.8)] = 0.4 or 40%
```

#### 2.2. Fiat Currency Stability Basket (40%)

**Purpose:** Provides short-term psychological stability and lower volatility in the early stages of the RESI protocol's lifecycle.

**Rationale:** Since most global commerce is still measured in fiat, anchoring a portion of the UVU to fiat creates smoother adoption curves and safer risk profiles for early integrations.

**Composition and Initial Weights:**

| Currency | Weight | Tracking Method                     | Rebalance Threshold |
| -------- | ------ | ----------------------------------- | ------------------- |
| USD      | 20%    | USDC (50%), DAI (50%)               | ±2.5%               |
| EUR      | 10%    | agEUR (40%), EURT (30%), EURS (30%) | ±2.5%               |
| JPY      | 5%     | JPYC                                | ±1.5%               |
| GBP      | 5%     | GBPT                                | ±1.5%               |

**Implementation Details:**

- Each fiat currency tracked via a basket of tokenized stablecoins (for redundancy)
- **Fallback Oracle:** FX rates via Chainlink (used if stablecoin prices deviate >3% from expected values)
- Rebalancing occurs when any component exceeds its threshold relative to target weight

**Progressive Reduction Schedule:**

- **2025-Q3:** 40% (launch)
- **2026-Q1:** 35%
- **2026-Q3:** 30%
- **2027-Q1:** 20%
- **2027-Q3:** 10%
- **2028-Q1:** 0% (fully transitioned to crypto-native utility)

---

### 3. Peg Mechanism: RESI = 1 UVU

RESI is a decentralized stable asset that always targets a 1:1 ratio with UVU. The peg is maintained using several reinforcing mechanisms.

#### 3.1. Minting and Redemption

**Minting Process:**

1. User deposits collateral (ETH, stablecoins, or basket tokens)
2. Oracle reports current UVU/USD value
3. Smart contract calculates required collateral based on current UVU value
4. Minimum collateralization ratio: 70%
5. ZKP verifies collateral sufficiency without revealing exact amount
6. RESI tokens minted and transferred to user

**Redemption Process:**

1. User burns RESI tokens
2. Smart contract calculates collateral release amount
3. Redemption fee: 0.5% (adjustable via governance)
   - 0.1% of fees to stability reserve, 0.4% to RESI DAO treasury
4. Collateral released to user

**Example Calculation:**  
If UVU = $1.05 and user deposits $126 worth of ETH:

- Collateralization: $126/$105 = 120%
- RESI minted: 100 tokens (worth $105 at UVU value)

---

### 4. UVU Index Management

UVU is governed by a DAO that manages the following parameters with specific voting requirements:

| Parameter Change                     | Quorum Required | Approval Threshold | Timelock |
| ------------------------------------ | --------------- | ------------------ | -------- |
| Asset addition/removal               | 25%             | 67%                | 7 days   |
| Weight reallocation >5%              | 20%             | 60%                | 5 days   |
| Weight reallocation <5%              | 15%             | 55%                | 3 days   |
| Oracle feed configuration            | 15%             | 55%                | 3 days   |
| Fiat-to-crypto transition adjustment | 30%             | 70%                | 14 days  |

---

### 5. Transparency Features

**UVU Dashboard Components:**

- **UVU/USD Live Chart:** Real-time value tracking and historical performance
- **Basket Composition Viewer:** Interactive breakdown of current weights
- **Asset Price Monitor:** Individual component price feeds
- **Rebalance History:** Record of all composition changes
- **Deviation Alerts:** Notifications when components exceed thresholds

**Technical Implementations:**

```solidity
function getBasketComposition() external view returns (
        address[] memory assets,
        uint256[] memory weights,
        uint256[] memory prices
);

function getHistoricalUVUPrice(uint256 timestamp) external view returns (uint256);

function getRebalanceEvents(uint256 fromTimestamp, uint256 toTimestamp)
        external view returns (RebalanceEvent[] memory);
```

---

### 6. Roadmap Snapshot

| Phase | Timeline   | Milestone                                        | Technical Deliverables                                     |
| ----- | ---------- | ------------------------------------------------ | ---------------------------------------------------------- |
| Alpha | Q2 2025    | UVU prototype, testnet deployment                | UVU Oracle contract, basket tracking MVP                   |
| Beta  | Q3 2025    | Mainnet launch of UVU v1 and RESI                | Fully functional protocol with basic UI                    |
| v1    | Q4 2025    | UVU Explorer UI, governance activation           | Complete dashboard, DAO tools, first governance votes      |
| v1.5  | Q1-Q2 2026 | DeFi integrations, partial fiat reduction to 35% | Integration contracts, expanded token support              |
| v1.7  | Q3-Q4 2026 | RESI as payroll layer, fiat reduction to 25%     | Payroll streaming integration, cross-chain bridging        |
| v2    | 2027       | UVU v2 (80% crypto-native, 20% fiat)             | Enhanced oracle design, L2 deployment                      |
| v3    | 2028       | UVU v3 (100% crypto-native), cross-chain oracle  | Trustless cross-chain oracle system, treasury-as-a-service |

---

### 7. Risks & Considerations

| Risk                           | Likelihood | Impact | Mitigation Strategy                                                            |
| ------------------------------ | ---------- | ------ | ------------------------------------------------------------------------------ |
| Oracle Manipulation            | Medium     | High   | Multi-source aggregation; outlier rejection; time-delay on price updates; TWAP |
| Fiat Stablecoin Depegs         | Medium     | Medium | Diversified basket; automatic FX oracle switch; reserve buffers                |
| Illiquid UVU Components        | Medium     | Medium | Minimum liquidity thresholds; TVL requirements; gradual position adjustments   |
| Governance Capture             | Low        | High   | Quadratic voting; token lock-up periods; reputation-weighted proposals         |
| Basket Correlation Risk        | Medium     | Medium | Correlation matrix monitoring; diversity enforcement algorithm                 |
| Smart Contract Vulnerabilities | Low        | High   | Multiple audits; formal verification; bug bounty program                       |

---

### 8. Conclusion

UVU represents a fundamental reimagining of value representation in DeFi—moving from arbitrary fiat pegs to a basket that measures actual economic utility in the decentralized ecosystem.

By grounding stable value in on-chain productivity rather than legacy systems, UVU and RESI provide a radically new take on money—one where value comes from what we build and use, not what central banks print.

The technical architecture described here provides a robust foundation for implementing this vision, with concrete mechanisms for governance, transparency, peg maintenance, and risk management. As the system matures, the gradual transition from partial fiat backing to fully crypto-native utility backing will represent a significant step toward true decentralized financial infrastructure.

This is what stability looks like in the decentralized era.
