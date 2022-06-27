import * as dotenv from "dotenv";

import {HardhatUserConfig} from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "@openzeppelin/hardhat-upgrades";
import "hardhat-contract-sizer";
import "hardhat-abi-exporter";

// This adds support for typescript paths mappings
import "tsconfig-paths/register";
import {privateKey} from "./private.json";
dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//     const accounts = await hre.ethers.getSigners();

//     for (const account of accounts) {
//         console.log(account.address);
//     }
// });

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
const config: HardhatUserConfig = {
    solidity: {
        version: "0.8.4",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
    networks: {
        rinkeby: {
            url: process.env.ALCHEMY_RINKEBY_URL || "",
            accounts:
                process.env.PRIVATE_KEY !== undefined
                    ? [process.env.PRIVATE_KEY]
                    : [],
        },
        mumbai: {
            url: "https://speedy-nodes-nyc.moralis.io/542a14cec1890a25e44d9fb6/polygon/mumbai",
            chainId: 80001,
            accounts: [privateKey],
        },
        matic: {
            url: process.env.POLYGON_MAINNET_URL || "",
            accounts:
                process.env.PRIVATE_KEY !== undefined
                    ? [process.env.PRIVATE_KEY]
                    : [],
        },
        astar: {
            url: "https://evm.astar.network/",
            chainId: 592,
            accounts: [privateKey],
        },
        shibuya: {
            url: "https://evm.shibuya.astar.network",
            chainId: 81,
            accounts:
                process.env.PRIVATE_KEY !== undefined
                    ? [process.env.PRIVATE_KEY]
                    : [],
        },
    },
    gasReporter: {
        enabled: process.env.REPORT_GAS !== undefined,
        currency: "USD",
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_API_KEY,
    },
    abiExporter: {
        clear: true,
        pretty: true,
    },
    /**
     *  Remove comment out below to see contract size when compiled
     * */
    // contractSizer: {
    //     runOnCompile: true,
    //     strict: true,
    // },
};

export default config;
