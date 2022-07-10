import {ethers, upgrades} from "hardhat";
import * as PoMCon from "../typechain/PoM";

async function main() {
    // this is for
    // const gnosisSafe =
    //     process.env.ENV === "prod"
    //         ? "0x8B80762e3b8A56E36a04a8DBF46eBCEF6e19cE3b"
    //         : "0x4BACf63107d0B56D6E0BD00945DFdd0ddfF49c45";

    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());
    // We get the contract to deploy
    const PoMContract = await ethers.getContractFactory("PoM");
    const pom = (await upgrades.deployProxy(
        PoMContract,
        [
            "ProofOfModerate",
            "PoM",
            process.env.ENV === "prod"
                ? "https://www.assetproved.com/public/proved/"
                : "http://localhost:8545/",
        ],
        {
            initializer: "initialize",
        }
    )) as PoMCon.PoM;

    console.log("PoM deployed to:", pom.address);

    // Required only once
    // The owner of the ProxyAdmin can upgrade our contracts
    // await upgrades.admin.transferProxyAdminOwnership(gnosisSafe);
    // console.log("Transferred ownership of ProxyAdmin to:", gnosisSafe);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
// 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
