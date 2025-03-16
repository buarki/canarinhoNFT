# Canarinho NFT

Smart Contract of Canarinho NFT based in ERC-721.

## Overview and main components

In order to create the NFTs per se a few steps must be done before.

### 1. Artwork setup

We need to generate the picture and metadata of players defining their traits. The NFT schema we are following is this one:

```json
{
  "name": "Canarinho #0",
  "description": "Pele: The King of Soccer. The best player of history.",
  "edition": 1,
  "image": "ipfs://QmSz3F6dWRdV46d7x153ugbcWmcMYxuTVzPqbgSuh299JA/0.jpg",
  "attributes": [
    {
      "trait_type": "Jersey Number",
      "value": 10
    },
    {
      "trait_type": "Last World Cup",
      "value": 1970
    },
    {
      "trait_type": "Hair Style",
      "value": "Classic"
    },
    {
      "trait_type": "Stadium",
      "value": "Maracana"
    },
    {
      "trait_type": "Goals",
      "value": 1279
    }
  ]
}
```

We also defined a contract metadata like this one:

```json
{
  "name": "Canarinho NFT Collection",
  "description": "A collection of Canarinho NFTs celebrating Brazilian football culture. These rare digital collectibles honor the Brazilian spirit of football with unique and vibrant art.",
  "image": "ipfs://QmSz3F6dWRdV46d7x153ugbcWmcMYxuTVzPqbgSuh299JA/main_image.jpg", 
  "banner_image": "ipfs://QmSz3F6dWRdV46d7x153ugbcWmcMYxuTVzPqbgSuh299JA/banner_image.avif",
  "featured_image": "ipfs://QmSz3F6dWRdV46d7x153ugbcWmcMYxuTVzPqbgSuh299JA/featured_image.webp",
  "external_link": "https://github.com/buarki/canarinhoNFT",
  "seller_fee_basis_points": 500,
  "fee_recipient": "0x06a57e3845082ea4C449D6Eb84789eD34988936b",
  "collaborators": ["0x06a57e3845082ea4C449D6Eb84789eD34988936b"]
}
```


### 2. Storing pictures and metadata using IPFS

