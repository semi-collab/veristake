# VeriStake Protocol

> A revolutionary blockchain-based platform that transforms event management through cryptographic proof-of-presence and automated reward distribution on the Stacks Layer 2 blockchain.

[![Clarity Version](https://img.shields.io/badge/Clarity-2.0-blue)](https://clarity-lang.org/)
[![Stacks](https://img.shields.io/badge/Stacks-Layer%202-orange)](https://stacks.co/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

VeriStake Protocol is an enterprise-grade smart contract system built on Stacks that provides decentralized event verification and automated reward distribution. The protocol leverages Bitcoin's security through Stacks Layer 2 to create immutable attendance records and trustless reward mechanisms.

### Key Features

- **🔒 Immutable Attendance Records**: Cryptographically secured check-in/check-out system
- **💰 Smart Reward Distribution**: Automated STX payouts based on participation metrics
- **🌐 Decentralized Verification**: Community-driven validation with trusted authorities
- **🎯 Multi-Tier Incentives**: Base rewards + performance bonuses for engagement
- **🏢 Enterprise Integration**: Scalable infrastructure for various event types

## Architecture

### System Components

```
┌─────────────────────────────────────────────────────────────┐
│                    VeriStake Protocol                       │
├─────────────────────────────────────────────────────────────┤
│  Event Management Layer                                    │
│  ├── Event Creation & Configuration                       │
│  ├── Duration & Reward Management                         │
│  └── Event Lifecycle Control                              │
├─────────────────────────────────────────────────────────────┤
│  Attendance Tracking Layer                                 │
│  ├── Check-in/Check-out System                           │
│  ├── Duration Calculation                                 │
│  └── Participation Metrics                               │
├─────────────────────────────────────────────────────────────┤
│  Verification Layer                                        │
│  ├── Authorized Verifier Registry                        │
│  ├── Attendance Validation                               │
│  └── Audit Trail Management                              │
├─────────────────────────────────────────────────────────────┤
│  Reward Distribution Layer                                  │
│  ├── Tiered Reward Calculation                           │
│  ├── Treasury Management                                 │
│  └── Automated Payouts                                   │
├─────────────────────────────────────────────────────────────┤
│  Administrative Layer                                      │
│  ├── Access Control                                      │
│  ├── Fund Management                                     │
│  └── System Configuration                                │
└─────────────────────────────────────────────────────────────┘
```

### Data Model

#### Core Entities

**Events**

```clarity
{
  name: (string-ascii 50),
  description: (string-ascii 200),
  start-height: uint,
  end-height: uint,
  base-reward: uint,
  bonus-reward: uint,
  min-attendance-duration: uint,
  organizer: principal,
  is-active: bool
}
```

**Attendance Records**

```clarity
{
  check-in-height: uint,
  check-out-height: uint,
  duration: uint,
  verified: bool
}
```

**Verification Details**

```clarity
{
  verified-by: principal,
  verified-at: uint
}
```

**Reward Claims**

```clarity
{
  amount: uint,
  claimed-at: uint,
  reward-tier: uint
}
```

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity development environment
- [Node.js](https://nodejs.org/) (v16 or higher)
- [Git](https://git-scm.com/)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/semi-collab/veristake.git
   cd veristake
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Initialize Clarinet environment**

   ```bash
   clarinet check
   ```

### Quick Start

1. **Deploy the contract locally**

   ```bash
   clarinet console
   ```

2. **Run the test suite**

   ```bash
   npm test
   ```

3. **Check contract syntax**

   ```bash
   clarinet check
   ```

## Usage

### Event Management

#### Creating an Event

```clarity
(contract-call? .veristake create-event
  "Tech Conference 2025"
  "Annual blockchain technology conference with industry leaders"
  u1000    ;; start-height
  u1440    ;; duration (10 days in blocks)
  u100000  ;; base-reward (0.1 STX)
  u50000   ;; bonus-reward (0.05 STX)
  u720     ;; min-attendance (5 days)
)
```

#### Event Parameters

| Parameter | Type | Description | Constraints |
|-----------|------|-------------|-------------|
| `name` | string-ascii 50 | Event name | 3-50 characters |
| `description` | string-ascii 200 | Event description | 10-200 characters |
| `start-height` | uint | Start block height | Must be future block |
| `duration` | uint | Event duration in blocks | 144-52560 blocks (1 day - 1 year) |
| `base-reward` | uint | Base reward in microSTX | 0-1,000,000,000,000 µSTX |
| `bonus-reward` | uint | Bonus reward in microSTX | 0-1,000,000,000,000 µSTX |
| `min-attendance` | uint | Minimum attendance for bonus | 1-duration blocks |

### Attendance Tracking

#### Check-in Process

```clarity
(contract-call? .veristake check-in u1)
```

#### Check-out Process

```clarity
(contract-call? .veristake check-out u1)
```

### Verification System

#### Adding Verifiers

```clarity
(contract-call? .veristake add-verifier 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7)
```

#### Verifying Attendance

```clarity
(contract-call? .veristake verify-attendance 
  u1 ;; event-id
  'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 ;; attendee
)
```

### Reward Distribution

#### Claiming Rewards

```clarity
(contract-call? .veristake claim-reward u1)
```

The reward calculation follows this logic:

- **Base Reward**: Always awarded for verified attendance
- **Bonus Reward**: Awarded if attendance duration ≥ minimum required duration
- **Total Reward**: Base + Bonus (if eligible)

### Treasury Management

#### Depositing Funds

```clarity
(contract-call? .veristake deposit-funds u1000000) ;; 1 STX
```

#### Withdrawing Funds (Owner Only)

```clarity
(contract-call? .veristake withdraw-funds u500000) ;; 0.5 STX
```

## API Reference

### Read-Only Functions

| Function | Parameters | Returns | Description |
|----------|------------|---------|-------------|
| `get-owner` | - | `principal` | Returns contract owner |
| `get-event` | `event-id: uint` | `(optional event)` | Returns event details |
| `get-attendance-record` | `event-id: uint`, `attendee: principal` | `(optional attendance)` | Returns attendance record |
| `get-reward-claim` | `event-id: uint`, `attendee: principal` | `(optional claim)` | Returns reward claim details |
| `is-verifier` | `address: principal` | `bool` | Checks if address is verifier |
| `event-exists` | `event-id: uint` | `bool` | Checks if event exists |
| `can-verify-attendance` | `event-id: uint`, `attendee: principal` | `bool` | Checks if attendance can be verified |

### Public Functions

| Function | Parameters | Access | Description |
|----------|------------|--------|-------------|
| `create-event` | Event details | Owner only | Creates new event |
| `check-in` | `event-id: uint` | Public | Check into event |
| `check-out` | `event-id: uint` | Public | Check out of event |
| `verify-attendance` | `event-id: uint`, `attendee: principal` | Verifiers only | Verify attendance |
| `claim-reward` | `event-id: uint` | Public | Claim attendance reward |
| `add-verifier` | `address: principal` | Owner only | Add new verifier |
| `remove-verifier` | `address: principal` | Owner only | Remove verifier |
| `deactivate-event` | `event-id: uint` | Owner only | Deactivate event |
| `deposit-funds` | `amount: uint` | Public | Deposit STX to treasury |
| `withdraw-funds` | `amount: uint` | Owner only | Withdraw STX from treasury |

## Error Codes

### Core Errors (100-199)

- `u100`: Not authorized
- `u101`: Already claimed reward
- `u102`: Event not ended
- `u103`: Event ended
- `u104`: No reward available
- `u105`: Event not found
- `u106`: Insufficient funds
- `u107`: Invalid duration
- `u108`: Already registered

### Verification Errors (120-199)

- `u120`: Event not active
- `u121`: No check-in record
- `u122`: Already verified
- `u123`: Invalid attendee

### Admin Errors (1000-1999)

- `u1002`: Invalid address
- `u1003`: Already verifier
- `u1004`: Not verifier
- `u1005`: Invalid amount
- `u1006`: Event already inactive
- `u1007`: Transfer failed

### Validation Errors (2000-2999)

- `u2000`: Invalid name
- `u2001`: Invalid description
- `u2002`: Contains invalid characters

## Use Cases

### 🎯 Conference Management

- **Scenario**: Tech conferences, academic symposiums
- **Benefits**: Transparent attendance tracking, automated speaker/attendee rewards
- **Implementation**: Multi-day events with session-based check-ins

### 🎓 Educational Institutions

- **Scenario**: University courses, training programs
- **Benefits**: Verifiable participation records, completion incentives
- **Implementation**: Semester-long courses with attendance requirements

### 🏢 Corporate Training

- **Scenario**: Employee workshops, certification programs
- **Benefits**: Compliance tracking, performance-based rewards
- **Implementation**: Skills development programs with completion bonuses

### 🗳️ DAO Governance

- **Scenario**: Governance meetings, community calls
- **Benefits**: Participation-based voting weights, engagement rewards
- **Implementation**: Regular community events with participation tracking

### 🌐 Web3 Events

- **Scenario**: Hackathons, NFT launches, DeFi protocols
- **Benefits**: Trustless verification, token-based rewards
- **Implementation**: Multi-phase events with milestone-based rewards

## Security Model

### Access Control

- **Contract Owner**: Full administrative control
- **Verifiers**: Attendance verification authority
- **Participants**: Event interaction permissions

### Financial Security

- **Treasury Management**: Controlled fund deposits/withdrawals
- **Reward Caps**: Maximum reward limits prevent drainage
- **Balance Validation**: Pre-transfer balance checks

### Data Integrity

- **Immutable Records**: Blockchain-anchored attendance data
- **Verification Trail**: Complete audit history
- **Input Validation**: Comprehensive parameter checking

## Testing

Run the comprehensive test suite:

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Check contract syntax
clarinet check

# Format code
clarinet format
```

### Test Coverage

- ✅ Event creation and validation
- ✅ Attendance tracking lifecycle
- ✅ Verification system integrity
- ✅ Reward calculation accuracy
- ✅ Administrative functions
- ✅ Error handling scenarios
- ✅ Edge case validation

## Deployment

### Local Development

```bash
# Start local blockchain
clarinet integrate

# Deploy to local network
clarinet publish --local
```

### Testnet Deployment

```bash
# Configure testnet settings
clarinet publish --testnet
```

### Mainnet Deployment

```bash
# Deploy to mainnet (requires careful review)
clarinet publish --mainnet
```

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards

- Follow Clarity best practices
- Include comprehensive tests
- Document all public functions
- Use meaningful variable names
- Add inline comments for complex logic

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Roadmap

### Phase 1: Core Protocol ✅

- Event management system
- Attendance tracking
- Basic verification
- Reward distribution

### Phase 2: Enhanced Features 🚧

- Multi-signature treasury
- Advanced verification methods
- Integration APIs
- Dashboard interface

### Phase 3: Ecosystem Integration 📋

- Cross-chain compatibility
- DeFi integrations
- NFT certificates
- Mobile applications

## Acknowledgments

- Stacks Foundation for blockchain infrastructure
- Clarity language contributors
- Open source community
- Early adopters and testers
