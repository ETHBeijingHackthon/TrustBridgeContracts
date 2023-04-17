import { ethers, upgrades } from 'hardhat'

async function main() {
  const [deployer] = await ethers.getSigners()

  console.log('Deploying contracts with the account:', deployer.address)
  console.log('Account balance:', (await deployer.getBalance()).toString())

  const TrustBridge = await ethers.getContractFactory('TrustBridge')

  // const trustBridge = await TrustBridge.deploy()
  // await trustBridge.deployed()

  const trustBridge = await upgrades.deployProxy(TrustBridge)
  await trustBridge.deployed()

  console.log(`TrustBridge deployed to ${trustBridge.address}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
