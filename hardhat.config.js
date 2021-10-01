require("@nomiclabs/hardhat-waffle");
require("hardhat-deploy");
require("@nomiclabs/hardhat-etherscan");
require("solidity-coverage");
require("hardhat-tracer");
require('hardhat-contract-sizer');
require("hardhat-gas-reporter");
require('hardhat-docgen');
const { config } = require("dotenv");
config();

const INFURA_ID = process.env.INFURA_API_KEY;
const OWNER_PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

module.exports = {
  
  contractSizer: {
    runOnCompile: true,
    disambiguatePaths: false,
  },
  networks: {
    forking: {
      url: "https://eth-mainnet.alchemyapi.io/v2/<key>"
    },
    hardhat: {
      throwOnTransactionFailures: true,
      throwOnCallFailures: true,
      allowUnlimitedContractSize: true,
    },
    localhost: {
      url: 'http://localhost:8545',
      chainId: 1337
    },
    ganache: {
      url: 'http://localhost:7545',
      chainId: 1337
    },
    rinkeby: {
      allowUnlimitedContractSize: true,
     // url:'http://nowlive.ro/rinkeby',
      url: `https://rinkeby.infura.io/v3/${INFURA_ID}`,
      accounts: [OWNER_PRIVATE_KEY],
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${INFURA_ID}`,
      accounts: [OWNER_PRIVATE_KEY],
    },
    matic: {
			url: `https://polygon-mainnet.infura.io/v3/${INFURA_ID}`,
			accounts: [OWNER_PRIVATE_KEY],
			gasLimit: 2000000
		},
		mumbai: {
			url: `https://rpc-mumbai.matic.today`,
			accounts: [OWNER_PRIVATE_KEY],
			gasLimit: 2000000
		},
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: ETHERSCAN_API_KEY,
  },
  solidity: {
    version: "0.8.0",
    compilers: [
      { version: "0.8.0", settings: {
        optimizer: {
          enabled: true,
        },
      } },
      { version: "0.7.5",settings: {
        optimizer: {
          enabled: true,
        },
      } 
    }
    ],
  },
  paths: {
    sources: "./contracts",
    tests: "./tests",
    cache: "./cache",
    artifacts: "./artifacts"
  }
};
