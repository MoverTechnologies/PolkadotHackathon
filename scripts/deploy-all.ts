import {ethers, upgrades} from "hardhat";
import * as PoMCon from "../typechain/PoM";
import * as AgreementCon from "../typechain/AgreementContract";
import * as VestingCon from "../typechain/Vesting";

async function main() {
    // pom contract
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

    // mock token contract
    const Token = await ethers.getContractFactory("Token");
    const nw = await Token.deploy("New", "NEW");
    await nw.deployed();
    console.log("new deployed to:", nw.address);

    // vesting contract
    const VestingContract = await ethers.getContractFactory("Vesting");
    const vesting = (await upgrades.deployProxy(
        VestingContract,
        [nw.address], // contract address of new token contract
        {
            initializer: "initialize",
        }
    )) as VestingCon.Vesting;
    await vesting.deployed();
    console.log("vestingContract deployed to: " + vesting.address);

    // agreement contract
    const AgreementContract = await ethers.getContractFactory(
        "AgreementContract"
    );
    const agreement = (await upgrades.deployProxy(
        AgreementContract,
        [pom.address, vesting.address],
        {
            initializer: "initialize",
        }
    )) as AgreementCon.AgreementContract;
    console.log("AgreementContract deployed to:", agreement.address);

    // setup
    await pom.setAgreementContractAddress(agreement.address);
    await vesting.setAgreementContractAddress(agreement.address);
    // mockToken approve VestingContract
    const vtx = await nw.approve(vesting.address, ethers.constants.MaxUint256);
    await vtx.wait();

    // await nw.mint("XXXXXXXXXXXXXXXXXXXXXXXX", ethers.utils.parseEther("10000"));
    // const tx = await nw.approve(vesting.address, ethers.constants.MaxUint256);
    // await tx.wait();
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
