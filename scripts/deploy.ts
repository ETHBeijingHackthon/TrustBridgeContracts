import { ethers } from 'hardhat'

async function main() {
  const TrusBridge = await ethers.getContractFactory('TrusBridge')
  const trusBridge = await TrusBridge.deploy()

  await trusBridge.deployed()

  console.log(`TrusBridge deployed to ${trusBridge.address}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
