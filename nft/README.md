# Canarinho NFT

Smart Contract of Canarinho NFT based in ERC-721.

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Canarinho.ts --network localhost --deployment-id localhost-deployment #--verify
```

## Verify

```sh
npx hardhat verify --network localhost 0xADDRESS "https://your-metadata-url.com/" 2 20 10000000000000000
```

## Interact with network

```sh
npx hardhat console --network localhost
```

then we can use it, like:

```sh
const contract = await ethers.getContractAt("Canarinho", "0x5FbDB2315678afecb367f032d93F642f64180aa3");
await contract.isSaleOn()
await contract.setSaleState(true);
```

## Verify on etherscan

```sh
npx hardhat ignition verify sepolia-deployment
```

## Minting

```sh
let runner = await ethers.getContractAt("Canarinho", CONTRACT_ADDRESS, 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
const addresses = await ethers.getSigners();
await runner.connect(addresses[2]).mint({ value: ethers.parseEther("0.01") });
```

## Estimating gas

```sh
const estimatedGas = await contract.mint.estimateGas({ value: ethers.parseEther("0.01") });
console.log("Estimated Gas:", estimatedGas.toString());
```

we can also minting setting gas limit:

```sh
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
    at HttpProvider.request (/Users/buarki/projects/canarinho-nft/nft/node_modules/hardhat/src/internal/core/providers/http.ts:107:21)
    at processTicksAndRejections (node:internal/process/task_queues:95:5)
    at async HardhatEthersSigner.sendTransaction (/Users/buarki/projects/canarinho-nft/nft/node_modules/@nomicfoundation/hardhat-ethers/src/signers.ts:125:18)
    at async send (/Users/buarki/projects/canarinho-nft/nft/node_modules/ethers/src.ts/contract/contract.ts:313:20)
    at async Proxy.mint (/Users/buarki/projects/canarinho-nft/nft/node_modules/ethers/src.ts/contract/contract.ts:352:16)
    at async REPL150:1:38
    at async node:repl:617:29
```

## Checking deployed contract

Just go to https://sepolia.etherscan.io/address/CONTRACT_HASH

like:

https://sepolia.etherscan.io/address/0xE3FF621A32eDA5F6AfB03be28dCD4e89eA311Be4



