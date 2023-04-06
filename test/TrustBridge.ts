import { time, loadFixture } from '@nomicfoundation/hardhat-network-helpers'
import { anyValue } from '@nomicfoundation/hardhat-chai-matchers/withArgs'
import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('TrusBridge', function () {
  async function deployTrustBridge() {
    const [owner, otherAccount] = await ethers.getSigners()

    const TrustBridge = await ethers.getContractFactory('TrustBridge')
    const trustBridge = await TrustBridge.deploy()

    return { trustBridge, owner, otherAccount }
  }

  describe('CreatNFT', function () {
    it('Should emit an event on Creat', async () => {
      const { trustBridge, owner } = await loadFixture(deployTrustBridge)

      await expect(
        trustBridge.createNFT('Coffee', 'CID1', 'CID2', 'title', 'desc')
      )
        .to.emit(trustBridge, 'NFTCreated')
        .withArgs(
          1,
          0,
          'Coffee',
          owner.address,
          'CID1',
          'CID2',
          'title',
          'desc'
        )
    })
  })

  describe('ReviewNFT', function () {
    it('Should revert with Invalid NFTID', async () => {
      const { trustBridge, owner } = await loadFixture(deployTrustBridge)

      await expect(
        trustBridge.reviewNFT(1, 5, 'desc', 'CID')
      ).to.be.rejectedWith('Invalid NFT id')
    })

    it('Should emit two events on Review', async () => {
      const { trustBridge, owner } = await loadFixture(deployTrustBridge)

      await trustBridge.createNFT('Coffee', 'CID1', 'CID2', 'title', 'desc')

      const promise = trustBridge.reviewNFT(1, 5, 'desc', 'CID')
      await expect(promise)
        .to.emit(trustBridge, 'NFTCreated')
        .withArgs(2, 1, '', owner.address, '', 'CID', '', 'desc')

      await expect(promise)
        .to.emit(trustBridge, 'NFTReviewed')
        .withArgs(1, 2, 1, 5, owner.address, 5, 'desc', 'CID')
    })
  })
})
