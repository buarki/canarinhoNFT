// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
require("dotenv").config();
const hre = require("hardhat");

const CanarinhoModule = buildModule("CanarinhoModule", (m) => {

  const metadataBaseURI = process.env.CONTRACT_METADATA_BASE_URI;
  if (!metadataBaseURI) {
    throw new Error('CONTRACT_METADATA_BASE_URI must be defined');
  }
  const maxTokensPerWallet = process.env.MAX_TOKENS_PER_WALLET;
  if (!maxTokensPerWallet) {
    throw new Error('MAX_TOKENS_PER_WALLET must be defined');
  }
  const maxTokens = process.env.MAX_TOKENS;
  if (!maxTokens) {
    throw new Error('MAX_TOKENS must be defined');
  }
  const initialPrice = process.env.INITIAL_PRICE;
  if (!initialPrice) {
    throw new Error('INITIAL_PRICE must be defined');
  }

  console.log({
    metadataBaseURI,
    maxTokens,
    maxTokensPerWallet,
    initialPrice,
  });


  const Canarinho = m.contract("Canarinho", [
    metadataBaseURI,
    maxTokensPerWallet,
    maxTokens,
    hre.ethers.parseEther(initialPrice)
  ]);

  return { Canarinho };
});

export default CanarinhoModule;
