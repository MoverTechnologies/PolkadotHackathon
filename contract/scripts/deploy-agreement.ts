import {ethers, upgrades} from "hardhat";
import * as AgreementCon from "../typechain/AgreementContract";

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
    const AgreementContract = await ethers.getContractFactory(
        "AgreementContract"
    );
    const agreement = (await upgrades.deployProxy(
        AgreementContract,
        ["0xA51c1fc2f0D1a1b8494Ed1FE312d7C3a78Ed91C0"], // contract address of PoM contract
        {
            initializer: "initialize",
        }
    )) as AgreementCon.AgreementContract;

    console.log("AgreementContract deployed to:", agreement.address);

    // The owner of the ProxyAdmin can upgrade our contracts
    // await upgrades.admin.transferProxyAdminOwnership(gnosisSafe);
    // console.log("Transferred ownership of ProxyAdmin to:", gnosisSafe);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

// 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
