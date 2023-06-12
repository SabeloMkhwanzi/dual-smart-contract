const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Marketplace", function () {
  it("Should deploy the marketplace", async function () {
    const Marketplace = await ethers.getContractFactory("DualMarketplace");
    const marketplace = await Marketplace.deploy();
    await marketplace.deployed();

    const owner = marketplace.getOwner();

    // wait until the transaction is mined
    await owner.wait();
    console.log(owner);

    // expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});