
const hre = require("hardhat");

// Returns the Ether balance of a given address.
async function getBalance(address) {
  const balanceBigInt = await hre.waffle.provider.getBalance(address);
  return hre.ethers.utils.formatEther(balanceBigInt);
}

// Logs the Ether balances for a list of addresses.
async function printBalances(addresses) {
  let idx = 0;
  for (const address of addresses) {
    console.log(`Address ${idx} balance: `, await getBalance(address));
    idx++;
  }
}

const main = async () => {
  try {
    const nftContractFactory = await hre.ethers.getContractFactory(
      "BullBear"
    );
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();

    console.log("Contract deployed to:", nftContract.address);

    // Check balances before the coffee purchase.
    // Get the example accounts we'll be working with.
    const [owner, first, second] = await hre.ethers.getSigners();
    const addresses = [owner.address, first.address, second.address];
    console.log("== start ==");
    await printBalances(addresses);

    await nftContract.connect(first).safeMint(first.address);

    console.log(await nftContract.connect(first).tokenURI(0));

    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();