For decentralized, resilient storage, all CanarinhoNFT images and metadata are uploaded to an [IPFS (InterPlanetary File System)](https://ipfs.tech/) provider — in this case, [Filebase](https://console.filebase.com/). IPFS ensures that content is retrievable through its unique CID (Content Identifier) rather than a fixed URL, preventing single points of failure or content manipulation.

The workflow works like this:

- Generate artwork: Each NFT image is generated and assigned a unique identifier (e.g., 0.jpg).

- Generate metadata: A JSON file is created for each NFT, linking the image via an IPFS CID and including traits like player stats or unique aesthetics.

Upload to IPFS: Both images and metadata JSON files are uploaded to Filebase, which returns the corresponding CID. This CID is embedded into the smart contract’s base URI.

The base URI is structured as:

`ipfs://CID_CODE_HERE/`

Each token’s metadata is then fetched using:

`ipfs://CID_CODE_HERE/TOKEN_ID_HERE.json`

This ensures that even if Filebase goes offline, as long as any IPFS node hosts the data, the NFT remains accessible.


### 3. Contract implementation

The smart contract is built with Solidity ^0.8.28, using the ERC-721 implementation from OpenZeppelin. This ensures compliance with the widely adopted NFT standard while inheriting secure, battle-tested logic.

Key components:

- ERC-721 Base: The contract extends ERC721 from OpenZeppelin, which provides core functionality like token transfer, balance tracking, and ownership checks.

- Ownable: By inheriting OpenZeppelin's Ownable contract, the CanarinhoNFT contract ensures that only the deployer (or an assigned address) can perform privileged actions like enabling sales or withdrawing funds.

- Custom State Control: The setSaleState(bool) function allows the contract owner to toggle the sale state. It utilizes the onlyOwner modifier for restricted access. The contract emits a custom error (OwnableUnauthorizedAccount) when unauthorized addresses attempt to invoke this function.

- Minting Logic: The mint() function enforces the maximum tokens per wallet (MAX_TOKENS_PER_ADDRESS). It checks that msg.value meets the price requirement (require(msg.value >= price, "Insufficient payment")) and tracks per-wallet mint counts.

- Metadata URI: The contract overrides tokenURI() to dynamically return the IPFS-based metadata link, appending each token’s ID to the base URI defined at deployment.







## Development Setup

- install dependencies

```sh
npm i
```

- deploy a local node

```sh
npx hardhat node
```

- setup env var:

```sh
cat <<EOF > ".env"
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/TOKEN_HERE
SEPOLIA_WALLET_PRIVATE_KEY=PRIVATE_KEY_HERE
CONTRACT_METADATA_BASE_URI=ipfs://CID_HERE/
MAX_TOKENS_PER_WALLET=2
MAX_TOKENS=20
INITIAL_PRICE=0.01
ETHERSCAN_API_KEY=API_KEY_HERE
EOF
```

## Local Deployment

- Compile it:
```sh
make contract_compile
```

- Deploy to localhost network:

```sh
npx hardhat ignition deploy ./ignition/modules/Canarinho.ts --network localhost --deployment-id $(contract_version)
```

or if running from project root you can use Makefile

```sh
make contract_deploy_local contract_version=v1
```

## Sepolia Deployment

### Deploy
- Be sure that env vars *SEPOLIA_RPC_URL*, *SEPOLIA_WALLET_PRIVATE_KEY* are defined;
- Compile it:
```sh
make contract_compile
```

- Deploy to localhost network:

```sh
npx hardhat ignition deploy ./ignition/modules/Canarinho.ts --network sepolia --deployment-id $(contract_version)
```

or if running from project root you can use Makefile

```sh
make contract_deploy_sepolia contract_version=v1
```

### Verifying contract

```sh
npx hardhat ignition verify CONTRACT_VERSION_YOU_DEPLOYED
```

## Verify

```sh
npx hardhat verify --network localhost 0xADDRESS "https://your-metadata-url.com/" 2 20 10000000000000000
```

## Interact with contract via etherscan

Just visit *https://sepolia.etherscan.io/address/CONTRACT_HASH*;

## Interact with contract via console

```sh
npx hardhat console --network sepolia
```

## Interacting with network via console

### Connecting to it
```sh
npx hardhat console --network localhost
```

It will open a shell. Some operations interested to do:

```sh
const [signer] = await ethers.getSigners();
let contract = await ethers.getContractAt("Canarinho", "0x30fe996be95C75d504F999E724CF209CBD3AC0ED", signer);
```

then we can use it, like:

```sh
const contract = await ethers.getContractAt("Canarinho", "0x5FbDB2315678afecb367f032d93F642f64180aa3");
await contract.isSaleOn()
await contract.setSaleState(true);
await contract.isSaleOn()
```

### Estimating Gas of an operation

```sh
await contract.contractURI.estimateGas();
```

And we can define a gas limit of an operation. E.g: settint it to be 10% of estimated value:

```sh
const estimatedGas = await contract.mint.estimateGas({ value: ethers.parseEther("0.01") });
await runner.connect(addresses[2]).mint({ value: ethers.parseEther("0.01"), gasLimit: (estimatedGas * 110n) / 100n });
```

## Gas estimatives

```sh
let estimatedGasUsed = await contract.mint.estimateGas({ value: ethers.parseEther("0.01") });
let tx = await runner.connect(addresses[3]).mint({ value: ethers.parseEther("0.01"), gasLimit: (estimatedGasUsed * 110n) / 100n });
await tx.wait()
```

```txt
ContractTransactionReceipt {
  provider: HardhatEthersProvider {
    _hardhatProvider: LazyInitializationProviderAdapter {
      _providerFactory: [AsyncFunction (anonymous)],
      _emitter: [EventEmitter],
      _initializingPromise: [Promise],
      provider: [BackwardsCompatibilityProviderAdapter]
    },
    _networkName: 'localhost',
    _blockListeners: [],
    _transactionHashListeners: Map(0) {},
    _eventListeners: []
  },
  to: '0x5FbDB2315678afecb367f032d93F642f64180aa3',
  from: '0x90F79bf6EB2c4f870365E785982E1f101E93b906',
  contractAddress: null,
  hash: '0x0ae34a5642e9fb22cf55f06140ce66c98e6f0129137d4d3195624108e6cd99bd',
  index: 0,
  blockHash: '0x38747b989ef1814f847a3e71e29b35a5a905b79d5c6675690b62e93e5576ae89',
  blockNumber: 6,
  logsBloom: '0x04000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000040020000000000000000000800000000000000000000000010000000000000000000000000000000000000000000000000000000000400000200000000000000000000000000000100000000000000000000000000000000000000000000000042000000000000000000000000400000000000000000000000000020000000000000000000000010000000000000000000008000000000000000000000',
  gasUsed: 100627n,
  blobGasUsed: undefined,
  cumulativeGasUsed: 100627n,
  gasPrice: 1462748273n,
  blobGasPrice: undefined,
  type: 2,
  status: 1,
  root: undefined
}
```

### Defined gas limit

```txt
defined limit = (estimatedGasUsed * 110n) / 100n = (100627n * 100n) / 100n = 110689n;
```

### Gas costs in Wei and ETH
```txt
Gas Cost (in Wei)= 100627 × 1462748273 = 147,011,435,366,951 Wei
```

```txt
Gas Cost (in ETH)= 147,011,435,366,951 / 10^18 = 0.00014701 ETH
```

### Setting less gas than needed will fail

```txt
tx = await runner.connect(addresses[3]).mint({ value: ethers.parseEther("0.01"), gasLimit: 2 });
Uncaught ProviderError: Transaction requires at least 21064 gas but got 2
    at HttpProvider.request (/Users/user/projects/canarinho-nft/nft/node_modules/hardhat/src/internal/core/providers/http.ts:107:21)
    at processTicksAndRejections (node:internal/process/task_queues:95:5)
    at async HardhatEthersSigner.sendTransaction (/Users/user/projects/canarinho-nft/nft/node_modules/@nomicfoundation/hardhat-ethers/src/signers.ts:125:18)
    at async send (/Users/user/projects/canarinho-nft/nft/node_modules/ethers/src.ts/contract/contract.ts:313:20)
    at async Proxy.mint (/Users/user/projects/canarinho-nft/nft/node_modules/ethers/src.ts/contract/contract.ts:352:16)
    at async REPL150:1:38
    at async node:repl:617:29
```



