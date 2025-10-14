# Olacoin (OLA) - Stacks Fungible Token

![Olacoin Logo](https://img.shields.io/badge/Olacoin-OLA-blue?style=for-the-badge)
[![Clarity](https://img.shields.io/badge/Built%20with-Clarity-orange?style=flat-square)](https://clarity-lang.org/)
[![Stacks](https://img.shields.io/badge/Blockchain-Stacks-purple?style=flat-square)](https://www.stacks.co/)
[![SIP-010](https://img.shields.io/badge/Standard-SIP--010-green?style=flat-square)](https://github.com/stacksgov/sips)

## Overview

Olacoin (OLA) is a community-driven fungible token built on the Stacks blockchain, implementing the SIP-010 standard for fungible tokens. It provides a robust foundation for digital currency with governance features and sustainable tokenomics.

## Features

- ✅ **SIP-010 Compliant**: Full implementation of the Stacks Improvement Proposal 010 standard
- 🔐 **Secure**: Built with Clarity smart contract language for maximum security
- 🎯 **Decentralized**: Community governance with administrative controls
- 💰 **Capped Supply**: Maximum supply of 10 billion tokens with 6 decimal places
- 🔥 **Burnable**: Token holders can burn their tokens to reduce supply
- 🛡️ **Access Control**: Owner-only functions for minting and administrative tasks
- 📊 **Rich Analytics**: Built-in functions for supply percentage calculations

## Token Specifications

| Property | Value |
|----------|-------|
| **Name** | Olacoin |
| **Symbol** | OLA |
| **Decimals** | 6 |
| **Max Supply** | 10,000,000,000 OLA (10 billion) |
| **Initial Supply** | 1,000,000 OLA (1 million) |
| **Standard** | SIP-010 |

## Smart Contract Functions

### SIP-010 Standard Functions

#### `transfer`
Transfer tokens from sender to recipient.
```clarity
(transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
```

#### `get-name`
Returns the token name.
```clarity
(get-name) → (response (string-ascii 32) none)
```

#### `get-symbol`
Returns the token symbol.
```clarity
(get-symbol) → (response (string-ascii 32) none)
```

#### `get-decimals`
Returns the number of decimal places.
```clarity
(get-decimals) → (response uint none)
```

#### `get-balance`
Returns the token balance for a given principal.
```clarity
(get-balance (who principal)) → (response uint none)
```

#### `get-total-supply`
Returns the current total supply.
```clarity
(get-total-supply) → (response uint none)
```

#### `get-token-uri`
Returns the token metadata URI.
```clarity
(get-token-uri) → (response (optional (string-utf8 256)) none)
```

### Administrative Functions (Owner Only)

#### `mint`
Mint new tokens to a recipient (requires owner privileges).
```clarity
(mint (amount uint) (recipient principal))
```

#### `burn`
Burn tokens from an owner's balance.
```clarity
(burn (amount uint) (owner principal))
```

#### `set-token-uri`
Update the token metadata URI.
```clarity
(set-token-uri (value (optional (string-utf8 256))))
```

#### `set-contract-owner`
Transfer contract ownership.
```clarity
(set-contract-owner (new-owner principal))
```

#### `toggle-mint-enabled`
Enable or disable minting functionality.
```clarity
(toggle-mint-enabled)
```

### Read-Only Functions

#### `get-contract-owner`
Returns the current contract owner.
```clarity
(get-contract-owner) → principal
```

#### `is-mint-enabled`
Checks if minting is currently enabled.
```clarity
(is-mint-enabled) → bool
```

#### `get-max-supply`
Returns the maximum possible token supply.
```clarity
(get-max-supply) → uint
```

#### `get-supply-percentage`
Calculate what percentage of total supply an amount represents.
```clarity
(get-supply-percentage (amount uint)) → uint
```

## Installation & Setup

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity development environment
- [Node.js](https://nodejs.org/) (v14 or higher) - For testing
- [Git](https://git-scm.com/) - Version control

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/olacoin.git
   cd olacoin/olacoin-contract
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Check contract syntax**
   ```bash
   clarinet check
   ```

4. **Run tests**
   ```bash
   npm test
   ```

5. **Start local devnet**
   ```bash
   clarinet integrate
   ```

### Deployment

#### Testnet Deployment

1. **Configure Clarinet for testnet**
   ```bash
   clarinet deployments generate --testnet
   ```

2. **Deploy to testnet**
   ```bash
   clarinet deployments apply --testnet
   ```

#### Mainnet Deployment

1. **Configure Clarinet for mainnet**
   ```bash
   clarinet deployments generate --mainnet
   ```

2. **Deploy to mainnet** (requires STX for fees)
   ```bash
   clarinet deployments apply --mainnet
   ```

## Testing

The project includes comprehensive TypeScript tests using Clarinet's testing framework.

### Run All Tests
```bash
npm test
```

### Run Specific Test File
```bash
npm test -- tests/olacoin.test.ts
```

### Test Coverage

The test suite covers:
- ✅ Token transfers and approvals
- ✅ Minting and burning functionality
- ✅ Access control and permissions
- ✅ SIP-010 compliance
- ✅ Error handling and edge cases
- ✅ Administrative functions

## Security Considerations

### Access Control
- Only the contract owner can mint new tokens
- Only token owners can burn their tokens
- Administrative functions are protected by owner-only assertions

### Supply Management
- Hard cap of 10 billion tokens prevents inflation
- Minting can be disabled by the owner if needed
- Burning reduces total supply permanently

### Error Handling
- Comprehensive error codes for different failure scenarios
- Input validation on all public functions
- Protection against common vulnerabilities

## Error Codes

| Code | Error | Description |
|------|-------|-------------|
| u100 | ERR_OWNER_ONLY | Function restricted to contract owner |
| u101 | ERR_NOT_TOKEN_OWNER | Caller is not the token owner |
| u102 | ERR_INSUFFICIENT_BALANCE | Insufficient token balance |
| u103 | ERR_INVALID_AMOUNT | Amount must be greater than zero |
| u104 | ERR_MINT_FAILED | Minting failed (disabled or exceeds cap) |
| u105 | ERR_BURN_FAILED | Token burning failed |

## Roadmap

### Phase 1 - Core Token ✅
- [x] SIP-010 implementation
- [x] Basic mint/burn functionality
- [x] Access controls
- [x] Comprehensive testing

### Phase 2 - Enhanced Features 🔄
- [ ] Governance voting mechanisms
- [ ] Staking rewards system
- [ ] Multi-signature support
- [ ] Time-locked transfers

### Phase 3 - Ecosystem Integration 📋
- [ ] DEX integration
- [ ] Cross-chain bridges
- [ ] DeFi protocol partnerships
- [ ] Mobile wallet support

## Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- Code style and standards
- Testing requirements
- Pull request process
- Issue reporting

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Run the test suite (`npm test`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

## Support & Community

- **GitHub Issues**: [Report bugs or request features](https://github.com/your-username/olacoin/issues)
- **Discord**: [Join our community](https://discord.gg/olacoin)
- **Twitter**: [@OlacoinOfficial](https://twitter.com/OlacoinOfficial)
- **Documentation**: [Full docs](https://docs.olacoin.io)

## Acknowledgments

- **Stacks Foundation** - For the amazing blockchain infrastructure
- **Hiro Systems** - For Clarinet and development tools
- **Clarity Community** - For best practices and security guidance
- **Contributors** - Everyone who has contributed to this project

---

**⚠️ Disclaimer**: This software is provided "as is" without warranty. Always conduct thorough testing and security audits before deploying to mainnet with real funds.

**🔐 Security**: If you discover a security vulnerability, please report it privately to security@olacoin.io before public disclosure.