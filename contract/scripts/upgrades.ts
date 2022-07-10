import {ethers, upgrades} from "hardhat";

const VESTING_PROXY_ADDRESS = "0x1D933E3d67a9ED692B027154Bb988a93EeA7DDc6";
const POM_PROXY_ADDRESS = "0x0C21FEa1026A6d529E2DECf5604f55C4D16E813D";
const AGREEMENT_PROXY_ADDRESS = "0xC7896Bf05ceA4d457Cff9FD14456Da2bC224dBb4";

async function main() {
    /*********
     * VESTING CONTRACT
     *********/
    const VestingContract = await ethers.getContractFactory("Vesting");
    const vesting = await upgrades.upgradeProxy(
        VESTING_PROXY_ADDRESS,
        VestingContract
    );
    await vesting.deployed();
    console.log("Vesting contract upgraded to : " + vesting.address);

    /*********
     * POM CONTRACT
     *********/
    const PoMContract = await ethers.getContractFactory("PoM");
    const pom = await upgrades.upgradeProxy(POM_PROXY_ADDRESS, PoMContract);
    console.log("PoM upgraded to:", pom.address);

    /*********
     * AGREEMENT CONTRACT
     *********/
    const AgreementContract = await ethers.getContractFactory(
        "AgreementContract"
    );
    const agreement = await upgrades.upgradeProxy(
        AGREEMENT_PROXY_ADDRESS,
        AgreementContract
    );
    console.log("Agreement contract upgraded to:", agreement.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
