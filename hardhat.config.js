require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.13",
  networks: {
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/URL",
      accounts: ["METAMASK_PRIVATE_KEY"],
    },
  },
};