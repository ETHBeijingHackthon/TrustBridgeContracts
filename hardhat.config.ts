import { HardhatUserConfig } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'

const INFURA_API_KEY = process.env.INFURA_API_KEY
const ANKR_API_KEY = process.env.ANKR_API_KEY

const PRIVATE_KEY = process.env.PRIVATE_KEY

console.log(process.env.FTMTESTNET_API_KEY)

https: module.exports = {
  solidity: '0.8.18',
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
    fantom_testnet: {
      url: `https://rpc.ankr.com/fantom_testnet/${ANKR_API_KEY}`,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      ftmTestnet: process.env.FTMTESTNET_API_KEY,
    },
  },
}

const config: HardhatUserConfig = {
  solidity: '0.8.18',
}

export default config
