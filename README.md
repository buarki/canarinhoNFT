# Canarinho NFTs

## I Just Wanna See It
You can see the NFT at available at [OpenSea](https://testnets.opensea.io/collection/canarinho-nft-collection) and check the already mint ones.

You can also mint new NFTs and check the published contract at [Etherscan](https://sepolia.etherscan.io/address/0x30fe996be95c75d504f999e724cf209cbd3ac0ed).

## Summary

CanarinhoNFT is an [ERC-721-compliant](https://www.coinbase.com/en-br/learn/crypto-glossary/what-is-erc-721) smart contract designed for secure, configurable NFT minting. Built on [Solidity](https://soliditylang.org/) ^0.8.28 and leveraging [OpenZeppelin’s](https://www.openzeppelin.com/) battle-tested libraries, it ensures robustness, extensibility, and gas optimization.

It leverages [Hardhat](https://hardhat.org) for streamlined contract compilation, deployment, and testing. Fixtures and snapshots ensure deterministic, performant test runs, supporting advanced scenarios like state resets between test cases for faster iteration.

Some of the core features:
- ERC-721 & ERC721URIStorage: Supports unique, verifiable NFTs with metadata storage.
- Ownable Access Control: Uses OpenZeppelin’s Ownable to enforce admin-only functions (setPrice, setSaleState, withdraw), ensuring only the contract owner controls key operations.
- Immutable Supply Constraints: Enforces max token supply and per-wallet limits via immutable variables to prevent tampering after deployment.
- Gas-Optimized Minting: Implements Solidity’s unchecked blocks to minimize arithmetic overhead, reducing gas fees on state updates.
- Reentrancy Safety: Ether handling (e.g., refunds) occurs post-state update, following the Checks-Effects-Interactions pattern to prevent reentrancy vulnerabilities.
- Custom Errors: Adopts Solidity’s efficient error mechanism (OwnableUnauthorizedAccount) for cleaner revert handling and reduced bytecode size compared to traditional revert strings.



## Artworks
You can refer to [this doc](./artworks/README.md) to get more details about how the images are prepared and deployed to an IPFS platform.

## Smart Contract Implementation
The smart contract implementation and more details about it can be seen at [NFT directory](./nft/README.md).
