const main = async (contractName) => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const contractFactory = await hre.ethers.getContractFactory(contractName);
  const contract = await contractFactory.deploy();
  await contract.deployed();

  console.log("Contract deployed to:", contract.address);
  console.log("Contract deployed by:", owner.address);

  let count;
  count = await contract.getTotal();

  let waveTxn = await contract.add();
  await waveTxn.wait();

  count = await contract.getTotal();
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

const contractName = "Counter";
runMain(contractName);
