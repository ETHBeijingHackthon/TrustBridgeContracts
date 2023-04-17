import { utils, Wallet } from 'zksync-web3'
import * as ethers from 'ethers'
import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { Deployer } from '@matterlabs/hardhat-zksync-deploy'

// An example of a deploy script that will deploy and call a simple contract.
export default async function (hre: HardhatRuntimeEnvironment) {
  console.log(`Running deploy script for the TrustBridge contract`)

  // Initialize the wallet.
  const private_key = process.env.PRIVATE_KEY ? process.env.PRIVATE_KEY : ''
  const wallet = new Wallet(private_key)

  // Create deployer object and load the artifact of the contract we want to deploy.
  const deployer = new Deployer(hre, wallet)
  const artifact = await deployer.loadArtifact('TrustBridge')

  // const greeterContract = await deployer.deploy(artifact, [greeting])
  const trustBridge = await deployer.deploy(artifact)

  // Show the contract info.
  const contractAddress = trustBridge.address
  console.log(`${artifact.contractName} was deployed to ${contractAddress}`)
}
