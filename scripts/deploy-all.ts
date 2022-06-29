import {ethers, upgrades} from "hardhat";
import * as PoMCon from "../typechain/PoM";
import * as AgreementCon from "../typechain/AgreementContract";
import * as VestingCon from "../typechain/Vesting";

async function main() {
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

    const AgreementContract = await ethers.getContractFactory(
        "AgreementContract"
    );
    const agreement = (await upgrades.deployProxy(
        AgreementContract,
        [pom.address], // contract address of PoM contract
        {
            initializer: "initialize",
        }
    )) as AgreementCon.AgreementContract;
    console.log("AgreementContract deployed to:", agreement.address);

    const VestingContract = await ethers.getContractFactory("Vesting");
    const vesting = (await upgrades.deployProxy(
        VestingContract,
        [agreement.address], // contract address of Agreement contract
        {
            initializer: "initialize",
        }
    )) as VestingCon.Vesting;
    await vesting.deployed();
    console.log("vestingContract deployed to: " + vesting.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
