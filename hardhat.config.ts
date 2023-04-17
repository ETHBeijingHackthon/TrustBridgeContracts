import { HardhatUserConfig } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'
import '@matterlabs/hardhat-zksync-deploy'
import '@matterlabs/hardhat-zksync-solc'
import '@matterlabs/hardhat-zksync-verify'
import '@openzeppelin/hardhat-upgrades'

const INFURA_API_KEY = process.env.INFURA_API_KEY
const ANKR_API_KEY = process.env.ANKR_API_KEY

const PRIVATE_KEY = process.env.PRIVATE_KEY

https: module.exports = {
  solidity: '0.8.18',
  zksolc: {
    version: '1.3.5',
    compilerSource: 'binary',
    settings: {},
  },
  defaultNetwork: 'zkTestnet',
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY],
      gas: 'auto',
    },
    fantom_testnet: {
      url: `https://rpc.ankr.com/fantom_testnet/${ANKR_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
    zkTestnet: {
      url: 'https://testnet.era.zksync.dev', // URL of the zkSync network RPC
      ethNetwork: 'goerli', // Can also be the RPC URL of the Ethereum network (e.g. `https://goerli.infura.io/v3/<API_KEY>`)
      zksync: true,
      verifyURL:
        'https://zksync2-testnet-explorer.zksync.dev/contract_verification',
    },
    zkMainnet: {
      url: 'https://mainnet.era.zksync.io',
      ethNetwork: 'https://eth.llamarpc.com',
      zksync: true,
      verifyURL:
        'https://zksync2-mainnet-explorer.zksync.io/contract_verification',
    },
  },
  etherscan: {
    apiKey: {
      ftmTestnet: process.env.FTMTESTNET_API_KEY,
      goerli: process.env.ETHERSCAN_API_KEY,
    },
  },
}

const config: HardhatUserConfig = {
  solidity: '0.8.18',
}

export default config
