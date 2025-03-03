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
  etherscan: {
    enabled: true,
    apiKey: {
      sepolia: process.env.ETHERSCAN_API_KEY!,
    },
  },
};

export default config;
