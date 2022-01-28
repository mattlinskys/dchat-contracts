import { ethers } from "hardhat";
import colors from "colors";

const main = async () => {
  const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory.deploy();
  await factory.deployed();

  console.log("Factory deployed at", colors.blue(factory.address));

  await (
    await factory.createProfile(
      ethers.utils.formatBytes32String("Matt"),
      ethers.utils.randomBytes(44),
      [],
      []
    )
  ).wait();

  const [signer] = await ethers.getSigners();
  const profile = await factory.profiles(signer.address);
  console.log(
    "Profile created at",
    colors.blue(profile),
    "for",
    colors.green(signer.address)
  );
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
