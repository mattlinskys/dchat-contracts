import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";

describe("Factory", function () {
  const chatId = ethers.utils.id("example-id");
  let factory: Contract;

  it("Should deploy factory", async function () {
    const Factory = await ethers.getContractFactory("Factory");
    factory = await Factory.deploy();
    await factory.deployed();
  });

  it("Should create chat", async function () {
    const [signer] = await ethers.getSigners();
    const members = [signer.address];

    await (await factory.createChat(chatId, members)).wait();

    const chatAddress = await factory.chats(chatId);
    expect(chatAddress).to.not.equal(ethers.constants.AddressZero);
  });

  it("Should revert if id chat is taken", async function () {
    const [signer] = await ethers.getSigners();
    const members = [signer.address];

    await expect(factory.createChat(chatId, members)).to.be.reverted;
  });

  it("Should revert remove function if signer is not chat's owner", async function () {
    const [, signer] = await ethers.getSigners();

    await expect(factory.connect(signer).removeChat(chatId)).to.be.reverted;
  });

  it("Should remove chat", async function () {
    await (await factory.removeChat(chatId)).wait();

    const chatAddress = await factory.chats(chatId);
    expect(chatAddress).to.equal(ethers.constants.AddressZero);
  });

  it("Should create profile", async function () {
    const [signer] = await ethers.getSigners();
    const name = "test";

    await (
      await factory.createProfile(
        ethers.utils.formatBytes32String(name),
        ethers.utils.randomBytes(32)
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

  it("Should revert remove function if signer is not profile's owner", async function () {
    const [, signer] = await ethers.getSigners();
    await expect(factory.connect(signer).removeProfile()).to.be.reverted;
  });

  it("Should remove profile", async function () {
    const [signer] = await ethers.getSigners();

    await (await factory.removeProfile()).wait();

    const profileAddres = await factory.profiles(signer.address);
    expect(profileAddres).to.equal(ethers.constants.AddressZero);
  });
});
