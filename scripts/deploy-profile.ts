import { ethers } from "hardhat";
import colors from "colors";
import inquirer from "inquirer";
import nacl from "tweetnacl";

const main = async () => {
  const { factoryAddress, signerPrivate, name } = await inquirer.prompt([
    {
      name: "factoryAddress",
      message: "Factory address",
    },
    {
      name: "signerPrivate",
      message: "Signer private address",
      default:
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
    },
    {
      name: "name",
      message: "Profile name",
    },
  ]);
  const signer = new ethers.Wallet(signerPrivate).connect(ethers.provider);
  const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory.attach(factoryAddress).connect(signer);

  await (
    await factory.createProfile(
      ethers.utils.formatBytes32String(name),
      nacl.box.keyPair.fromSecretKey(ethers.utils.arrayify(signerPrivate))
        .publicKey
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
