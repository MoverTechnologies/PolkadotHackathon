import {ethers} from "hardhat";

async function main() {
    const tokenAddress = "";
    const VestingContract = await ethers.getContractFactory("Vesting");
    const vesting = await VestingContract.deploy(tokenAddress);
    await vesting.deployed();
    console.log("vestingContract deployed to: " + vesting.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
