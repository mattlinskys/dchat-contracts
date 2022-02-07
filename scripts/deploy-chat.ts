import { ethers } from "hardhat";
import colors from "colors";
import inquirer from "inquirer";

const main = async () => {
  const { factoryAddress, signerPrivate, id, members } = await inquirer.prompt([
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
      name: "id",
      message: "Chat id",
    },
    {
      name: "members",
      message: "Members (comma separated)",
    },
  ]);
  const signer = new ethers.Wallet(signerPrivate).connect(ethers.provider);
  const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory.attach(factoryAddress).connect(signer);

  await (
    await factory.createChat(ethers.utils.id(id), members.split(","))
  ).wait();

  const chat = await factory.chats(ethers.utils.id(id));
  console.log("Chat", colors.green(id), "created at", colors.blue(chat));
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
