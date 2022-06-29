import {ethers, upgrades} from "hardhat";
import * as VestingCon from "../typechain/Vesting";

async function main() {
    const VestingContract = await ethers.getContractFactory("Vesting");
    const vesting = (await upgrades.deployProxy(
        VestingContract,
        ["0xA51c1fc2f0D1a1b8494Ed1FE312d7C3a78Ed91C0"], // contract address of Agreement contract
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
