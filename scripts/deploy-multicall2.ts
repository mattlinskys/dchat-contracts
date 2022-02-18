import { ethers } from "hardhat";
import colors from "colors";

const main = async () => {
  const Multicall2 = await ethers.getContractFactory("Multicall2");
  const multicall = await Multicall2.deploy();
  await multicall.deployed();

  console.log("Multicall2 deployed at", colors.blue(multicall.address));
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
