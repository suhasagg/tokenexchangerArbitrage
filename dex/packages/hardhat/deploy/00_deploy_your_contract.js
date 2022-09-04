// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

const localChainId = "31337";

// const sleep = (ms) =>
//   new Promise((r) =>
//     setTimeout(() => {
//       console.log(`waited for ${(ms / 1000).toFixed(3)} seconds`);
//       r();
//     }, ms)
//   );

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  await deploy("Axies", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    // args: [ "Hello", ethers.utils.parseEther("1.5") ],
    log: true,
  });

  const axies = await ethers.getContract("Axies", deployer);

  await deploy("DEX", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    args: [axies.address],
    log: true,
    waitConfirmations: 5,
  });

  const dex = await ethers.getContract("DEX", deployer);

  // paste in your front-end address here to get 10 axies on deploy:
  await axies.transfer(
    "0x7D2Ce34F48695E29a9c6D923d78d1687e31b535c",
    "" + 100 * 10 ** 18
  );




  // // uncomment to init DEX on deploy:
  console.log(
     "Approving DEX (" + dex.address + ") to take Axies from main account..."
   );
  // // If you are going to the testnet make sure your deployer account has enough ETH
   await axies.approve(dex.address, ethers.utils.parseEther("100"));
   await axies.transfer(
    dex.address,
    "" + 50 * 10 ** 18
  );
   await axies.approve("0x7D2Ce34F48695E29a9c6D923d78d1687e31b535c", ethers.utils.parseEther("100"));
   await axies.transfer(
    "0x7D2Ce34F48695E29a9c6D923d78d1687e31b535c",
    "" + 50 * 10 ** 18
  );
   console.log("INIT exchange...");
   await dex.init(ethers.utils.parseEther("5"), {
   value: ethers.utils.parseEther("5"),
    gasLimit: 200000,
  });
};
module.exports.tags = ["Axies", "DEX"];
