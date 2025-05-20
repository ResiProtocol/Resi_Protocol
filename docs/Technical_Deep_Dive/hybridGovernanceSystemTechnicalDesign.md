# RESI Protocol: Hybrid Governance System Technical Specification

**Document ID:** RESI-TECH-GOV-2025-004  
**Version:** 1.0  
**Status:** Final Draft  
**Date:** 2025-05-19  
**Author:** Cass402

## Table of Contents

1. [Introduction](#1-introduction)
2. [Governance Architecture](#2-governance-architecture)
3. [Governance Token](#3-governance-token)
4. [Proposal Framework](#4-proposal-framework)
5. [Voting Mechanisms](#5-voting-mechanisms)
6. [Execution Framework](#6-execution-framework)
7. [Governance Security](#7-governance-security)
8. [Governance Analytics](#8-governance-analytics)
9. [Off-Chain Governance](#9-off-chain-governance)
10. [Governance Upgrades](#10-governance-upgrades)
11. [Integration Points](#11-integration-points)
12. [Testing & Deployment Strategy](#12-testing--deployment-strategy)
13. [References](#13-references)

## 1. Introduction

### 1.1 Purpose

The Hybrid Governance System provides a comprehensive framework for protocol governance, enabling decentralized decision-making while maintaining operational efficiency and security. This document provides a detailed technical specification for the implementation, interfaces, and processes of the governance system.

### 1.2 Scope

This specification covers:

- On-chain and off-chain governance components
- Governance token and delegation mechanisms
- Proposal creation, voting, and execution processes
- Tiered governance structure and access controls
- Timelock and emergency mechanisms
- Integration with other protocol components
- Security and dispute resolution mechanisms

### 1.3 System Objectives

The Hybrid Governance System is designed to:

1. **Decentralization**: Provide transparent and inclusive governance for all stakeholders
2. **Security**: Ensure secure and tamper-resistant governance processes
3. **Efficiency**: Enable timely decision-making across multiple governance tiers
4. **Flexibility**: Support multiple governance mechanisms for different decision types
5. **Scalability**: Scale governance processes as the protocol and community grow
6. **Accountability**: Maintain clear governance records and transparent actions

### 1.4 Governance Principles

The RESI Protocol governance system is guided by the following core principles:

1. **Progressive Decentralization**: Gradual transition to more decentralized governance
2. **Skin in the Game**: Voting power proportional to protocol stake
3. **Checks and Balances**: Multiple approval layers for critical changes
4. **Specialized Authority**: Domain-specific governance for specialized parameters
5. **Transparency**: Open and auditable governance processes
6. **Community First**: Prioritizing long-term protocol health over short-term interests

## 2. Governance Architecture

### 2.1 High-Level Architecture

The RESI Protocol Hybrid Governance System combines on-chain voting with off-chain processes in a multi-tiered structure:

```
┌────────────────────────────────────────────────────────────────────────────┐
│                                                                            │
│                         RESI Protocol Governance                           │
│                                                                            │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│                            Governance Layers                               │
│                                                                            │
├────────────┬─────────────────────┬───────────────────────┬────────────────┤
│            │                     │                       │                │
│ Protocol   │  Parameter          │  Emergency            │  Social        │
│ Governance │  Governance         │  Governance           │  Governance    │
│            │                     │                       │                │
└─────┬──────┴──────────┬──────────┴─────────────┬─────────┴────────┬───────┘
      │                 │                        │                  │
      ▼                 ▼                        ▼                  ▼
┌──────────────┐ ┌─────────────────┐  ┌────────────────────┐ ┌─────────────┐
│              │ │                 │  │                    │ │             │
│ Governance   │ │ Parameter       │  │ Emergency          │ │ Forum &     │
│ Token        │ │ Control         │  │ Council            │ │ Signaling   │
│ Voting       │ │ Voting          │  │                    │ │             │
│              │ │                 │  │                    │ │             │
└──────┬───────┘ └─────────┬───────┘  └──────────┬─────────┘ └──────┬──────┘
       │                   │                     │                   │
       ▼                   ▼                     ▼                   ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│                   Governance Execution Framework                         │
│                                                                          │
├──────────────┬───────────────────┬────────────────────┬─────────────────┤
│              │                   │                    │                 │
│ Protocol     │ Timelocked        │ Parameter          │ Emergency       │
│ Upgrades     │ Execution         │ Updates            │ Actions         │
│              │                   │                    │                 │
└──────────────┴───────────────────┴────────────────────┴─────────────────┘
                                    │
                                    ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│                       Protocol Components                                │
│                                                                          │
├──────────────┬───────────────────┬────────────────────┬─────────────────┤
│              │                   │                    │                 │
│ Core         │ Collateral        │ Oracle             │ Treasury &      │
│ Protocol     │ Management        │ System             │ Incentives      │
│              │                   │                    │                 │
└──────────────┴───────────────────┴────────────────────┴─────────────────┘
```

### 2.2 Governance Layers

The governance system is structured into distinct layers, each with specific purposes and authorities:

#### 2.2.1 Protocol Governance

Responsible for protocol-wide decisions including:

- Smart contract upgrades
- Addition of new protocol features
- Treasury allocations
- Governance system changes

#### 2.2.2 Parameter Governance

Responsible for protocol parameter adjustments including:

- Risk parameters for collateral assets
- Fee structures
- Stability mechanism parameters
- Oracle thresholds

#### 2.2.3 Emergency Governance

Responsible for rapid response to critical situations:

- Emergency pauses
- Circuit breaker activation
- Rapid response to security threats
- Emergency parameter adjustments

#### 2.2.4 Social Governance

Off-chain processes for community coordination:

- Proposal discussion and refinement
- Community signaling
- Governance improvement proposals
- Non-binding votes and sentiment analysis

### 2.3 Governance Entities

The key entities within the governance system include:

1. **Token Holders**: RESI governance token holders who can vote or delegate voting power
2. **Delegates**: Entities who receive delegated voting power from token holders
3. **Parameter Committees**: Specialized groups with domain expertise for parameter adjustments
4. **Emergency Council**: Multi-signature group with authority for emergency actions
5. **Protocol Guardian**: Temporary entity with authority to pause the protocol
6. **Governance Facilitators**: Community members who help coordinate governance processes

### 2.4 Governance State Machine

The governance process follows a state machine model:

```
                       ┌───────────────┐
                       │               │
                       │  Discussion   │
                       │               │
                       └───────┬───────┘
                               │
                               ▼
┌───────────────┐      ┌───────────────┐
│               │      │               │
│  Canceled     │◄─────┤   Proposed    │
│               │      │               │
└───────────────┘      └───────┬───────┘
                               │
                               ▼
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│               │      │               │      │               │
│   Defeated    │◄─────┤    Active     ├─────►│   Succeeded   │
│               │      │               │      │               │
└───────────────┘      └───────────────┘      └───────┬───────┘
                                                      │
                                                      ▼
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│               │      │               │      │               │
│    Expired    │◄─────┤    Queued     ├─────►│   Executed    │
│               │      │               │      │               │
└───────────────┘      └───────────────┘      └───────────────┘
```

## 3. Governance Token

### 3.1 Token Specifications

The RESI Governance Token (RESI) follows the ERC-20 standard with governance extensions:

```solidity
interface IRESIToken {
    /**
     * @notice ERC-20 standard functions
     */
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    /**
     * @notice Get current votes for an account
     * @param account Address to get votes for
     * @return votes Current vote balance
     */
    function getCurrentVotes(address account) external view returns (uint256 votes);

    /**
     * @notice Get votes for an account at a specific block
     * @param account Address to get votes for
     * @param blockNumber Block to get votes at
     * @return votes Vote balance at given block
     */
    function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256 votes);

    /**
     * @notice Delegate voting power to an address
     * @param delegatee Address to delegate votes to
     * @return success Whether delegation was successful
     */
    function delegate(address delegatee) external returns (bool success);

    /**
     * @notice Delegate voting power using signature
     * @param delegatee Address to delegate votes to
     * @param nonce Nonce for signature
     * @param expiry Expiration timestamp
     * @param v Signature component
     * @param r Signature component
     * @param s Signature component
     * @return success Whether delegation was successful
     */
    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (bool success);

    /**
     * @notice Get current delegatee for an account
     * @param account Address to get delegatee for
     * @return delegatee Current delegatee
     */
    function delegates(address account) external view returns (address delegatee);

    /**
     * @notice Check if account has voted on a proposal
     * @param proposalId Proposal identifier
     * @param account Account to check
     * @return hasVoted Whether account has voted
     */
    function hasVoted(uint256 proposalId, address account) external view returns (bool hasVoted);

    /**
     * @notice Get account voting history
     * @param account Account to check
     * @param startBlock Start block for history
     * @param endBlock End block for history
     * @return proposalIds Array of proposal IDs voted on
     * @return supports Array of vote support values
     */
    function getVotingHistory(
        address account,
        uint256 startBlock,
        uint256 endBlock
    ) external view returns (
        uint256[] memory proposalIds,
        uint8[] memory supports
    );
}
```

### 3.2 Delegation Mechanism

The delegation system allows token holders to delegate their voting power to addresses of their choice:

```solidity
struct Delegation {
    address delegator;
    address delegatee;
    uint256 amount;
    uint256 timestamp;
}

struct Checkpoint {
    uint32 fromBlock;
    uint224 votes;
}

// Delegation storage
mapping(address => address) private _delegates;
mapping(address => mapping(uint32 => Checkpoint)) private _checkpoints;
mapping(address => uint32) private _numCheckpoints;

// Delegation event
event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);

/**
 * @notice Delegate voting power to an address
 * @param delegatee Address to delegate votes to
 * @return success Whether delegation was successful
 */
function delegate(address delegatee) external returns (bool success) {
    return _delegate(msg.sender, delegatee);
}

/**
 * @notice Internal delegation implementation
 * @param delegator Address delegating votes
 * @param delegatee Address to delegate votes to
 * @return success Whether delegation was successful
 */
function _delegate(address delegator, address delegatee) internal returns (bool success) {
    address currentDelegate = _delegates[delegator];
    uint256 delegatorBalance = balanceOf(delegator);
    _delegates[delegator] = delegatee;

    emit DelegateChanged(delegator, currentDelegate, delegatee);

    _moveDelegates(currentDelegate, delegatee, delegatorBalance);

    return true;
}

/**
 * @notice Move delegates from one address to another
 * @param srcRep Source delegate
 * @param dstRep Destination delegate
 * @param amount Amount of votes to move
 */
function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
    if (srcRep != dstRep && amount > 0) {
        if (srcRep != address(0)) {
            uint32 srcRepNum = _numCheckpoints[srcRep];
            uint256 srcRepOld = srcRepNum > 0 ? _checkpoints[srcRep][srcRepNum - 1].votes : 0;
            uint256 srcRepNew = srcRepOld - amount;
            _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
        }

        if (dstRep != address(0)) {
            uint32 dstRepNum = _numCheckpoints[dstRep];
            uint256 dstRepOld = dstRepNum > 0 ? _checkpoints[dstRep][dstRepNum - 1].votes : 0;
            uint256 dstRepNew = dstRepOld + amount;
            _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
        }
    }
}

/**
 * @notice Write a checkpoint
 * @param delegatee Delegatee address
 * @param nCheckpoints Number of existing checkpoints
 * @param oldVotes Old vote balance
 * @param newVotes New vote balance
 */
function _writeCheckpoint(
    address delegatee,
    uint32 nCheckpoints,
    uint256 oldVotes,
    uint256 newVotes
) internal {
    uint32 blockNumber = safe32(block.number, "Block number exceeds 32 bits");

    if (nCheckpoints > 0 && _checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
        _checkpoints[delegatee][nCheckpoints - 1].votes = safe224(newVotes, "Vote amount exceeds 224 bits");
    } else {
        _checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, safe224(newVotes, "Vote amount exceeds 224 bits"));
        _numCheckpoints[delegatee] = nCheckpoints + 1;
    }

    emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
}
```

### 3.3 Vote Weight Calculation

```solidity
/**
 * @notice Get votes for an account at a specific block
 * @param account Address to get votes for
 * @param blockNumber Block to get votes at
 * @return votes Vote balance at given block
 */
function getPriorVotes(address account, uint256 blockNumber) public view returns (uint256 votes) {
    require(blockNumber < block.number, "RESI::getPriorVotes: not yet determined");

    uint32 nCheckpoints = _numCheckpoints[account];
    if (nCheckpoints == 0) {
        return 0;
    }

    // First check most recent balance
    if (_checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
        return _checkpoints[account][nCheckpoints - 1].votes;
    }

    // Next check implicit zero balance
    if (_checkpoints[account][0].fromBlock > blockNumber) {
        return 0;
    }

    uint32 lower = 0;
    uint32 upper = nCheckpoints - 1;
    while (upper > lower) {
        uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
        Checkpoint memory cp = _checkpoints[account][center];
        if (cp.fromBlock == blockNumber) {
            return cp.votes;
        } else if (cp.fromBlock < blockNumber) {
            lower = center;
        } else {
            upper = center - 1;
        }
    }
    return _checkpoints[account][lower].votes;
}
```

### 3.4 Voting Power Boosting Mechanism

The protocol implements vote locking for longer-term governance participants:

```solidity
interface IVotingEscrow {
    /**
     * @notice Lock RESI tokens for voting power
     * @param amount Amount of RESI to lock
     * @param unlockTime Time when tokens unlock
     * @return lockId Identifier for the lock
     */
    function lockTokens(uint256 amount, uint256 unlockTime) external returns (uint256 lockId);

    /**
     * @notice Increase amount of locked tokens
     * @param lockId Lock identifier
     * @param amount Additional amount to lock
     * @return success Whether increase was successful
     */
    function increaseLockAmount(uint256 lockId, uint256 amount) external returns (bool success);

    /**
     * @notice Extend lock duration
     * @param lockId Lock identifier
     * @param unlockTime New unlock time
     * @return success Whether extension was successful
     */
    function extendLockTime(uint256 lockId, uint256 unlockTime) external returns (bool success);

    /**
     * @notice Withdraw locked tokens after unlock time
     * @param lockId Lock identifier
     * @return success Whether withdrawal was successful
     */
    function withdraw(uint256 lockId) external returns (bool success);

    /**
     * @notice Get user's voting power
     * @param user User address
     * @return votingPower Current voting power
     */
    function getVotingPower(address user) external view returns (uint256 votingPower);

    /**
     * @notice Get lock details
     * @param lockId Lock identifier
     * @return lock Lock details
     */
    function getLock(uint256 lockId) external view returns (
        address owner,
        uint256 amount,
        uint256 unlockTime,
        uint256 votingPower
    );

    /**
     * @notice Get all locks for a user
     * @param user User address
     * @return lockIds Array of lock IDs
     */
    function getUserLocks(address user) external view returns (uint256[] memory lockIds);
}
```

#### 3.4.1 Voting Power Calculation Formula

The voting power increases with lock duration:

```solidity
/**
 * @notice Calculate voting power for locked tokens
 * @param amount Token amount
 * @param lockDuration Lock duration in seconds
 * @param maxDuration Maximum possible lock duration
 * @return votingPower Calculated voting power
 */
function calculateVotingPower(
    uint256 amount,
    uint256 lockDuration,
    uint256 maxDuration
) internal pure returns (uint256 votingPower) {
    // Base weight is 1.0
    uint256 baseWeight = 1e18;

    // Maximum boost is 2.5x for maximum lock duration
    uint256 maxBoost = 25e17;

    // Calculate boost based on lock duration
    uint256 boost = baseWeight + (lockDuration * (maxBoost - baseWeight)) / maxDuration;

    // Apply boost to amount
    votingPower = (amount * boost) / 1e18;

    return votingPower;
}
```

## 4. Proposal Framework

### 4.1 Proposal Types

The governance system supports several types of proposals:

1. **Core Protocol Proposals**: Changes to core protocol smart contracts
2. **Parameter Adjustment Proposals**: Changes to protocol parameters
3. **Treasury Proposals**: Allocations from the protocol treasury
4. **Meta-Governance Proposals**: Changes to the governance system itself
5. **Emergency Proposals**: Rapid response to critical issues

### 4.2 Proposal Structure

```solidity
struct Proposal {
    // Proposal metadata
    uint256 id;
    address proposer;
    string title;
    string description;
    uint8 proposalType;

    // On-chain execution data
    address[] targets;
    uint256[] values;
    bytes[] calldatas;
    string[] signatures;

    // Voting data
    uint256 startBlock;
    uint256 endBlock;
    uint256 forVotes;
    uint256 againstVotes;
    uint256 abstainVotes;

    // State tracking
    bool canceled;
    bool executed;
    mapping(address => Receipt) receipts;

    // Execution data
    uint256 eta;
    uint256 delay;
}

struct Receipt {
    bool hasVoted;
    uint8 support;
    uint256 votes;
}

enum ProposalState {
    Pending,
    Active,
    Canceled,
    Defeated,
    Succeeded,
    Queued,
    Expired,
    Executed
}
```

### 4.3 Proposal Interface

```solidity
interface IGovernorAlpha {
    /**
     * @notice Create a new proposal
     * @param targets Target addresses for proposal calls
     * @param values ETH values for proposal calls
     * @param signatures Function signatures for proposal calls
     * @param calldatas Calldata for proposal calls
     * @param title Proposal title
     * @param description Proposal description
     * @param proposalType Proposal type
     * @return proposalId Proposal identifier
     */
    function propose(
        address[] calldata targets,
        uint256[] calldata values,
        string[] calldata signatures,
        bytes[] calldata calldatas,
        string calldata title,
        string calldata description,
        uint8 proposalType
    ) external returns (uint256 proposalId);

    /**
     * @notice Get proposal details
     * @param proposalId Proposal identifier
     * @return proposal Proposal details
     */
    function getProposal(uint256 proposalId) external view returns (
        address proposer,
        string memory title,
        string memory description,
        uint8 proposalType,
        uint256 startBlock,
        uint256 endBlock,
        uint256 forVotes,
        uint256 againstVotes,
        uint256 abstainVotes,
        bool canceled,
        bool executed,
        uint256 eta
    );

    /**
     * @notice Get proposal state
     * @param proposalId Proposal identifier
     * @return state Current proposal state
     */
    function state(uint256 proposalId) external view returns (ProposalState state);

    /**
     * @notice Get proposal targets, values, and calldatas
     * @param proposalId Proposal identifier
     * @return targets Target addresses
     * @return values ETH values
     * @return signatures Function signatures
     * @return calldatas Call data
     */
    function getActions(uint256 proposalId) external view returns (
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas
    );

    /**
     * @notice Cancel a proposal
     * @param proposalId Proposal identifier
     * @return success Whether cancel was successful
     */
    function cancel(uint256 proposalId) external returns (bool success);

    /**
     * @notice Queue a proposal for execution
     * @param proposalId Proposal identifier
     * @return success Whether queue was successful
     */
    function queue(uint256 proposalId) external returns (bool success);

    /**
     * @notice Execute a queued proposal
     * @param proposalId Proposal identifier
     * @return success Whether execution was successful
     */
    function execute(uint256 proposalId) external returns (bool success);
}
```

### 4.4 Proposal Creation Requirements

Requirements for proposal creation vary by proposal type:

```solidity
function getProposalThreshold(uint8 proposalType) public view returns (uint256) {
    if (proposalType == uint8(ProposalType.Core)) {
        // Core protocol proposals require 1% of total supply
        return (totalSupply() * 1e16) / 1e18;
    } else if (proposalType == uint8(ProposalType.Parameter)) {
        // Parameter proposals require 0.5% of total supply
        return (totalSupply() * 5e15) / 1e18;
    } else if (proposalType == uint8(ProposalType.Treasury)) {
        // Treasury proposals require 0.25% of total supply
        return (totalSupply() * 25e14) / 1e18;
    } else if (proposalType == uint8(ProposalType.MetaGovernance)) {
        // Meta-governance proposals require 2% of total supply
        return (totalSupply() * 2e16) / 1e18;
    } else if (proposalType == uint8(ProposalType.Emergency)) {
        // Emergency proposals require emergency council approval
        return 0;
    }

    // Default to 1% of total supply
    return (totalSupply() * 1e16) / 1e18;
}
```

## 5. Voting Mechanisms

### 5.1 On-Chain Voting

```solidity
interface IVoting {
    /**
     * @notice Cast a vote on a proposal
     * @param proposalId Proposal identifier
     * @param support Support value (0=against, 1=for, 2=abstain)
     * @return success Whether vote was successful
     */
    function castVote(uint256 proposalId, uint8 support) external returns (bool success);

    /**
     * @notice Cast a vote with reason
     * @param proposalId Proposal identifier
     * @param support Support value
     * @param reason Vote reason
     * @return success Whether vote was successful
     */
    function castVoteWithReason(
        uint256 proposalId,
        uint8 support,
        string calldata reason
    ) external returns (bool success);

    /**
     * @notice Cast a vote by signature
     * @param proposalId Proposal identifier
     * @param support Support value
     * @param v Signature v
     * @param r Signature r
     * @param s Signature s
     * @return success Whether vote was successful
     */
    function castVoteBySig(
        uint256 proposalId,
        uint8 support,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (bool success);

    /**
     * @notice Get receipt for a vote
     * @param proposalId Proposal identifier
     * @param voter Voter address
     * @return hasVoted Whether voter has voted
     * @return support Support value
     * @return votes Number of votes cast
     */
    function getReceipt(
        uint256 proposalId,
        address voter
    ) external view returns (
        bool hasVoted,
        uint8 support,
        uint256 votes
    );
}
```

### 5.2 Vote Counting and Quorum

```solidity
/**
 * @notice Calculate quorum for a proposal
 * @param proposalType Proposal type
 * @return quorumVotes Number of votes required for quorum
 */
function quorumVotes(uint8 proposalType) public view returns (uint256 quorumVotes) {
    if (proposalType == uint8(ProposalType.Core)) {
        // Core protocol proposals require 10% quorum
        return (totalSupply() * 1e17) / 1e18;
    } else if (proposalType == uint8(ProposalType.Parameter)) {
        // Parameter proposals require 5% quorum
        return (totalSupply() * 5e16) / 1e18;
    } else if (proposalType == uint8(ProposalType.Treasury)) {
        // Treasury proposals require 4% quorum
        return (totalSupply() * 4e16) / 1e18;
    } else if (proposalType == uint8(ProposalType.MetaGovernance)) {
        // Meta-governance proposals require 15% quorum
        return (totalSupply() * 15e16) / 1e18;
    } else if (proposalType == uint8(ProposalType.Emergency)) {
        // Emergency proposals require 2/3 of emergency council
        return 0; // Special handling for emergency council
    }

    // Default to 10% of total supply
    return (totalSupply() * 1e17) / 1e18;
}

/**
 * @notice Check if a proposal has reached quorum
 * @param proposalId Proposal identifier
 * @return hasReachedQuorum Whether proposal has reached quorum
 */
function hasReachedQuorum(uint256 proposalId) public view returns (bool hasReachedQuorum) {
    Proposal storage proposal = proposals[proposalId];

    // Total votes cast
    uint256 totalVotes = proposal.forVotes + proposal.againstVotes + proposal.abstainVotes;

    // Get quorum requirement
    uint256 requiredQuorum = quorumVotes(proposal.proposalType);

    return totalVotes >= requiredQuorum;
}

/**
 * @notice Check if a proposal has succeeded
 * @param proposalId Proposal identifier
 * @return hasSucceeded Whether proposal has succeeded
 */
function hasSucceeded(uint256 proposalId) public view returns (bool hasSucceeded) {
    Proposal storage proposal = proposals[proposalId];

    // Check quorum first
    if (!hasReachedQuorum(proposalId)) {
        return false;
    }

    // Different success criteria by proposal type
    if (proposal.proposalType == uint8(ProposalType.MetaGovernance)) {
        // Meta-governance requires 66% support
        return (proposal.forVotes * 100) >= (proposal.forVotes + proposal.againstVotes) * 66;
    } else if (proposal.proposalType == uint8(ProposalType.Emergency)) {
        // Emergency proposals require 75% support
        return (proposal.forVotes * 100) >= (proposal.forVotes + proposal.againstVotes) * 75;
    } else {
        // Standard proposals require >50% support
        return proposal.forVotes > proposal.againstVotes;
    }
}
```

### 5.3 Specialized Voting

#### 5.3.1 Quadratic Voting

```solidity
/**
 * @notice Calculate quadratic voting power
 * @param votes Regular voting power
 * @return qvPower Quadratic voting power
 */
function calculateQuadraticVotingPower(uint256 votes) internal pure returns (uint256 qvPower) {
    // Square root of votes, maintaining 9 decimals of precision
    return sqrt(votes * 1e18) * 1e9;
}

/**
 * @notice Calculate square root with precision
 * @param x Input value with 18 decimals
 * @return y Square root with 9 decimals
 */
function sqrt(uint256 x) internal pure returns (uint256 y) {
    uint256 z = (x + 1) / 2;
    y = x;
    while (z < y) {
        y = z;
        z = (x / z + z) / 2;
    }
}
```

#### 5.3.2 Conviction Voting

```solidity
struct ConvictionProposal {
    uint256 id;
    address proposer;
    string title;
    string description;
    address target;
    uint256 requestedAmount;
    uint256 conviction;
    uint256 createdBlock;
    bool executed;
    bool canceled;
    mapping(address => uint256) stakes;
}

/**
 * @notice Update conviction for a proposal
 * @param proposalId Proposal identifier
 * @return newConviction Updated conviction value
 */
function updateConviction(uint256 proposalId) public returns (uint256 newConviction) {
    ConvictionProposal storage proposal = convictionProposals[proposalId];

    // Skip if already executed or canceled
    if (proposal.executed || proposal.canceled) {
        return proposal.conviction;
    }

    // Calculate blocks since last update
    uint256 blocksSinceUpdate = block.number - lastUpdateBlock[proposalId];

    // Calculate decay factor (alpha between 0 and 1)
    uint256 alpha = 9e17; // 0.9 with 18 decimals

    // Calculate decayed conviction: conviction * alpha^(blocks)
    uint256 decayedConviction = proposal.conviction;
    for (uint256 i = 0; i < blocksSinceUpdate; i++) {
        decayedConviction = (decayedConviction * alpha) / 1e18;
    }

    // Add current support
    uint256 totalStaked = getTotalStaked(proposalId);
    newConviction = decayedConviction + totalStaked;

    // Update proposal
    proposal.conviction = newConviction;
    lastUpdateBlock[proposalId] = block.number;

    return newConviction;
}

/**
 * @notice Stake tokens on a conviction proposal
 * @param proposalId Proposal identifier
 * @param amount Amount to stake
 * @return success Whether stake was successful
 */
function stakeOnProposal(uint256 proposalId, uint256 amount) external returns (bool success) {
    ConvictionProposal storage proposal = convictionProposals[proposalId];

    // Skip if already executed or canceled
    require(!proposal.executed && !proposal.canceled, "Proposal is no longer active");

    // Update conviction before changing stake
    updateConviction(proposalId);

    // Update user's stake
    proposal.stakes[msg.sender] += amount;

    // Transfer tokens to contract
    require(
        IERC20(governanceToken).transferFrom(msg.sender, address(this), amount),
        "Token transfer failed"
    );

    return true;
}
```

## 6. Execution Framework

### 6.1 Timelock Controller

```solidity
interface ITimelock {
    /**
     * @notice Queue a transaction
     * @param target Target address
     * @param value ETH value
     * @param signature Function signature
     * @param data Call data
     * @param eta Execution time
     * @return txHash Transaction hash
     */
    function queueTransaction(
        address target,
        uint256 value,
        string calldata signature,
        bytes calldata data,
        uint256 eta
    ) external returns (bytes32 txHash);

    /**
     * @notice Cancel a transaction
     * @param target Target address
     * @param value ETH value
     * @param signature Function signature
     * @param data Call data
     * @param eta Execution time
     * @return success Whether cancel was successful
     */
    function cancelTransaction(
        address target,
        uint256 value,
        string calldata signature,
        bytes calldata data,
        uint256 eta
    ) external returns (bool success);

    /**
     * @notice Execute a transaction
     * @param target Target address
     * @param value ETH value
     * @param signature Function signature
     * @param data Call data
     * @param eta Execution time
     * @return success Whether execution was successful
     */
    function executeTransaction(
        address target,
        uint256 value,
        string calldata signature,
        bytes calldata data,
        uint256 eta
    ) external returns (bool success);

    /**
     * @notice Get delay before execution
     * @return delay Delay in seconds
     */
    function getDelay() external view returns (uint256 delay);

    /**
     * @notice Check if a transaction is queued
     * @param txHash Transaction hash
     * @return isQueued Whether transaction is queued
     */
    function isTransactionQueued(bytes32 txHash) external view returns (bool isQueued);

    /**
     * @notice Check if a transaction is ready for execution
     * @param txHash Transaction hash
     * @return isReady Whether transaction is ready
     */
    function isTransactionReady(bytes32 txHash) external view returns (bool isReady);
}
```

### 6.2 Parameter Control

```solidity
interface IParameterControl {
    /**
     * @notice Set a parameter value
     * @param module Module identifier
     * @param parameter Parameter identifier
     * @param value Parameter value
     * @return success Whether set was successful
     */
    function setParameter(
        bytes32 module,
        bytes32 parameter,
        bytes calldata value
    ) external returns (bool success);

    /**
     * @notice Get a parameter value
     * @param module Module identifier
     * @param parameter Parameter identifier
     * @return value Parameter value
     */
    function getParameter(
        bytes32 module,
        bytes32 parameter
    ) external view returns (bytes memory value);

    /**
     * @notice Get parameter metadata
     * @param module Module identifier
     * @param parameter Parameter identifier
     * @return name Parameter name
     * @return description Parameter description
     * @return paramType Parameter type
     * @return minValue Minimum value
     * @return maxValue Maximum value
     */
    function getParameterMetadata(
        bytes32 module,
        bytes32 parameter
    ) external view returns (
        string memory name,
        string memory description,
        uint8 paramType,
        bytes memory minValue,
        bytes memory maxValue
    );

    /**
     * @notice Check if address can modify a parameter
     * @param module Module identifier
     * @param parameter Parameter identifier
     * @param account Address to check
     * @return canModify Whether account can modify parameter
     */
    function canModifyParameter(
        bytes32 module,
        bytes32 parameter,
        address account
    ) external view returns (bool canModify);
}
```

### 6.3 Emergency Actions

```solidity
interface IEmergencyAction {
    /**
     * @notice Pause the protocol
     * @param reason Pause reason
     * @return success Whether pause was successful
     */
    function pauseProtocol(string calldata reason) external returns (bool success);

    /**
     * @notice Unpause the protocol
     * @return success Whether unpause was successful
     */
    function unpauseProtocol() external returns (bool success);

    /**
     * @notice Trigger circuit breaker
     * @param circuitId Circuit breaker identifier
     * @param reason Trigger reason
     * @return success Whether trigger was successful
     */
    function triggerCircuitBreaker(
        bytes32 circuitId,
        string calldata reason
    ) external returns (bool success);

    /**
     * @notice Reset circuit breaker
     * @param circuitId Circuit breaker identifier
     * @return success Whether reset was successful
     */
    function resetCircuitBreaker(bytes32 circuitId) external returns (bool success);

    /**
     * @notice Execute emergency parameter update
     * @param module Module identifier
     * @param parameter Parameter identifier
     * @param value Parameter value
     * @param reason Emergency update reason
     * @return success Whether update was successful
     */
    function emergencyParameterUpdate(
        bytes32 module,
        bytes32 parameter,
        bytes calldata value,
        string calldata reason
    ) external returns (bool success);
}
```

## 7. Governance Security

### 7.1 Access Control

```solidity
interface IGovernanceAccess {
    /**
     * @notice Check if account has a governance role
     * @param role Role identifier
     * @param account Account to check
     * @return hasRole Whether account has role
     */
    function hasGovernanceRole(
        bytes32 role,
        address account
    ) external view returns (bool hasRole);

    /**
     * @notice Grant a governance role
     * @param role Role identifier
     * @param account Account to grant role to
     * @return success Whether grant was successful
     */
    function grantGovernanceRole(
        bytes32 role,
        address account
    ) external returns (bool success);

    /**
     * @notice Revoke a governance role
     * @param role Role identifier
     * @param account Account to revoke role from
     * @return success Whether revoke was successful
     */
    function revokeGovernanceRole(
        bytes32 role,
        address account
    ) external returns (bool success);

    /**
     * @notice Get all accounts with a role
     * @param role Role identifier
     * @return accounts Array of accounts with role
     */
    function getRoleMembers(
        bytes32 role
    ) external view returns (address[] memory accounts);

    /**
     * @notice Get all roles for an account
     * @param account Account to check
     * @return roles Array of role identifiers
     */
    function getAccountRoles(
        address account
    ) external view returns (bytes32[] memory roles);
}
```

### 7.2 Multi-Signature Requirements

```solidity
interface IMultiSignature {
    /**
     * @notice Submit a multi-signature transaction
     * @param to Target address
     * @param value ETH value
     * @param data Call data
     * @param description Transaction description
     * @return txId Transaction identifier
     */
    function submitTransaction(
        address to,
        uint256 value,
        bytes calldata data,
        string calldata description
    ) external returns (uint256 txId);

    /**
     * @notice Confirm a transaction
     * @param txId Transaction identifier
     * @return confirmations Number of confirmations
     */
    function confirmTransaction(uint256 txId) external returns (uint256 confirmations);

    /**
     * @notice Revoke a confirmation
     * @param txId Transaction identifier
     * @return success Whether revocation was successful
     */
    function revokeConfirmation(uint256 txId) external returns (bool success);

    /**
     * @notice Execute a confirmed transaction
     * @param txId Transaction identifier
     * @return success Whether execution was successful
     */
    function executeTransaction(uint256 txId) external returns (bool success);

    /**
     * @notice Get transaction details
     * @param txId Transaction identifier
     * @return tx Transaction details
     */
    function getTransaction(
        uint256 txId
    ) external view returns (
        address to,
        uint256 value,
        bytes memory data,
        string memory description,
        bool executed,
        uint256 confirmations
    );

    /**
     * @notice Check if account has confirmed a transaction
     * @param txId Transaction identifier
     * @param account Account to check
     * @return confirmed Whether account has confirmed
     */
    function isConfirmed(
        uint256 txId,
        address account
    ) external view returns (bool confirmed);
}
```

### 7.3 Governance Guards

```solidity
interface IGovernanceGuard {
    /**
     * @notice Validate a proposal
     * @param proposalId Proposal identifier
     * @return isValid Whether proposal is valid
     * @return reason Invalidation reason if not valid
     */
    function validateProposal(
        uint256 proposalId
    ) external view returns (bool isValid, string memory reason);

    /**
     * @notice Validate a transaction
     * @param target Target address
     * @param value ETH value
     * @param data Call data
     * @return isValid Whether transaction is valid
     * @return reason Invalidation reason if not valid
     */
    function validateTransaction(
        address target,
        uint256 value,
        bytes calldata data
    ) external view returns (bool isValid, string memory reason);

    /**
     * @notice Get protected functions
     * @return targets Array of protected target addresses
     * @return selectors Array of protected function selectors
     */
    function getProtectedFunctions() external view returns (
        address[] memory targets,
        bytes4[] memory selectors
    );

    /**
     * @notice Check if a function is protected
     * @param target Target address
     * @param selector Function selector
     * @return isProtected Whether function is protected
     */
    function isProtectedFunction(
        address target,
        bytes4 selector
    ) external view returns (bool isProtected);
}
```

## 8. Governance Analytics

### 8.1 Voting Analytics

```solidity
interface IVotingAnalytics {
    /**
     * @notice Get voting stats for a proposal
     * @param proposalId Proposal identifier
     * @return totalVotes Total votes cast
     * @return voterCount Number of unique voters
     * @return participation Participation rate (18 decimals)
     * @return forPercentage Percentage of votes for (18 decimals)
     * @return againstPercentage Percentage of votes against (18 decimals)
     * @return abstainPercentage Percentage of abstain votes (18 decimals)
     */
    function getProposalVotingStats(
        uint256 proposalId
    ) external view returns (
        uint256 totalVotes,
        uint256 voterCount,
        uint256 participation,
        uint256 forPercentage,
        uint256 againstPercentage,
        uint256 abstainPercentage
    );

    /**
     * @notice Get top voters for a proposal
     * @param proposalId Proposal identifier
     * @param count Maximum number of voters to return
     * @return voters Array of voter addresses
     * @return votes Array of vote amounts
     * @return supports Array of vote support values
     */
    function getTopVoters(
        uint256 proposalId,
        uint256 count
    ) external view returns (
        address[] memory voters,
        uint256[] memory votes,
        uint8[] memory supports
    );

    /**
     * @notice Get voter participation history
     * @param voter Voter address
     * @param count Maximum proposals to return
     * @return proposalIds Array of proposal IDs
     * @return supports Array of vote support values
     * @return powers Array of voting powers
     */
    function getVoterHistory(
        address voter,
        uint256 count
    ) external view returns (
        uint256[] memory proposalIds,
        uint8[] memory supports,
        uint256[] memory powers
    );

    /**
     * @notice Get voter participation rate
     * @param voter Voter address
     * @param startBlock Start block for analysis
     * @param endBlock End block for analysis
     * @return participationRate Participation rate (18 decimals)
     */
    function getVoterParticipationRate(
        address voter,
        uint256 startBlock,
        uint256 endBlock
    ) external view returns (uint256 participationRate);
}
```

### 8.2 Proposal Analytics

```solidity
interface IProposalAnalytics {
    /**
     * @notice Get proposal success rate
     * @param proposerAddress Proposer address (zero for all)
     * @param proposalType Proposal type (0 for all)
     * @param startTime Start time for analysis
     * @param endTime End time for analysis
     * @return proposed Number of proposals created
     * @return succeeded Number of proposals succeeded
     * @return executed Number of proposals executed
     * @return successRate Success rate (18 decimals)
     */
    function getProposalSuccessRate(
        address proposerAddress,
        uint8 proposalType,
        uint256 startTime,
        uint256 endTime
    ) external view returns (
        uint256 proposed,
        uint256 succeeded,
        uint256 executed,
        uint256 successRate
    );

    /**
     * @notice Get proposal timing statistics
     * @param proposalType Proposal type (0 for all)
     * @param startTime Start time for analysis
     * @param endTime End time for analysis
     * @return avgVotingPeriod Average voting period in blocks
     * @return avgTimelockPeriod Average timelock period in seconds
     * @return avgExecutionDelay Average delay from creation to execution
     */
    function getProposalTimingStats(
        uint8 proposalType,
        uint256 startTime,
        uint256 endTime
    ) external view returns (
        uint256 avgVotingPeriod,
        uint256 avgTimelockPeriod,
        uint256 avgExecutionDelay
    );

    /**
     * @notice Get top proposers
     * @param count Maximum number to return
     * @param startTime Start time for analysis
     * @param endTime End time for analysis
     * @return proposers Array of proposer addresses
     * @return proposalCounts Array of proposal counts
     * @return successCounts Array of successful proposal counts
     */
    function getTopProposers(
        uint256 count,
        uint256 startTime,
        uint256 endTime
    ) external view returns (
        address[] memory proposers,
        uint256[] memory proposalCounts,
        uint256[] memory successCounts
    );
}
```

### 8.3 Governance Health Metrics

```solidity
interface IGovernanceHealth {
    /**
     * @notice Get governance health metrics
     * @return metrics Governance health metrics
     */
    function getGovernanceHealthMetrics() external view returns (
        GovernanceHealthMetrics memory metrics
    );

    /**
     * @notice Get governance participation trending
     * @param periodCount Number of periods to return
     * @param periodLength Length of each period in seconds
     * @return timestamps Array of period end timestamps
     * @return participationRates Array of participation rates
     * @return proposalCounts Array of proposal counts
     */
    function getParticipationTrending(
        uint256 periodCount,
        uint256 periodLength
    ) external view returns (
        uint256[] memory timestamps,
        uint256[] memory participationRates,
        uint256[] memory proposalCounts
    );

    /**
     * @notice Check token concentration risk
     * @param thresholdPercentage Concentration threshold (18 decimals)
     * @return concentration Concentration risk metrics
     */
    function getTokenConcentrationRisk(
        uint256 thresholdPercentage
    ) external view returns (
        TokenConcentration memory concentration
    );

    // Governance health metrics structure
    struct GovernanceHealthMetrics {
        uint256 totalProposalCount;
        uint256 activeProposalCount;
        uint256 averageParticipation;
        uint256 voterCount;
        uint256 delegateCount;
        uint256 proposerCount;
        uint256 tokenCirculatingSupply;
        uint256 tokenTotalSupply;
        uint256 lockedTokenPercentage;
        uint256 lastProposalTimestamp;
    }

    // Token concentration structure
    struct TokenConcentration {
        uint256 topHolderCount;
        uint256 topHolderPercentage;
        uint256 giniCoefficient;
        bool isHighlyConcentrated;
        address[] topHolders;
        uint256[] topHolderBalances;
    }
}
```

## 9. Off-Chain Governance

### 9.1 Off-Chain Proposal Interface

```solidity
interface IOffChainProposal {
    /**
     * @notice Submit an off-chain proposal
     * @param title Proposal title
     * @param description Proposal description
     * @param proposalType Proposal type
     * @param discussionUrl Discussion URL
     * @param ipfsHash IPFS hash of proposal document
     * @return proposalId Off-chain proposal identifier
     */
    function submitOffChainProposal(
        string calldata title,
        string calldata description,
        uint8 proposalType,
        string calldata discussionUrl,
        string calldata ipfsHash
    ) external returns (bytes32 proposalId);

    /**
     * @notice Submit a temperature check
     * @param title Temperature check title
     * @param description Temperature check description
     * @param options Voting options
     * @param discussionUrl Discussion URL
     * @param duration Duration in seconds
     * @return checkId Temperature check identifier
     */
    function submitTemperatureCheck(
        string calldata title,
        string calldata description,
        string[] calldata options,
        string calldata discussionUrl,
        uint256 duration
    ) external returns (bytes32 checkId);

    /**
     * @notice Cast off-chain vote
     * @param proposalId Off-chain proposal identifier
     * @param support Support value
     * @param signature Vote signature
     * @return success Whether vote was successful
     */
    function castOffChainVote(
        bytes32 proposalId,
        uint8 support,
        bytes calldata signature
    ) external returns (bool success);

    /**
     * @notice Get off-chain proposal details
     * @param proposalId Off-chain proposal identifier
     * @return proposal Off-chain proposal details
     */
    function getOffChainProposal(
        bytes32 proposalId
    ) external view returns (
        string memory title,
        string memory description,
        uint8 proposalType,
        address proposer,
        string memory discussionUrl,
        string memory ipfsHash,
        uint256 timestamp,
        bool finalized
    );
}
```

### 9.2 Social Signal Integration

```solidity
interface ISocialSignal {
    /**
     * @notice Submit a social signal
     * @param proposalId On-chain proposal identifier
     * @param platform Social platform identifier
     * @param support Support value
     * @param signalStrength Signal strength (0-100)
     * @param evidence Evidence URL
     * @return signalId Signal identifier
     */
    function submitSocialSignal(
        uint256 proposalId,
        bytes32 platform,
        uint8 support,
        uint8 signalStrength,
        string calldata evidence
    ) external returns (bytes32 signalId);

    /**
     * @notice Get social signals for a proposal
     * @param proposalId On-chain proposal identifier
     * @return platforms Array of platform identifiers
     * @return supports Array of support values
     * @return strengths Array of signal strengths
     * @return evidences Array of evidence URLs
     */
    function getSocialSignals(
        uint256 proposalId
    ) external view returns (
        bytes32[] memory platforms,
        uint8[] memory supports,
        uint8[] memory strengths,
        string[] memory evidences
    );

    /**
     * @notice Get aggregated social sentiment
     * @param proposalId On-chain proposal identifier
     * @return sentiment Aggregated sentiment (-100 to 100)
     * @return confidence Confidence in sentiment (0-100)
     * @return signalCount Number of signals
     */
    function getAggregatedSentiment(
        uint256 proposalId
    ) external view returns (
        int8 sentiment,
        uint8 confidence,
        uint256 signalCount
    );
}
```

### 9.3 Governance Forum Integration

```solidity
interface IGovernanceForum {
    /**
     * @notice Link forum thread to on-chain proposal
     * @param proposalId On-chain proposal identifier
     * @param threadUrl Forum thread URL
     * @param threadId Forum thread identifier
     * @return success Whether link was successful
     */
    function linkForumThread(
        uint256 proposalId,
        string calldata threadUrl,
        string calldata threadId
    ) external returns (bool success);

    /**
     * @notice Get linked forum thread
     * @param proposalId On-chain proposal identifier
     * @return threadUrl Forum thread URL
     * @return threadId Forum thread identifier
     * @return commentCount Comment count
     * @return lastUpdated Last update timestamp
     */
    function getLinkedForumThread(
        uint256 proposalId
    ) external view returns (
        string memory threadUrl,
        string memory threadId,
        uint256 commentCount,
        uint256 lastUpdated
    );

    /**
     * @notice Get forum activity statistics
     * @param startTime Start time for analysis
     * @param endTime End time for analysis
     * @return threadCount Number of threads
     * @return postCount Number of posts
     * @return uniquePosters Number of unique posters
     * @return mostActiveThreads Array of most active thread IDs
     */
    function getForumActivityStats(
        uint256 startTime,
        uint256 endTime
    ) external view returns (
        uint256 threadCount,
        uint256 postCount,
        uint256 uniquePosters,
        string[] memory mostActiveThreads
    );
}
```

## 10. Governance Upgrades

### 10.1 Governance Upgrade Process

```solidity
interface IGovernanceUpgrade {
    /**
     * @notice Propose a governance upgrade
     * @param newGovernor New governor contract address
     * @param description Upgrade description
     * @param migrationData Migration data
     * @return proposalId Proposal identifier
     */
    function proposeGovernanceUpgrade(
        address newGovernor,
        string calldata description,
        bytes calldata migrationData
    ) external returns (uint256 proposalId);

    /**
     * @notice Execute governance upgrade
     * @param proposalId Proposal identifier
     * @param newGovernor New governor contract address
     * @param migrationData Migration data
     * @return success Whether upgrade was successful
     */
    function executeGovernanceUpgrade(
        uint256 proposalId,
        address newGovernor,
        bytes calldata migrationData
    ) external returns (bool success);

    /**
     * @notice Abort governance upgrade
     * @param proposalId Proposal identifier
     * @return success Whether abort was successful
     */
    function abortGovernanceUpgrade(
        uint256 proposalId
    ) external returns (bool success);

    /**
     * @notice Get governance upgrade status
     * @param proposalId Proposal identifier
     * @return status Upgrade status
     */
    function getUpgradeStatus(
        uint256 proposalId
    ) external view returns (
        uint8 status,
        address oldGovernor,
        address newGovernor,
        uint256 migrationTimestamp
    );
}
```

### 10.2 Migration Manager

```solidity
interface IMigrationManager {
    /**
     * @notice Register a migration strategy
     * @param fromVersion From governance version
     * @param toVersion To governance version
     * @param migrationStrategy Migration strategy address
     * @return success Whether registration was successful
     */
    function registerMigrationStrategy(
        string calldata fromVersion,
        string calldata toVersion,
        address migrationStrategy
    ) external returns (bool success);

    /**
     * @notice Execute a migration
     * @param fromVersion From governance version
     * @param toVersion To governance version
     * @param migrationData Migration data
     * @return success Whether migration was successful
     */
    function executeMigration(
        string calldata fromVersion,
        string calldata toVersion,
        bytes calldata migrationData
    ) external returns (bool success);

    /**
     * @notice Get migration strategy
     * @param fromVersion From governance version
     * @param toVersion To governance version
     * @return strategy Migration strategy address
     * @return isRegistered Whether strategy is registered
     */
    function getMigrationStrategy(
        string calldata fromVersion,
        string calldata toVersion
    ) external view returns (
        address strategy,
        bool isRegistered
    );

    /**
     * @notice Get migration history
     * @return fromVersions Array of from versions
     * @return toVersions Array of to versions
     * @return timestamps Array of migration timestamps
     */
    function getMigrationHistory() external view returns (
        string[] memory fromVersions,
        string[] memory toVersions,
        uint256[] memory timestamps
    );
}
```

## 11. Integration Points

### 11.1 Treasury Integration

```solidity
interface ITreasuryGovernance {
    /**
     * @notice Propose a treasury action
     * @param targets Target addresses
     * @param values ETH values
     * @param signatures Function signatures
     * @param calldatas Call data
     * @param description Proposal description
     * @return proposalId Proposal identifier
     */
    function proposeTreasuryAction(
        address[] calldata targets,
        uint256[] calldata values,
        string[] calldata signatures,
        bytes[] calldata calldatas,
        string calldata description
    ) external returns (uint256 proposalId);

    /**
     * @notice Execute a treasury action
     * @param proposalId Proposal identifier
     * @return success Whether execution was successful
     */
    function executeTreasuryAction(
        uint256 proposalId
    ) external returns (bool success);

    /**
     * @notice Get treasury balance
     * @param token Token address (zero for ETH)
     * @return balance Treasury balance
     */
    function getTreasuryBalance(
        address token
    ) external view returns (uint256 balance);

    /**
     * @notice Get treasury transaction history
     * @param count Maximum transactions to return
     * @return txHashes Array of transaction hashes
     * @return txTypes Array of transaction types
     * @return amounts Array of transaction amounts
     * @return timestamps Array of transaction timestamps
     */
    function getTreasuryTransactionHistory(
        uint256 count
    ) external view returns (
        bytes32[] memory txHashes,
        uint8[] memory txTypes,
        uint256[] memory amounts,
        uint256[] memory timestamps
    );
}
```

### 11.2 Parameter Governance Integration

```solidity
interface IParameterGovernance {
    /**
     * @notice Propose a parameter change
     * @param module Module identifier
     * @param parameter Parameter identifier
     * @param value New parameter value
     * @param description Proposal description
     * @return proposalId Proposal identifier
     */
    function proposeParameterChange(
        bytes32 module,
        bytes32 parameter,
        bytes calldata value,
        string calldata description
    ) external returns (uint256 proposalId);

    /**
     * @notice Execute a parameter change
     * @param proposalId Proposal identifier
     * @return success Whether execution was successful
     */
        function executeParameterChange(
        uint256 proposalId
    ) external returns (bool success);

    /**
     * @notice Get parameter change history
     * @param module Module identifier
     * @param parameter Parameter identifier
     * @param count Maximum changes to return
     * @return values Array of parameter values
     * @return proposalIds Array of proposal IDs
     * @return timestamps Array of change timestamps
     */
    function getParameterChangeHistory(
        bytes32 module,
        bytes32 parameter,
        uint256 count
    ) external view returns (
        bytes[] memory values,
        uint256[] memory proposalIds,
        uint256[] memory timestamps
    );

    /**
     * @notice Get parameter governance committee
     * @param module Module identifier
     * @return committee Committee addresses
     * @return threshold Approval threshold
     */
    function getParameterCommittee(
        bytes32 module
    ) external view returns (
        address[] memory committee,
        uint256 threshold
    );

    /**
     * @notice Check if account is on parameter committee
     * @param module Module identifier
     * @param account Account to check
     * @return isMember Whether account is committee member
     */
    function isCommitteeMember(
        bytes32 module,
        address account
    ) external view returns (bool isMember);
}
```

### 11.3 Emergency Council Integration

```solidity
interface IEmergencyCouncil {
    /**
     * @notice Submit an emergency action
     * @param action Emergency action type
     * @param target Target address
     * @param value ETH value
     * @param data Call data
     * @param reason Emergency reason
     * @return actionId Emergency action identifier
     */
    function submitEmergencyAction(
        uint8 action,
        address target,
        uint256 value,
        bytes calldata data,
        string calldata reason
    ) external returns (uint256 actionId);

    /**
     * @notice Approve an emergency action
     * @param actionId Emergency action identifier
     * @return approvals Number of approvals
     */
    function approveEmergencyAction(
        uint256 actionId
    ) external returns (uint256 approvals);

    /**
     * @notice Execute an emergency action
     * @param actionId Emergency action identifier
     * @return success Whether execution was successful
     */
    function executeEmergencyAction(
        uint256 actionId
    ) external returns (bool success);

    /**
     * @notice Get emergency action status
     * @param actionId Emergency action identifier
     * @return action Emergency action details
     */
    function getEmergencyAction(
        uint256 actionId
    ) external view returns (
        uint8 actionType,
        address target,
        uint256 value,
        bytes memory data,
        string memory reason,
        address submitter,
        uint256 timestamp,
        bool executed,
        uint256 approvals
    );

    /**
     * @notice Get emergency council members
     * @return members Array of council member addresses
     * @return threshold Approval threshold
     */
    function getCouncilMembers() external view returns (
        address[] memory members,
        uint256 threshold
    );

    /**
     * @notice Check if account is on emergency council
     * @param account Account to check
     * @return isMember Whether account is council member
     */
    function isCouncilMember(
        address account
    ) external view returns (bool isMember);
}
```

## 12. Testing & Deployment Strategy

### 12.1 Governance Testing Framework

```solidity
interface IGovernanceTestHarness {
    /**
     * @notice Simulate governance actions
     * @param actions Array of actions to simulate
     * @return results Simulation results
     */
    function simulateGovernanceActions(
        GovernanceAction[] calldata actions
    ) external returns (SimulationResult[] memory results);

    /**
     * @notice Fast-forward governance workflow
     * @param proposalId Proposal identifier
     * @param stage Target stage to reach
     * @param votes Votes to apply (if applicable)
     * @return success Whether fast-forward was successful
     */
    function fastForwardProposal(
        uint256 proposalId,
        uint8 stage,
        Vote[] calldata votes
    ) external returns (bool success);

    /**
     * @notice Simulate multiple voters
     * @param proposalId Proposal identifier
     * @param voters Array of voter addresses
     * @param supports Array of support values
     * @param votingPowers Array of voting powers
     * @return result Voting simulation result
     */
    function simulateVoting(
        uint256 proposalId,
        address[] calldata voters,
        uint8[] calldata supports,
        uint256[] calldata votingPowers
    ) external returns (VotingSimulationResult memory result);

    /**
     * @notice Analyze proposal outcomes
     * @param proposalData Proposal simulation data
     * @return analysis Proposal outcome analysis
     */
    function analyzeProposalOutcomes(
        ProposalSimulation calldata proposalData
    ) external pure returns (ProposalAnalysis memory analysis);

    // Governance action structure
    struct GovernanceAction {
        uint8 actionType;
        address actor;
        bytes data;
    }

    // Simulation result structure
    struct SimulationResult {
        bool success;
        bytes returnData;
        string error;
    }

    // Vote structure
    struct Vote {
        address voter;
        uint8 support;
        uint256 votes;
    }

    // Voting simulation result structure
    struct VotingSimulationResult {
        uint256 totalVotes;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 abstainVotes;
        bool quorumReached;
        bool succeeded;
    }

    // Proposal simulation structure
    struct ProposalSimulation {
        uint8 proposalType;
        address proposer;
        uint256 initialFor;
        uint256 initialAgainst;
        uint256 initialAbstain;
        SimulatedVote[] additionalVotes;
    }

    // Simulated vote structure
    struct SimulatedVote {
        address voter;
        uint8 support;
        uint256 votes;
        uint256 votingTime;
    }

    // Proposal analysis structure
    struct ProposalAnalysis {
        bool willSucceed;
        bool willReachQuorum;
        uint256 requiredAdditionalVotes;
        address[] influentialVoters;
        uint8 recommendedAction;
    }
}
```

### 12.2 Deployment Strategy

The governance system will be deployed in phases to ensure stability and security:

1. **Phase 1: Foundation Deployment**

   - Deploy Governance Token with initial distribution
   - Deploy Basic Governor with administrative control
   - Deploy Timelock Controller
   - Deploy Parameter Control
   - Establish Emergency Council

2. **Phase 2: Hybrid Governance Activation**

   - Deploy Advanced Governor with voting mechanisms
   - Transition control from Basic Governor
   - Enable Parameter Committees
   - Implement voting power mechanisms

3. **Phase 3: Full Decentralization**
   - Reduce administrative controls
   - Transfer authorities to Governor
   - Implement delegation mechanisms
   - Activate full proposal framework

### 12.3 Risk Mitigation

```solidity
interface IRiskController {
    /**
     * @notice Check proposal risk level
     * @param proposalId Proposal identifier
     * @return riskLevel Risk level (0-100)
     * @return riskFactors Array of risk factors
     */
    function checkProposalRisk(
        uint256 proposalId
    ) external view returns (
        uint8 riskLevel,
        string[] memory riskFactors
    );

    /**
     * @notice Validate governance action
     * @param target Target address
     * @param data Call data
     * @return isValid Whether action is valid
     * @return riskLevel Risk level (0-100)
     * @return reason Validation reason
     */
    function validateGovernanceAction(
        address target,
        bytes calldata data
    ) external view returns (
        bool isValid,
        uint8 riskLevel,
        string memory reason
    );

    /**
     * @notice Get governance risk metrics
     * @return activeProposalRisk Average risk of active proposals
     * @return governanceAction Recent governance action count
     * @return parameterChanges Recent parameter change count
     * @return emergencyActionCount Recent emergency action count
     */
    function getGovernanceRiskMetrics() external view returns (
        uint8 activeProposalRisk,
        uint256 governanceActionCount,
        uint256 parameterChanges,
        uint256 emergencyActionCount
    );

    /**
     * @notice Simulate impact of governance action
     * @param target Target address
     * @param data Call data
     * @return impact Simulated impact
     */
    function simulateGovernanceImpact(
        address target,
        bytes calldata data
    ) external returns (
        ImpactAnalysis memory impact
    );

    // Impact analysis structure
    struct ImpactAnalysis {
        bool isPotentiallyDangerous;
        string[] affectedComponents;
        uint8 systemImpact;
        uint8 userImpact;
        bool requiresTimelock;
        uint256 recommendedTimelockDuration;
    }
}
```

## 13. References

1. RESI Protocol Overview, v1.0, 2025
2. Universal Value Unit (UVU) Technical Specification, v1.0, 2025
3. Oracle Aggregation and Data Validation Framework, v1.0, 2025
4. Collateral Management System Technical Specification, v1.0, 2025
5. Smart Contract Technical Specification, v1.0, 2025
6. Compound Governor Bravo, https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/GovernorBravo.sol
7. MakerDAO Governance Module, https://docs.makerdao.com/smart-contract-modules/governance-module
8. Aave Governance V2, https://docs.aave.com/developers/protocol-governance/governance
9. "Multi-tiered Governance in DeFi Protocols," Journal of Decentralized Finance, 2024
10. "Emergency Response Systems for DeFi Governance," Security Journal, 2024
11. "Delegation Patterns in Token Voting Systems," Governance Research Institute, 2023
12. "Parameter Committee Design for Specialized Governance," DeFi Governance Summit, 2024
13. Snapshot Off-chain Voting, https://docs.snapshot.org/
14. Tally Governance App, https://docs.tally.xyz/
15. RESI Protocol Risk Analysis Framework, v1.0, 2025

## Appendix A: Governance Parameters

The following key parameters control the governance system behavior:

| Parameter                   | Description                         | Default Value        | Min Value         | Max Value             | Change Authority  |
| --------------------------- | ----------------------------------- | -------------------- | ----------------- | --------------------- | ----------------- |
| PROPOSAL_THRESHOLD          | Votes required to submit a proposal | 1% of supply         | 0.1% of supply    | 5% of supply          | Meta-Governance   |
| VOTING_PERIOD               | Blocks for voting period            | 40,320 (~ 7 days)    | 5,760 (~ 1 day)   | 201,600 (~ 35 days)   | Meta-Governance   |
| VOTING_DELAY                | Blocks before voting begins         | 1 (immediate)        | 1                 | 40,320 (~ 7 days)     | Meta-Governance   |
| QUORUM                      | Votes required for quorum           | 4% of supply         | 1% of supply      | 20% of supply         | Meta-Governance   |
| TIMELOCK_DELAY              | Seconds before execution            | 172,800 (48 hours)   | 0                 | 1,209,600 (14 days)   | Meta-Governance   |
| EXECUTION_WINDOW            | Seconds to execute proposal         | 1,209,600 (14 days)  | 86,400 (1 day)    | 2,592,000 (30 days)   | Meta-Governance   |
| EMERGENCY_VOTING_PERIOD     | Blocks for emergency voting         | 5,760 (~ 1 day)      | 1,440 (~ 6 hours) | 11,520 (~ 2 days)     | Emergency Council |
| EMERGENCY_TIMELOCK_DELAY    | Seconds before emergency execution  | 3,600 (1 hour)       | 0                 | 86,400 (1 day)        | Emergency Council |
| MIN_ACTIONS_DELAY           | Minimum delay for proposal actions  | 0                    | 0                 | 604,800 (7 days)      | Meta-Governance   |
| MAX_ACTIONS_PER_PROPOSAL    | Maximum actions per proposal        | 10                   | 1                 | 20                    | Meta-Governance   |
| EMERGENCY_COUNCIL_SIZE      | Number of emergency council members | 7                    | 3                 | 15                    | Meta-Governance   |
| EMERGENCY_COUNCIL_THRESHOLD | Members needed for approval         | 5                    | 2                 | 15                    | Meta-Governance   |
| LOCK_DURATION_MAX           | Maximum lock duration               | 1,460 days (4 years) | 7 days            | 3,650 days (10 years) | Meta-Governance   |
| LOCK_DURATION_MIN           | Minimum lock duration               | 7 days               | 1 day             | 365 days (1 year)     | Meta-Governance   |

## Appendix B: Governance Process Flowcharts

### B.1 Standard Proposal Process

```
+-------------------+     +----------------+     +---------------+
|                   |     |                |     |               |
| Proposal Creation | --> | Discussion     | --> | Voting Period |
|                   |     | Period         |     |               |
+-------------------+     +----------------+     +------+--------+
                                                        |
                                                        v
+-------------------+     +----------------+     +---------------+
|                   |     |                |     |               |
| Execution         | <-- | Timelock      | <-- | Queue         |
|                   |     | Period         |     |               |
+-------------------+     +----------------+     +---------------+
```

### B.2 Emergency Proposal Process

```
+-------------------+     +----------------+     +---------------+
|                   |     |                |     |               |
| Emergency         | --> | Emergency      | --> | Quick Vote    |
| Detection         |     | Proposal       |     |               |
+-------------------+     +----------------+     +------+--------+
                                                        |
                                                        v
+-------------------+     +----------------+     +---------------+
|                   |     |                |     |               |
| Execution         | <-- | Short Timelock | <-- | Council       |
|                   |     |                |     | Approval      |
+-------------------+     +----------------+     +---------------+
```

### B.3 Parameter Governance Process

```
+-------------------+     +----------------+     +---------------+
|                   |     |                |     |               |
| Parameter         | --> | Specialized    | --> | Committee     |
| Change Request    |     | Assessment     |     | Vote          |
+-------------------+     +----------------+     +------+--------+
                                                        |
                                                        v
+-------------------+     +----------------+     +---------------+
|                   |     |                |     |               |
| Parameter         | <-- | Final Review   | <-- | Public        |
| Update            |     |                |     | Comment       |
+-------------------+     +----------------+     +---------------+
```

## Appendix C: Security Considerations

### C.1 Critical Security Paths

Key security considerations in the governance system include:

1. **Voting Power Attacks**: Prevent flash loan attacks or token consolidation before votes
2. **Timelock Circumvention**: Ensure all changes respect appropriate timelocks
3. **Parameter Boundaries**: Enforce strict limits on parameter changes
4. **Emergency Power Misuse**: Implement checks against misuse of emergency powers
5. **Proposal Stuffing**: Prevent governance spam or attacks via multiple proposals
6. **Vote Delegation Attacks**: Protect against unintended delegation transfers
7. **Contract Upgrades**: Thorough validation of all contract upgrade proposals

### C.2 Defense Mechanisms

```solidity
/**
 * @notice Check governance security
 * @param target Target address
 * @param selector Function selector
 * @param sender Transaction sender
 * @return isAllowed Whether action is allowed
 * @return reason Reason if not allowed
 */
function checkGovernanceSecurity(
    address target,
    bytes4 selector,
    address sender
) internal view returns (bool isAllowed, string memory reason) {
    // Check for critical functions that require maximum protection
    bytes32 functionHash = keccak256(abi.encodePacked(target, selector));

    if (criticalFunctionMap[functionHash]) {
        // Critical functions require full timelock and token holder vote
        if (!hasPassedFullGovernance(functionHash)) {
            return (false, "Function requires full governance approval");
        }
    }

    // Check for recently acquired voting power
    if (isVotingPowerRecent(sender)) {
        return (false, "Voting power too recent");
    }

    // Ensure proper delegation cooling period
    if (!hasDelegationCoolingPassed(sender)) {
        return (false, "Delegation cooling period not passed");
    }

    // Validate sender authorization
    if (!isAuthorizedGovernanceActor(sender, target, selector)) {
        return (false, "Sender not authorized for this action");
    }

    return (true, "");
}

/**
 * @notice Check if voting power was recently acquired
 * @param account Account to check
 * @return isRecent Whether voting power is recent
 */
function isVotingPowerRecent(address account) internal view returns (bool isRecent) {
    // Get the timestamp when the account last increased voting power
    uint256 lastVotingPowerIncreaseTime = getLastVotingPowerIncreaseTime(account);

    // Require voting power to be held for at least the voting delay period
    return block.timestamp - lastVotingPowerIncreaseTime < getVotingDelay();
}
```
