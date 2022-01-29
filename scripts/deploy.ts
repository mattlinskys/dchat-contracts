import { ethers } from "hardhat";
import colors from "colors";
import nacl from "tweetnacl";

const main = async () => {
  const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory.deploy();
  await factory.deployed();

  console.log("Factory deployed at", colors.blue(factory.address));

  const [signer] = await ethers.getSigners();

  await (
    await factory.createProfile(
      ethers.utils.formatBytes32String("Matt"),
      nacl.box.keyPair.fromSecretKey(
        ethers.utils.arrayify(
          "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
        )
      ).publicKey
    )
  ).wait();

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
