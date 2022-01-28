import { expect } from "chai";
import { ethers } from "hardhat";

describe("Factory", function () {
  it("Should create new Chat", async function () {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();
    await factory.deployed();

    const [signer] = await ethers.getSigners();
    const members = [signer.address];

    await (await factory.createChat(members)).wait();

    const chatAddress = await factory.chats(
      ethers.utils.keccak256(
        ethers.utils.defaultAbiCoder.encode(["address"], members)
      )
    );
    expect(chatAddress).to.not.equal(ethers.constants.AddressZero);

    await expect(factory.createChat(members)).to.be.reverted;
  });

  it("Should create new Profile", async function () {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();
    await factory.deployed();

    const [signer] = await ethers.getSigners();
    const name = "test";

    await (
      await factory.createProfile(
        ethers.utils.formatBytes32String(name),
        ethers.utils.randomBytes(44),
        [],
        []
      )
    ).wait();

    const profileAddres = await factory.profiles(signer.address);
    expect(profileAddres).to.not.equal(ethers.constants.AddressZero);

    const Profile = await ethers.getContractFactory("Profile");
    const profile = await Profile.attach(profileAddres);

    expect(ethers.utils.parseBytes32String(await profile.name())).to.equal(
      name
    );
  });
});
