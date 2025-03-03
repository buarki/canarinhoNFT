# Hardhat 1:1

## Key links
- https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-verify#verifying-on-sourcify;
- https://hardhat.org/hardhat-runner/docs/guides/verifying;

## Verifying contract

### Needed steps
- sign up for etherscan account;
- generate an API key
- setup hardhat.config.ts like:

```js
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";
require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
      accounts: {
        mnemonic: "test test test test test test test test test test test junk",
      },
    },
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.SEPOLIA_WALLET_PRIVATE_KEY!],
    },
  },
  // THIS PART
  etherscan: {
    apiKey: {
      sepolia: process.env.ETHERSCAN_API_KEY!,
    },
  },
};

export default config;
```

Then run it like:

```sh
npx hardhat verify --network sepolia "$SEPOLIA_CONTRACT" "ipfs://QmejcaQAPyqjCBRfhkXtS9Z1o7afR8AtD41Q6hxa9MUpTa/" 2 20 10000000000000000
```

### Flattening contract
- link: https://hardhat.org/hardhat-runner/docs/advanced/flattening

```sh
npx hardhat flatten > path/to/contract/sol > flattened.sol
```

