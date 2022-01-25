import { expect } from "chai";
import { ethers } from "hardhat";

describe("Factory", function () {
  it("Should create new Chat contract", async function () {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();
    await factory.deployed();

    const [signer] = await ethers.getSigners();
    const members = [signer.address];

    const tx = await factory.createChat(members);
    await tx.wait();

    const chatAddress = await factory.chats(
      ethers.utils.keccak256(
        ethers.utils.defaultAbiCoder.encode(["address"], members)
      )
    );

    expect(chatAddress).to.not.equal(ethers.constants.AddressZero);

    await expect(factory.createChat(members)).to.be.reverted;
  });
});
