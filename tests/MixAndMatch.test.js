const { expect } = require('chai')

let owner, buyer, buyer2, controller, hacker, founder // Signer
let ownerAddress, buyerAddress, founderAddress, controllerAddress // Address

describe('MixAndMatch forge - Test', function () {
  let MixAndMatchArtifacts
  let MixAndMatch, nftToolinstance

  before(async function () {

    [owner, buyer, buyer2, controller, hacker] = await ethers.getSigners()

    ownerAddress = await owner.address
    buyerAddress = await buyer.address
    buyer2Address = await buyer2.address
    hackerAddress = await hacker.address
    controllerAddress = await controller.address

    MixAndMatchArtifacts = await ethers.getContractFactory('MixAndMatch')
    MixAndMatch = await MixAndMatchArtifacts.connect(owner).deploy()

    await MixAndMatch.deployed()
    console.log('   MixAndMatch Address :  ', MixAndMatch.address)

    // Deploy mockNFT
    let mockNFTArtifacts = await ethers.getContractFactory('mockNFT')
    nftToolinstance = await mockNFTArtifacts.deploy()
    await nftToolinstance.deployed()

    await nftToolinstance.connect(buyer).superMintTo(20)
  })

  it('Approve', async function () {
    await nftToolinstance
      .connect(buyer)
      .setApprovalForAll(MixAndMatch.address, true)
    let result = await nftToolinstance
      .connect(buyer)
      ['isApprovedForAll(address,address)'](buyerAddress, MixAndMatch.address)
    expect(result).to.equal(true)
  })

  it('TCheck minted', async function () {
    let balance = await nftToolinstance.balanceOf(buyerAddress)
    expect(balance).to.equal(20)
  })

  it('Approve NFT to use Mix and Match.', async function () {
    let result = await MixAndMatch.viewApprovedNFT(nftToolinstance.address)
    expect(result).to.equal(false)
    await MixAndMatch.setApprovedNFT(nftToolinstance.address, true)
    result = await MixAndMatch.viewApprovedNFT(nftToolinstance.address)
    expect(result).to.equal(true)
  })

  it('Test use token.', async function () {
    await MixAndMatch.connect(buyer).mint(
      buyerAddress,
      [nftToolinstance.address, nftToolinstance.address],
      [1, 2],
    )

    let tokenURI = await MixAndMatch.tokenURI(1)
    console.log('1 ' + tokenURI)
    tokenURI = await MixAndMatch.tokenURI(2)
    console.log('2 ' + tokenURI)

    let tokenID = await MixAndMatch.tokenOfOwnerByIndex(buyerAddress, 0)
    //   console.log(tokenID.toString())

    let result = await MixAndMatch.recordOfOwnerByIndex(1, 0)
    // console.log(result)

    result = await MixAndMatch.recordOfOwnerByIndex(1, 1)
    // console.log(result)
    result = await MixAndMatch.recordOfOwnerByIndex(1, 2)
    //   console.log(result)

    await MixAndMatch.connect(buyer).burn(buyer2Address, tokenID.toString())
    let balance = await nftToolinstance.balanceOf(buyer2Address)
    expect(balance).to.equal(2)
  })
})
