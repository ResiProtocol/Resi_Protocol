# Project UVU - Incremental Alpha Release Roadmap

This document outlines the planned sprint-by-sprint development and release schedule for Project UVU. Each sprint is two weeks long and results in a new alpha version deployed to a testnet. These alpha versions are standalone, demonstrating a small part of the final application, with each new version incrementally building on top of the previous one.

## Foundational Principles

- **Incremental Delivery:** Deliver working, testable software in small increments.
- **Modularity:** Build components that are as independent as possible.
- **Testability:** Ensure each feature can be tested and demonstrated.
- **Feedback Loop:** Use alpha releases to gather feedback for subsequent sprints.

## Target Full Directory Structure (Reference)

_(This is the target structure we are building towards, as previously discussed. It won't be fully realized until later sprints.)_

```
.
├── .env.example
├── .gitattributes
├── .gitignore
├── LICENSE
├── README.md
├── hardhat.config.js
├── package.json
├── tsconfig.json
│
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── workflows/
│
├── ai_system/
│   ├── data/
│   ├── models/
│   ├── notebooks/
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   └── requirements.txt
│
├── contracts/
│   ├── UVU/
│   ├── collateral/
│   ├── cross_chain/
│   ├── governance/
│   ├── interfaces/
│   ├── libraries/
│   ├── mocks/
│   ├── oracles/
│   └── zkp/
│
├── docs/
│   ├── AI_driven_stability_system_architecture.md
│   ├── UVU_technical_architecture.md
│   ├── Zero_Knowledge_Proof_Specs.md
│   ├── architecture.md
│   ├── collateralManagementSystemTechnicalSpecs.md
│   ├── cross-chainSpecifications.md
│   ├── hybridGovernanceSystemTechnicalDesign.md
│   ├── oracleAggregation_and_dataValidation.md
│   ├── projectRequirements.md
│   ├── smartContractTechnicalSpecs.md
│   ├── UIUX_designSpecs.md
│   ├── api/
│   └── diagrams/
│
├── infra/
│   ├── docker-compose.yml
│   ├── kubernetes/
│   └── terraform/
│
├── scripts/
│   ├── deployment/
│   ├── migrations/
│   └── utils/
│
├── src/ (backend)
│   ├── api/
│   ├── app.js
│   ├── config/
│   ├── core/
│   ├── modules/
│   ├── server.js
│   └── utils/
│
├── tests/
│   ├── .mocharc.js
│   ├── contracts/
│   ├── e2e/
│   ├── fixtures/
│   ├── integration/
│   └── unit/
│
└── ui/
  ├── public/
  ├── src/
  ├── .env.example
  ├── package.json
  └── vite.config.js
```

---

## Sprint 1: Alpha v0.1 - Core UVU Token & Basic Wallet Interaction

- **Sprint Goal:** Establish the foundational UVU token (UVUToken) and allow users to connect their wallets and view their token balance on a testnet.
- **Key Features & Functionality Delivered:**
- `UVUToken.sol` smart contract (basic ERC20 functionality: name, symbol, decimals, totalSupply, balanceOf, transfer).
- Deployment script for `UVUToken.sol` to a testnet.
- Minimalist UI:
- Wallet connection (e.g., MetaMask).
- Display connected account address.
- Display UVUToken balance for the connected account.
- Basic backend service to query token balance (can be direct frontend-to-contract interaction initially if simpler for this stage).
- **Project Directory Structure (at end of Sprint 1):**

```
.
├── README.md
├── hardhat.config.js       # Or Truffle equivalent
├── package.json            # Root package.json for contract dev
│
├── contracts/
│   └── UVU/
│       └── UVUToken.sol    # New
│
├── scripts/
│   └── deployment/
│       └── deploy_UVUToken.js # New
│
└── ui/                         # New
  ├── public/
  │   └── index.html
  ├── src/
  │   ├── App.jsx
  │   ├── components/
  │   │   └── WalletConnect.jsx # New
  │   ├── contexts/
  │   │   └── Web3Context.js    # New (for wallet state)
  │   ├── index.jsx
  │   └── pages/
  │       └── HomePage.jsx      # New (displays balance)
  ├── package.json            # Frontend specific
  └── vite.config.js          # Or CRA/Next.js config
```

- **Technical Focus & Implementation Details:**
- Smart Contract: Solidity for `UVUToken.sol`.
- Development Environment: Hardhat or Truffle.
- Frontend: React/Vue/Angular (chosen framework). Ethers.js or Web3.js for blockchain interaction.

---

## Sprint 2: Alpha v0.2 - Basic UVU Minting (Admin Controlled)

- **Sprint Goal:** Introduce a mechanism to mint UVU tokens, initially controlled by an admin/owner of the `UVUCore` contract.
- **Key Features & Functionality Delivered:**
- `UVUCore.sol` smart contract (initial, simple version):
- Ownable/Admin-restricted `mint(address recipient, uint256 amount)` function.
- `UVUToken` address set in constructor.
- `UVUCore.sol` grants minting role/permission to `UVUToken.sol`.
- Deployment scripts for `UVUCore.sol` and linking it with `UVUToken.sol`.
- Minimal UI/Script for admin to trigger minting to a specified address.
- User UI updates to reflect newly minted token balances.
- **Project Directory Structure (Changes from v0.1):**

```
.
├── ... (previous files)
│
├── contracts/
│   ├── UVU/
│   │   ├── UVUToken.sol
│   │   └── UVUCore.sol     # New
│   └── interfaces/         # New
│       └── IUVUCore.sol    # New
│
├── scripts/
│   └── deployment/
│       ├── deploy_UVUToken.js
│       └── deploy_UVUCore.js # New
│
├── src/ (backend - optional, could be scripts for now) # New or expanded
│   ├── api/
│   │   └── v1/
│   │       └── admin_routes.js # New (if backend handles admin mint)
│   ├── app.js
│   ├── core/
│   │   └── blockchain/
│   │       └── web3_service.js
│   └── server.js
│
└── ui/
  ├── src/
  │   ├── features/         # New
  │   │   └── admin/
  │   │       └── MintUVUForm.jsx # New (simple form for admin)
  │   └── services/         # New
  │       └── uvuService.js   # New (to interact with UVUCore for minting if via backend)
  └── ... (other ui files)
```

- **Technical Focus & Implementation Details:**
- Smart Contracts: `UVUCore.sol` with minting logic. Role-based access control (e.g., OpenZeppelin's `Ownable` or `AccessControl`).
- Backend (Optional): A simple Node.js/Express backend could provide an API for the admin minting function, or it could be done via scripts.

---

## Sprint 3: Alpha v0.3 - Initial Collateral Deposit (Single Mock Asset)

- **Sprint Goal:** Allow users to deposit a single type of mock ERC20 collateral into a basic `CollateralManager` contract.
- **Key Features & Functionality Delivered:**
- `MockERC20.sol` contract to simulate collateral (e.g., wETH, USDC).
- `CollateralManager.sol` (initial version):
- Function to deposit `MockERC20` tokens.
- Tracks deposited collateral balances per user.
- Deployment scripts for `MockERC20.sol` and `CollateralManager.sol`.
- UI for users to:
- Approve `CollateralManager.sol` to spend their `MockERC20`.
- Deposit `MockERC20` into `CollateralManager.sol`.
- View their deposited `MockERC20` balance.
- **Project Directory Structure (Changes from v0.2):**

```
.
├── ...
│
├── contracts/
│   ├── UVU/
│   │   └── ...
│   ├── collateral/         # New
│   │   └── CollateralManager.sol # New
│   ├── interfaces/
│   │   └── IERC20.sol      # New (standard interface)
│   └── mocks/              # New
│       └── MockERC20.sol   # New
│
├── scripts/
│   └── deployment/
│       ├── ...
│       ├── deploy_MockERC20.js        # New
│       └── deploy_CollateralManager.js # New
│
├── src/ (backend - if handling interactions)
│   ├── api/
│   │   └── v1/
│   │       └── collateral_routes.js # New
│   ├── modules/
│   │   └── collateral/         # New
│   │       ├── collateral_controller.js
│   │       └── collateral_service.js
│
└── ui/
  ├── src/
  │   ├── features/
  │   │   ├── admin/
  │   │   └── collateral/     # New
  │   │       ├── DepositCollateralForm.jsx
  │   │       └── CollateralBalanceView.jsx
  │   ├── services/
  │   │   └── collateralService.js # New
  └── ...
```

- **Technical Focus & Implementation Details:**
- Smart Contracts: `CollateralManager.sol` focusing on deposit logic and balance tracking. `MockERC20.sol` for testing.
- UI: Forms for approval and deposit, display of collateral balances.

---

## Sprint 4: Alpha v0.4 - Minting UVU Against Collateral

- **Sprint Goal:** Enable users to mint UVU tokens based on their deposited collateral, introducing a basic, fixed Collateralization Ratio (CR).
- **Key Features & Functionality Delivered:**
- Update `UVUCore.sol` to allow `CollateralManager.sol` to trigger minting.
- Update `CollateralManager.sol`:
- Function to mint UVU against deposited collateral.
- Internal logic to check against a hardcoded CR (e.g., 150%).
- Interaction with `UVUCore.sol` to mint UVU.
- UI for users to:
- Specify the amount of UVU to mint against their collateral.
- View their current CR (calculated in UI or backend).
- **Project Directory Structure (Changes from v0.3):**

```
.
├── ...
│
├── contracts/
│   ├── UVU/
│   │   └── UVUCore.sol         # Updated (e.g. add minter role for CollateralManager)
│   ├── collateral/
│   │   └── CollateralManager.sol # Updated (mintUVU logic, CR check)
│   └── ...
│
├── src/ (backend)
│   ├── modules/
│   │   ├── uvu_protocol/       # New or expanded if not present
│   │   │   ├── uvu_controller.js
│   │   │   └── uvu_service.js (handles minting logic via CollateralManager)
│   │   └── collateral/         # Updated
│
└── ui/
  ├── src/
  │   ├── features/
  │   │   ├── uvu/            # New or expanded
  │   │   │   └── MintUVUWithCollateralForm.jsx # New
  │   │   └── collateral/
  │   │       └── CRatioView.jsx # New
  └── ...
```

- **Technical Focus & Implementation Details:**
- Smart Contracts: Interaction logic between `CollateralManager` and `UVUCore`. CR enforcement.
- Math: Careful calculation of mintable amounts based on CR.

---

## Sprint 5: Alpha v0.5 - Basic Oracle Integration & Price Feed for Collateral

- **Sprint Goal:** Integrate a basic oracle (can be a mock oracle contract or a single, reliable testnet price feed like Chainlink) to value the deposited collateral.
- **Key Features & Functionality Delivered:**
- `IOracle.sol` interface.
- `MockOracle.sol` contract (if a live feed isn't used yet) that allows an admin to set the price of the collateral asset.
- Update `CollateralManager.sol` to:
- Read collateral price from the oracle contract.
- Use this price in CR calculations when minting UVU.
- Deployment script for the oracle contract.
- UI to display the current oracle price of the collateral.
- **Project Directory Structure (Changes from v0.4):**

```
.
├── ...
│
├── contracts/
│   ├── collateral/
│   │   └── CollateralManager.sol # Updated (use oracle price)
│   ├── interfaces/
│   │   ├── ...
│   │   └── IOracle.sol           # New
│   ├── mocks/
│   │   ├── MockERC20.sol
│   │   └── MockOracle.sol        # New
│   └── oracles/                # New
│       └── OracleAggregator.sol  # Initial simple version, maybe just a proxy to MockOracle
│
├── scripts/
│   └── deployment/
│       ├── ...
│       └── deploy_Oracle.js      # New (for MockOracle/OracleAggregator)
│
└── ui/
  ├── src/
  │   ├── features/
  │   │   └── collateral/
  │   │       ├── ...
  │   │       └── CollateralPriceView.jsx # New
  └── ...
```

- **Technical Focus & Implementation Details:**
- Smart Contracts: Oracle interaction. Ensuring price data is correctly fetched and used.
- If using Chainlink testnet feeds, integrate their interface.

---

## Sprint 6: Alpha v0.6 - Repaying UVU & Withdrawing Collateral

- **Sprint Goal:** Allow users to repay their minted UVU (which burns the UVU) and subsequently withdraw their deposited collateral.
- **Key Features & Functionality Delivered:**
- Update `UVUCore.sol` to include a `burnFrom(address account, uint256 amount)` function, callable by `CollateralManager.sol`.
- Update `CollateralManager.sol`:
- Function to repay UVU (burns UVU via `UVUCore`).
- Function to withdraw collateral (allowed after UVU debt related to it is cleared or proportionally).
- UI for users to:
- Repay UVU.
- Withdraw collateral.
- **Project Directory Structure (Changes from v0.5):**

```
.
├── ...
│
├── contracts/
│   ├── UVU/
│   │   └── UVUCore.sol         # Updated (burn logic)
│   ├── collateral/
│   │   └── CollateralManager.sol # Updated (repayUVU, withdrawCollateral logic)
│   └── ...
│
└── ui/
  ├── src/
  │   ├── features/
  │   │   ├── uvu/
  │   │   │   ├── ...
  │   │   │   └── RepayUVUForm.jsx # New
  │   │   └── collateral/
  │   │       ├── ...
  │   │       └── WithdrawCollateralForm.jsx # New
  └── ...
```

- **Technical Focus & Implementation Details:**
- Smart Contracts: Logic for burning UVU and releasing collateral, ensuring atomicity or correct state updates.

---

## Sprint 7: Alpha v0.7 - Basic Liquidation Mechanism

- **Sprint Goal:** Implement a simplified liquidation mechanism for positions that fall below a minimum CR (liquidation threshold).
- **Key Features & Functionality Delivered:**
- Update `CollateralManager.sol`:
- Define a liquidation threshold (e.g., 125%).
- Function `liquidate(address positionOwner)` callable by anyone.
- Logic to check if a position is undercollateralized.
- If undercollateralized, seize collateral, repay UVU debt (to `UVUCore`), and potentially offer a discount to the liquidator.
- UI to:
- View positions eligible for liquidation (simplified list).
- Allow users to trigger a liquidation.
- Backend (optional): Event listener to monitor for potentially liquidatable positions.
- **Project Directory Structure (Changes from v0.6):**

```
.
├── ...
│
├── contracts/
│   ├── collateral/
│   │   └── CollateralManager.sol # Updated (liquidation logic)
│   └── ...
│
├── src/ (backend - if event monitoring)
│   ├── core/
│   │   └── event_handlers/     # New or expanded
│   │       └── liquidation_monitor.js
│
└── ui/
  ├── src/
  │   ├── features/
  │   │   └── collateral/
  │   │       ├── ...
│   │       ├── LiquidationView.jsx # New (list liquidatable positions)
│   │       └── TriggerLiquidationButton.jsx # New
  └── ...
```

- **Technical Focus & Implementation Details:**
- Smart Contracts: Liquidation logic, ensuring fairness and correctness. Handling of seized collateral and debt repayment.
- Consideration of liquidation incentives.

---

## Sprint 8: Alpha v0.8 - AI System: Initial Setup & Mock Integration

- **Sprint Goal:** Set up the basic directory structure and infrastructure for the AI-driven stability system. Integrate a mock AI component that provides placeholder stability data.
- **Key Features & Functionality Delivered:**
- `ai_system/` directory created with subfolders for `data`, `models`, `src`.
- A simple Python script in `ai_system/src/inference/` that acts as a mock AI predictor (e.g., returns a random or fixed stability score).
- Basic Dockerfile for the AI system (even if just serving the mock script via Flask/FastAPI).
- Backend (`src/`) API endpoint to query this mock AI system.
- UI element to display the "AI Stability Score" (for demo purposes, not yet influencing the protocol).
- **Project Directory Structure (Changes from v0.7):**

```
.
├── ...
│
├── ai_system/                  # New
│   ├── data/
│   │   └── raw/
│   │       └── sample_market_data.csv # Example
│   ├── models/                 # Empty or placeholder
│   ├── src/
│   │   └── inference/
│   │       └── predictor.py    # New (mock predictor)
│   ├── Dockerfile              # New (basic for AI service)
│   └── requirements.txt        # New (e.g., flask)
│
├── src/ (backend)
│   ├── api/
│   │   └── v1/
│   │       ├── ...
│   │       └── ai_routes.js    # New
│   ├── modules/
│   │   ├── ...
│   │   └── ai_integration/   # New
│   │       ├── ai_controller.js
│   │       └── ai_service.js (calls the mock AI system)
│
└── ui/
  ├── src/
  │   ├── features/
  │   │   ├── ...
  │   │   └── stability/      # New
  │   │       └── StabilityScoreView.jsx # New
  │   └── services/
  │       ├── ...
  │       └── aiService.js      # New
  └── ...
```

- **Technical Focus & Implementation Details:**
- AI System: Python, Flask/FastAPI for the mock service. Docker for containerization.
- Backend: Service-to-service communication (backend to AI system).

---

## Sprint 9: Alpha v0.9 - AI System: Basic Model Training & Prediction

- **Sprint Goal:** Develop and train a first-pass, simple machine learning model for the AI stability system. Integrate its actual (though still basic) predictions into the backend.
- **Key Features & Functionality Delivered:**
- `ai_system/notebooks/` for model exploration (e.g., `data_analysis.ipynb`, `model_prototyping.ipynb`).
- `ai_system/src/data_processing/` for scripts to clean/prepare data (can use sample data).
- `ai_system/src/training/train.py` script for a simple ML model (e.g., linear regression, decision tree on mock/sample market data).
- Trained model saved in `ai_system/models/`.
- Update `ai_system/src/inference/predictor.py` to load and use the trained model.
- Backend receives actual (but simple) predictions from the AI system.
- AI's output (e.g., predicted market volatility, suggested CR adjustment factor) is logged or displayed in UI but does not yet actively control protocol parameters.
- **Project Directory Structure (Changes from v0.8):**

```
.
├── ...
│
├── ai_system/
│   ├── data/
│   │   ├── processed/      # New
│   │   └── raw/
│   ├── models/
│   │   └── stability_model_v0_1.pkl # New (trained model)
│   ├── notebooks/              # New
│   │   ├── data_analysis.ipynb
│   │   └── model_prototyping.ipynb
│   ├── src/
│   │   ├── data_processing/    # New
│   │   │   └── preprocessor.py
│   │   ├── inference/
│   │   │   └── predictor.py  # Updated
│   │   └── training/           # New
│   │       └── train.py
│   └── ...
│
└── ... (Backend and UI might have minor changes to display more detailed AI output)
```

- **Technical Focus & Implementation Details:**
- AI System: Scikit-learn or similar ML library. Focus on the MLOps pipeline (data processing, training, inference).

---

## Sprint 10: Alpha v0.10 - Governance: Token & Basic Proposal Submission (Off-Chain Data)

- **Sprint Goal:** Introduce the governance token (`GovToken`) and a basic mechanism for creating proposals (proposal data stored off-chain initially, e.g., in a backend database).
- **Key Features & Functionality Delivered:**
- `GovernanceToken.sol` (standard ERC20).
- Deployment script for `GovernanceToken.sol`.
- Mechanism to distribute `GovernanceToken` to testers.
- UI to view `GovernanceToken` balance.
- Backend API and UI form to submit a new proposal (e.g., title, description, proposed action as text). Proposals stored in a simple database.
- UI to list submitted proposals.
- **Project Directory Structure (Changes from v0.9):**

```
.
├── ...
│
├── contracts/
│   ├── ...
│   └── governance/             # New
│       └── GovernanceToken.sol # New
│
├── scripts/
│   └── deployment/
│       ├── ...
│       └── deploy_GovernanceToken.js # New
│
├── src/ (backend)
│   ├── api/
│   │   └── v1/
│   │       ├── ...
│   │       └── governance_routes.js # New
│   ├── core/
│   │   └── database/           # New (if not already present for other features)
│   │       ├── models/
│   │       │   └── Proposal.js # New (e.g., Mongoose schema)
│   │       └── connect.js
│   ├── modules/
│   │   ├── ...
│   │   └── governance/         # New
│   │       ├── governance_controller.js
│   │       ├── governance_service.js
│   │       └── governance_model.js (interacts with DB)
│
└── ui/
  ├── src/
  │   ├── features/
  │   │   ├── ...
  │   │   └── governance/     # New
  │   │       ├── GovernanceTokenBalance.jsx
  │   │       ├── CreateProposalForm.jsx
  │   │       └── ProposalListView.jsx
  │   ├── services/
  │   │   ├── ...
  │   │   └── governanceService.js # New
  └── ...
```

- **Technical Focus & Implementation Details:**
- Smart Contracts: `GovernanceToken.sol`.
- Backend: CRUD operations for proposals. Database choice (e.g., MongoDB, PostgreSQL).

---

## Sprint 11: Alpha v0.11 - Governance: Basic On-Chain Voting

- **Sprint Goal:** Implement on-chain voting for the text-based proposals created in the previous sprint.
- **Key Features & Functionality Delivered:**
- `ProposalContract.sol`: Manages proposal lifecycle (e.g., creation (referencing off-chain data via ID), voting period, execution state).
- `VotingContract.sol`: Handles vote casting (yes/no/abstain) using `GovernanceToken` balances.
- Link `ProposalContract` to `GovernanceToken` and `VotingContract`.
- UI to:
- View active proposals (fetched from backend, linked to on-chain proposal ID).
- Cast votes on proposals (interacting with `VotingContract`).
- View voting results.
- **Project Directory Structure (Changes from v0.10):**

```
.
├── ...
│
├── contracts/
│   └── governance/
│       ├── GovernanceToken.sol
│       ├── ProposalContract.sol # New
│       └── VotingContract.sol   # New
│
├── scripts/
│   └── deployment/
│       ├── ...
│       └── deploy_GovernanceContracts.js # New/Updated
│
├── src/ (backend)
│   └── modules/
│       └── governance/         # Updated (interact with new contracts)
│
└── ui/
  ├── src/
  │   ├── features/
  │   │   └── governance/
  │   │       ├── ...
  │   │       └── VoteOnProposal.jsx # New
  └── ...
```

- **Technical Focus & Implementation Details:**
- Smart Contracts: Voting logic, proposal state management. Snapshotting of voting power (optional for basic version).

---

## Sprint 12: Alpha v0.12 - Enhanced Oracles: Aggregation & Basic Validation

- **Sprint Goal:** Enhance the oracle system to aggregate data from multiple sources and perform basic validation checks before providing price feeds to the protocol.
- **Key Features & Functionality Delivered:**
  - Update `OracleAggregator.sol` to support multiple data sources (initially using multiple `MockOracle.sol` instances).
  - Implement aggregation logic (e.g., median, average) within `OracleAggregator.sol`.
  - Introduce `DataValidator.sol` contract with basic validation rules (e.g., check if price is within a certain deviation from the previous price, check if data is not stale).
  - `CollateralManager.sol` updated to fetch prices via the `OracleAggregator.sol`, which internally uses `DataValidator.sol`.
  - Deployment scripts updated for multiple mock oracles and the validator.
  - UI updates to potentially show data from individual mock sources and the aggregated/validated price.
- **Focus Areas from Technical Deep-Dive Documents:**
  - `oracleAggregation_and_dataValidation.md`: Core logic for aggregation and validation.
  - `SmartContractTechnicalSpecs.md`: Details on oracle contract interactions.
- **Project Directory Structure (Changes from v0.11):**
  ```
  .
  ├── ...
  │
  ├── contracts/
  │   ├── collateral/
  │   │   └── CollateralManager.sol # Updated (uses OracleAggregator)
  │   ├── interfaces/
  │   │   ├── ...
  │   │   └── IDataValidator.sol    # New
  │   ├── mocks/
  │   │   ├── MockERC20.sol
  │   │   └── MockOracle.sol        # Multiple instances deployed
  │   └── oracles/
  │       ├── OracleAggregator.sol  # Updated (aggregation logic)
  │       └── DataValidator.sol     # New (validation logic)
  │
  ├── scripts/
  │   └── deployment/
  │       ├── ...
  │       └── deploy_Oracles.js     # Updated (deploy multiple mocks, aggregator, validator)
  │
  └── ui/
      ├── src/
      │   ├── features/
      │   │   └── collateral/
      │   │       ├── ...
      │   │       └── OracleDataView.jsx # New (show multiple sources, aggregated price)
      └── ...
  ```
- **Technical Focus & Implementation Details:**
  - Smart Contracts: Implementing robust aggregation and validation logic on-chain. Handling potential oracle failures or malicious data.
  - Deployment: Managing deployment and linking of multiple oracle sources.

---

## Sprint 13: Alpha v0.13 - AI System: Linking AI Output to Protocol Parameter (Read-Only/Suggestion)

- **Sprint Goal:** Integrate the AI system's predictions into the protocol's information flow, allowing the AI to suggest parameter adjustments (like CR) based on its analysis. These suggestions will be visible but not yet automatically enforced.
- **Key Features & Functionality Delivered:**
  - AI system (`ai_system/`) refined to output specific, structured suggestions (e.g., a recommended CR adjustment factor, a stability score).
  - Backend (`src/`) service (`ai_integration/`) updated to receive these structured suggestions from the AI system.
  - A new contract (`StabilityParameterOracle.sol`) or an update to `UVUCore.sol` to store the latest AI-suggested parameters (pushed by a trusted backend/admin).
  - UI displays the AI's current suggestions prominently (e.g., "AI Suggests CR: 160%").
  - Governance UI (`ui/src/features/governance/`) might show AI suggestions as context for potential governance proposals.
- **Focus Areas from Technical Deep-Dive Documents:**
  - `AI_driven_stability_system_architecture.md`: How AI output influences the protocol.
  - `hybridGovernanceSystemTechnicalDesign.md`: How AI suggestions can inform governance.
  - `SmartContractTechnicalSpecs.md`: Potential contract updates for storing AI parameters.
- **Project Directory Structure (Changes from v0.12):**
  ```
  .
  ├── ...
  │
  ├── ai_system/
  │   ├── models/
  │   │   └── stability_model_v0_2.pkl # Updated/Refined model
  │   ├── src/
  │   │   ├── inference/
  │   │   │   └── predictor.py  # Updated (outputs structured suggestions)
  │   │   └── training/
  │   │       └── train.py      # Updated (trains model for specific outputs)
  │   └── ...
  │
  ├── contracts/
  │   ├── oracles/
  │   │   ├── ...
  │   │   └── StabilityParameterOracle.sol # New (or UVUCore updated)
  │   └── ...
  │
  ├── src/ (backend)
  │   ├── modules/
  │   │   ├── ai_integration/   # Updated (receives structured AI output)
  │   │   └── uvu_protocol/     # Updated (interacts with StabilityParameterOracle)
  │   └── ...
  │
  └── ui/
      ├── src/
      │   ├── features/
      │   │   ├── stability/
      │   │   │   └── StabilitySuggestionView.jsx # New
      │   │   └── governance/
      │   │       └── ProposalListView.jsx # Updated (show AI context)
      │   └── services/
      │       └── aiService.js      # Updated (fetches AI suggestions)
      └── ...
  ```
- **Technical Focus & Implementation Details:**
  - AI System: Ensuring the model outputs are reliable and in a usable format for the protocol.
  - Backend: Securely receiving and handling AI output. Pushing data to the blockchain (requires careful access control).
  - Smart Contracts: Storing and making AI suggestions accessible on-chain.

---

## Sprint 14: Alpha v0.14 - ZKP: Basic Verifier Contract & Off-Chain Proof Generation (Conceptual)

- **Sprint Goal:** Introduce the foundational elements for Zero-Knowledge Proofs (ZKPs) by deploying a basic verifier contract and demonstrating off-chain proof generation for a simple circuit. This sprint focuses on the ZKP infrastructure setup.
- **Key Features & Functionality Delivered:**
  - Setup ZKP development environment (e.g., Circom, SnarkJS, or similar libraries).
  - Create a very simple ZKP circuit (e.g., proving knowledge of a preimage for a hash, or a simple range proof) in `zkp_circuits/`.
  - Generate proving and verification keys for the simple circuit.
  - Deploy the generated Solidity verifier contract (`Verifier.sol`) to the testnet.
  - Develop a script or backend function (`scripts/utils/generate_proof.js` or `src/modules/zkp/`) to generate a proof for the simple circuit off-chain.
  - Develop a script or backend function to submit the generated proof to the `Verifier.sol` contract for verification.
  - UI element (simple button) to trigger the off-chain proof generation and on-chain verification process for the demo circuit.
- **Focus Areas from Technical Deep-Dive Documents:**
  - `Zero_Knowledge_Proof_Specs.md`: ZKP use cases and technical requirements.
  - `SmartContractTechnicalSpecs.md`: Verifier contract integration.
- **Project Directory Structure (Changes from v0.13):**
  ```
  .
  ├── ...
  │
  ├── circuits/ # New Folder (or scripts/utils/zkp_circuits)
  │   └── simple_demo.circom # New (simple ZKP circuit)
  │
  ├── contracts/
  │   ├── zkp/                  # New
  │   │   └── Verifier.sol        # New (Generated Solidity verifier)
  │   └── ...
  │
  ├── scripts/
  │   ├── deployment/
  │   │   ├── ...
  │   │   └── deploy_Verifier.js  # New
  │   └── utils/                # New or expanded
  │       ├── generate_zkp_params.sh # New (script to generate keys)
  │       └── generate_proof.js # New (script/function for off-chain proof generation)
  │
  ├── src/ (backend)
  │   ├── modules/
  │   │   ├── ...
  │   │   └── zkp/              # New
  │   │       ├── zkp_controller.js
  │   │       └── zkp_service.js (handles proof generation/verification calls)
  │   └── ...
  │
  ├── tests/
  │   ├── contracts/
  │   │   ├── ...
  │   │   └── zkp/              # New
  │   │       └── Verifier.test.js # New
  │   └── unit/
  │       └── zkp/              # New
  │           └── proof_generation.test.js # New (test off-chain proof generation)
  │
  └── ui/
      ├── src/
      │   ├── features/
      │   │   ├── ...
      │   │   └── zkp/              # New
      │   │       └── SimpleZkpDemo.jsx # New (UI to trigger demo)
      │   └── services/
      │       ├── ...
      │       └── zkpService.js       # New
      └── ...
  ```
- **Technical Focus & Implementation Details:**
  - ZKP Libraries: Setting up and using Circom/SnarkJS or similar tools. Understanding circuit design basics.
  - Integration: Calling ZKP generation functions from backend/scripts and interacting with the on-chain verifier.
  - Key Management: Basic handling of proving/verification keys (secure key management is for later).

---

## Sprint 15: Alpha v0.15 - Cross-Chain: Basic Bridge Contract (Mock/Single Chain Echo)

- **Sprint Goal:** Implement a basic, mock cross-chain bridge contract to demonstrate the concept of moving assets or information between two testnets (e.g., Goerli and Sepolia). This version will use a simple lock-and-mint or burn-and-mint mechanism with a manual relayer stub.
- **Key Features & Functionality Delivered:**
  - Deploy a simple `Bridge.sol` contract on two different testnets (Chain A and Chain B).
  - The bridge contract on Chain A has a `lockUVUToken(uint256 amount)` function (transfers UVU to the bridge).
  - The bridge contract on Chain B has a `mintWrappedUVUToken(address recipient, uint256 amount)` function (creates a mock "Wrapped UVU" token), callable only by a trusted address (the relayer stub).
  - A mock `WrappedUVUToken.sol` (ERC20) deployed on Chain B.
  - A manual script or simple backend service (`scripts/utils/relayer_stub.js` or `src/modules/cross_chain/`) that acts as a relayer:
    - Monitors Chain A for `UVUTokenLocked` events from the Bridge contract.
    - Calls the `mintWrappedUVUToken` function on the Bridge contract on Chain B with the relevant details.
  - Basic UI to interact with the Bridge contract on Chain A (lock UVU) and view mock Wrapped UVU balance on Chain B.
- **Focus Areas from Technical Deep-Dive Documents:**
  - `cross-chainSpecifications.md`: Cross-chain architecture and bridging requirements.
  - `SmartContractTechnicalSpecs.md`: Bridge contract design.
- **Project Directory Structure (Changes from v0.14):**
  ```
  .
  ├── ...
  │
  ├── contracts/
  │   ├── cross_chain/          # New
  │   │   ├── IBridge.sol         # New
  │   │   └── Bridge.sol          # New (basic lock/mint logic)
  │   ├── tokens/               # New or expanded
  │   │   └── WrappedUVUToken.sol # New (mock ERC20 on destination chain)
  │   └── ...
  │
  ├── scripts/
  │   ├── deployment/
  │   │   ├── ...
  │   │   └── deploy_Bridge.js    # New (deploys to multiple chains)
  │   └── utils/
  │       ├── ...
  │       └── relayer_stub.js     # New (manual/mock relayer)
  │
  ├── src/ (backend)
  │   ├── modules/
  │   │   ├── ...
  │   │   └── cross_chain/      # New
  │   │       ├── cross_chain_controller.js
  │   │       └── cross_chain_service.js (interacts with bridge contracts)
  │   └── ...
  │
  ├── tests/
  │   ├── contracts/
  │   │   ├── ...
  │   │   └── cross_chain/      # New
  │   │       └── Bridge.test.js # New
  │   └── ...
  │
  └── ui/
      ├── src/
      │   ├── features/
      │   │   ├── ...
      │   │   └── cross_chain/      # New
      │   │       └── BridgeInteraction.jsx # New (UI for locking/viewing wrapped tokens)
      │   └── services/
      │       ├── ...
      │       └── crossChainService.js # New
      └── ...
  ```
- **Technical Focus & Implementation Details:**
  - Smart Contracts: Implementing basic lock/mint or burn/mint logic. Handling token transfers securely.
  - Cross-Chain Communication: Understanding event monitoring and transaction relaying between chains (even if manual/mocked).
  - Deployment: Deploying and configuring contracts on multiple networks.

---

## Sprint 16: Alpha v0.16 - Advanced Collateral Management: Multiple Collateral Types & Basic Risk Parameters

- **Sprint Goal:** Enhance the `CollateralManager` to support multiple types of mock ERC20 collateral, each with its own basic risk parameters (e.g., individual Collateralization Ratio, debt ceiling).
- **Key Features & Functionality Delivered:**
  - Update `CollateralManager.sol` to include a registry for whitelisted collateral asset types.
  - Each registered collateral type can have distinct parameters: CR, liquidation threshold, debt ceiling.
  - Admin-controlled functions to add new collateral types and update their risk parameters.
  - `OracleAggregator.sol` (and its underlying mock oracles) updated to provide price feeds for these new collateral types.
  - UI updated to allow users to:
    - Select which collateral type they want to deposit.
    - View their positions and CRs per collateral type.
    - Mint UVU against their aggregated collateral value (or per type, TBD).
  - Deployment scripts for new mock collateral tokens and their mock oracles.
- **Focus Areas from Technical Deep-Dive Documents:**
  - `collateralManagementSystemTechnicalSpecs.md`: Core logic for multi-collateral support and risk parameters.
  - `oracleAggregation_and_dataValidation.md`: Ensuring price feeds for all supported collaterals.
  - `SmartContractTechnicalSpecs.md`: Updates to `CollateralManager` interfaces.
- **Project Directory Structure (Changes from v0.15):**
  ```
  .
  ├── ...
  │
  ├── contracts/
  │   ├── collateral/
  │   │   └── CollateralManager.sol # Updated (multi-collateral logic, risk params)
  │   ├── interfaces/
  │   │   └── ...                 # Potentially new interfaces for collateral parameters
  │   ├── mocks/
  │   │   ├── MockERC20_AssetA.sol  # Renamed/kept
  │   │   ├── MockERC20_AssetB.sol  # New
  │   │   ├── MockOracle_AssetA.sol # Renamed/kept
  │   │   └── MockOracle_AssetB.sol # New
  │   └── oracles/
  │       └── OracleAggregator.sol  # Updated (support multiple asset prices)
  │
  ├── scripts/
  │   └── deployment/
  │       ├── ...
  │       └── deploy_CollateralAssets.js # New/Updated (deploy multiple mock assets & oracles)
  │
  └── ui/
      ├── src/
      │   ├── features/
      │   │   └── collateral/
      │   │       ├── DepositCollateralForm.jsx # Updated (select asset type)
      │   │       └── CollateralPortfolioView.jsx # New (view multiple collateral positions)
      │   └── services/
      │       └── collateralService.js    # Updated
      └── ...
  ```
- **Technical Focus & Implementation Details:**
  - Smart Contracts: Managing mappings for different collateral types and their parameters. Ensuring correct CR calculations with multiple collateral assets.
  - Oracles: Robustly handling price feeds for an expanding set of assets.
  - UI: Clear presentation of multi-collateral positions and interactions.

---

## Sprint 17: Alpha v0.17 - Hybrid Governance System: On-Chain Execution of Simple Parameter Changes

- **Sprint Goal:** Enable the governance system to execute simple on-chain parameter changes (e.g., updating a CR for a collateral type, adjusting a fee) based on successful votes, introducing a Timelock contract.
- **Key Features & Functionality Delivered:**
  - Introduce `Timelock.sol` contract: proposals, once passed, are queued here for a defined delay before execution.
  - `ProposalContract.sol` updated to interact with `Timelock.sol` upon successful vote completion (queueing proposals).
  - Target contracts (e.g., `CollateralManager.sol`, `UVUCore.sol`) updated with specific setter functions callable only by the `Timelock` contract.
  - Governance UI updated to:
    - Show proposals in the Timelock queue with their execution time.
    - Allow authorized roles (e.g., Timelock admin/executor) to execute queued proposals after the delay.
  - Deployment scripts for `Timelock.sol` and linking it with `ProposalContract.sol`.
- **Focus Areas from Technical Deep-Dive Documents:**
  - `hybridGovernanceSystemTechnicalDesign.md`: Timelock mechanism, proposal execution flow.
  - `SmartContractTechnicalSpecs.md`: Interfaces for executable proposals and parameter setters.
- **Project Directory Structure (Changes from v0.16):**
  ```
  .
  ├── ...
  │
  ├── contracts/
  │   ├── UVU/
  │   │   └── UVUCore.sol             # Updated (setters callable by Timelock)
  │   ├── collateral/
  │   │   └── CollateralManager.sol     # Updated (setters callable by Timelock)
  │   ├── governance/
  │   │   ├── ProposalContract.sol    # Updated (interacts with Timelock)
  │   │   ├── VotingContract.sol
  │   │   ├── GovernanceToken.sol
  │   │   └── Timelock.sol            # New
  │   └── interfaces/
  │       └── ITimelock.sol           # New
  │
  ├── scripts/
  │   └── deployment/
  │       ├── deploy_GovernanceContracts.js # Updated (include Timelock)
  │       └── ...
  │
  └── ui/
      ├── src/
      │   ├── features/
      │   │   └── governance/
      │   │       ├── ProposalListView.jsx    # Updated (show Timelock status)
      │   │       └── TimelockQueueView.jsx   # New
      └── ...
  ```
- **Technical Focus & Implementation Details:**
  - Smart Contracts: Secure implementation of Timelock logic. Correct access controls for parameter-setting functions. Encoding proposal execution calls.
  - Governance Flow: Ensuring the end-to-end flow from proposal creation to on-chain execution via Timelock is robust.

---

## Sprint 18: Alpha v0.18 - AI Integration: AI-Driven Parameter Suggestions to Governance

- **Sprint Goal:** Enable the AI system to actively generate suggestions for protocol parameter changes (e.g., CR adjustments, risk scores for collateral types) and submit these as formal proposals to the governance system.
- **Key Features & Functionality Delivered:**
  - AI system (`ai_system/`) enhanced to generate structured proposal data (target contract address, function signature, encoded parameters) for specific parameter adjustments.
  - Backend service (`src/modules/ai_integration/` or `src/modules/governance/`) to:
    - Receive structured proposals from the AI system.
    - Validate these AI-generated proposals (sanity checks).
    - Submit these proposals to `ProposalContract.sol` (potentially via a whitelisted AI agent address or an admin-mediated step).
  - Governance UI clearly identifies proposals originating from the AI system.
  - AI suggestions are logged and their impact (if adopted) can be tracked.
- **Focus Areas from Technical Deep-Dive Documents:**
  - `AI_driven_stability_system_architecture.md`: Mechanism for AI to influence protocol parameters.
  - `hybridGovernanceSystemTechnicalDesign.md`: Integrating AI-generated proposals into the governance workflow.
- **Project Directory Structure (Changes from v0.17):**
  ```
  .
  ├── ...
  │
  ├── ai_system/
  │   ├── models/
  │   │   └── stability_model_v0_3.pkl # Model capable of suggesting parameters
  │   ├── src/
  │   │   ├── inference/
  │   │   │   └── predictor.py  # Updated (generates proposal data)
  │   │   └── utils/
  │   │       └── proposal_formatter.py # New (formats AI output to proposal structure)
  │   └── ...
  │
  ├── src/ (backend)
  │   ├── modules/
  │   │   ├── ai_integration/   # Updated (handles AI proposal submission)
  │   │   └── governance/       # Potentially updated to handle AI proposal source
  │   └── ...
  │
  └── ui/
      ├── src/
      │   ├── features/
      │   │   └── governance/
      │   │       └── ProposalListView.jsx # Updated (indicate AI-sourced proposals)
      └── ...
  ```
- **Technical Focus & Implementation Details:**
  - AI System: Developing models that can reliably output actionable and safe parameter suggestions.
  - Backend: Secure and reliable pipeline for AI suggestions to reach the governance contract. Implementing safeguards against malicious or erroneous AI proposals.
  - Smart Contracts: Ensuring `ProposalContract.sol` can correctly interpret and process proposals with encoded function calls.

---

## Sprint 19: Alpha v0.19 - Advanced ZKP Use Case: Private Balance Proof

- **Sprint Goal:** Implement a ZKP circuit and associated contracts allowing users to prove they hold a minimum balance of UVUToken or GovToken without revealing their exact balance. This could be used for tiered feature access or airdrop eligibility.
- **Key Features & Functionality Delivered:**
  - A new ZKP circuit (e.g., `balance_proof.circom` in `circuits/`) designed to prove `balance >= threshold_amount`.
  - Generation of proving and verification keys for this new circuit.
  - A new Solidity verifier contract (`BalanceProofVerifier.sol`) deployed to the testnet.
  - A new example contract (`GatedFeature.sol`) that requires a valid proof from `BalanceProofVerifier.sol` (for a specific token and threshold) before allowing a user to call a function.
  - Backend/script updates in `src/modules/zkp/` or `scripts/utils/` to generate proofs for this circuit.
  - UI elements for users to:
    - Generate a balance proof for a specified token and threshold.
    - Interact with the `GatedFeature.sol` contract by submitting their proof.
- **Focus Areas from Technical Deep-Dive Documents:**
  - `Zero_Knowledge_Proof_Specs.md`: Specific use cases for ZKPs like private attestations.
  - `SmartContractTechnicalSpecs.md`: Integration of new ZKP verifiers.
- **Project Directory Structure (Changes from v0.18):**
  ```
  .
  ├── ...
  │
  ├── circuits/
  │   ├── simple_demo.circom
  │   └── balance_proof.circom    # New
  │
  ├── contracts/
  │   ├── zkp/
  │   │   ├── Verifier.sol          # Existing simple verifier
  │   │   └── BalanceProofVerifier.sol # New
  │   ├── UVU/                    # Or a new 'examples' folder
  │   │   └── GatedFeature.sol      # New example contract using ZKP
  │   └── ...
  │
  ├── scripts/
  │   ├── deployment/
  │   │   ├── ...
  │   │   └── deploy_BalanceProofVerifier.js # New
  │   └── utils/
  │       ├── generate_zkp_params.sh # Updated or new script for balance_proof
  │       └── generate_proof.js      # Updated to support balance_proof
  │
  ├── src/ (backend)
  │   └── modules/
  │       └── zkp/                  # Updated (service for balance_proof)
  │
  ├── tests/
  │   ├── contracts/
  │   │   └── zkp/
  │   │       └── BalanceProofVerifier.test.js # New
  │   └── unit/
  │       └── zkp/
  │           └── balance_proof_generation.test.js # New
  │
  └── ui/
      ├── src/
      │   ├── features/
      │   │   └── zkp/
      │   │       ├── SimpleZkpDemo.jsx
      │   │       └── BalanceProofDemo.jsx # New
      └── ...
  ```
- **Technical Focus & Implementation Details:**
  - ZKP Circuit Design: Creating an efficient and secure circuit for balance proofs.
  - Smart Contracts: Integrating the new verifier and ensuring the `GatedFeature` contract correctly uses the proofs.
  - User Experience: Simplifying the proof generation and submission process for the user.

---

## Sprint 20: Alpha v0.20 - Real Cross-Chain Integration: Basic Message Passing Protocol

- **Sprint Goal:** Replace the mock cross-chain relayer with an integration to a basic, testnet-supported, generalized cross-chain messaging protocol (e.g., LayerZero, Axelar, CCIP - selecting one for this alpha).
- **Key Features & Functionality Delivered:**
  - Update `Bridge.sol` contracts on both Chain A and Chain B to utilize the chosen messaging protocol's interfaces for sending and receiving messages (e.g., implementing the protocol's endpoint interface).
  - Remove the manual `relayer_stub.js`.
  - Backend service (`src/modules/cross_chain/`) might be updated to handle any specific requirements of the chosen messaging protocol (e.g., fee payments, message formatting).
  - Demonstrate asset transfer (UVU to WrappedUVU and back) using the integrated messaging protocol, relying on its existing testnet relayers.
  - UI updated to reflect transaction status as reported by the messaging protocol.
- **Focus Areas from Technical Deep-Dive Documents:**
  - `cross-chainSpecifications.md`: Requirements for a robust cross-chain solution.
  - `SmartContractTechnicalSpecs.md`: Adapting bridge contracts for external protocols.
- **Project Directory Structure (Changes from v0.19):**
  ```
  .
  ├── ...
  │
  ├── contracts/
  │   ├── cross_chain/
  │   │   ├── IBridge.sol
  │   │   └── Bridge.sol          # Significantly updated to use messaging protocol
  │   └── interfaces/             # May include interfaces from the chosen messaging protocol
  │       └── ICrossChainMessagingProtocol.sol # Example
  │
  ├── scripts/
  │   ├── deployment/
  │   │   └── deploy_Bridge.js    # Updated (configuration for messaging protocol)
  │   └── utils/
  │       └── relayer_stub.js     # Removed or archived
  │
  ├── src/ (backend)
  │   └── modules/
  │       └── cross_chain/      # Updated (interact with messaging protocol SDK/API)
  │
  ├── package.json                # Updated with SDK for the chosen messaging protocol
  │
  └── ui/
      ├── src/
      │   ├── features/
      │   │   └── cross_chain/
      │   │       └── BridgeInteraction.jsx # Updated (show status from messaging protocol)
      └── ...
  ```
- **Technical Focus & Implementation Details:**
  - Messaging Protocol Integration: Correctly implementing the chosen protocol's interfaces and handling its specific message formats, fees, and security considerations.
  - Smart Contracts: Ensuring the `Bridge.sol` contracts are secure and correctly interact with the external protocol.
  - Error Handling: Managing potential failures or delays in cross-chain message delivery.

---

_(Further sprints will focus on UI/UX polish based on `UIUX_designSpecs.md`, comprehensive security audits, infrastructure setup for production (`infra/` directory), full documentation, and iterative refinement of all implemented features based on testing and feedback, leading towards a mainnet-ready product.)_

Each of these later sprints will see corresponding additions and modifications to the project directory, gradually building out the full structure. For instance, implementing the full `oracleAggregation_and_dataValidation.md` will involve more sophisticated contracts in `contracts/oracles/` and backend logic in `src/modules/oracles/`.

This roadmap provides a structured approach to incrementally build and test the complex UVU system. Regular reviews and adaptations will be crucial as development progresses.

```

This `PROJECT_ROADMAP.md` file outlines the incremental development plan. Each sprint builds upon the last, focusing on delivering a demonstrable piece of functionality and evolving the project directory structure towards the comprehensive enterprise-grade setup we discussed.

```
