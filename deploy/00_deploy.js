require("hardhat-deploy")
require("hardhat-deploy-ethers")

const { networkConfig } = require("../helper-hardhat-config")

const private_key = network.config.accounts[0]
const wallet = new ethers.Wallet(private_key, ethers.provider)

module.exports = async ({ deployments }) => {
    console.log("Wallet Ethereum Address:", wallet.address)
    // const chainId = network.config.chainId
    // const tokensToBeMinted = networkConfig[chainId]["tokensToBeMinted"]

    //deploy the Dual Artist contract
    const DualArtist = await ethers.getContractFactory("DualArtist", wallet)
    console.log("Deploying the DualArtist contract...")
    const dualArtist = await DualArtist.deploy()
    await dualArtist.deployed()
    console.log("DualArtist contract deployed to:", dualArtist.address)

    //deploy the Factory contract
    const DualFactory = await ethers.getContractFactory("DualFactory", wallet)
    console.log("Deploying the Factory contract...")
    const dualFactory = await DualFactory.deploy()
    await dualFactory.deployed()
    console.log("DualFactory deployed to:", dualFactory.address)

    //deploy the Collection contract
    const Collection = await ethers.getContractFactory("Collection", wallet)
    console.log("Deploying the Collection contract...")
    const collection = await Collection.deploy()
    await collection.deployed()
    console.log("Collection deployed to:", collection.address)

    //deploy the Market contract
    const Market = await ethers.getContractFactory("DualMarketplace", wallet)
    console.log("Deploying the Marketplace contract...")
    const market = await Market.deploy()
    await market.deployed()
    console.log("Market deployed to:", market.address)
}
