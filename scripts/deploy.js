// npx hardhat node # localhost
// CONTRACT_NAME=Counter npx hardhat run scripts/deploy.js --network rinkeby

const main = async (contractName) => {
  const [deployer] = await hre.ethers.getSigners();
  const accountBalance = await deployer.getBalance();

  console.log("Deploying contracts with account: ", deployer.address);
  console.log("Account balance: ", accountBalance.toString());

  const contractFactory = await hre.ethers.getContractFactory(contractName);
  const contract = await contractFactory.deploy();
  await contract.deployed();

  console.log("Contract address: ", contract.address);
};

const runMain = async (contractName) => {
  try {
    await main(contractName);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

const contractName = process.env.CONTRACT_NAME || "Counter";
runMain(contractName);
