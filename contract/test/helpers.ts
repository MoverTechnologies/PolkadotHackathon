import {ethers} from "hardhat";
import {Token, Vesting, PoM, AgreementContract} from "typechain";

export const deployVestingAndTokenContracts = async (): Promise<{
    tokenContract: Token;
    vestingContract: Vesting;
}> => {
    // Deploy Token contract to use Vesting contract
    const TokenContractFactory = await ethers.getContractFactory("Token");
    const tokenContract = await TokenContractFactory.deploy("New", "NEW");
    await tokenContract.deployed();

    // Deploy Vesting contract
    const VestingContractFactory = await ethers.getContractFactory("Vesting");
    const vestingContract = await VestingContractFactory.deploy();
    await vestingContract.initialize(tokenContract.address);
    await vestingContract.deployed();

    return {tokenContract, vestingContract};
};

export const deployAgreementContract = async (): Promise<AgreementContract> => {
    const AgreementContractFactory = await ethers.getContractFactory(
        "AgreementContract"
    );
    const agreementContract = await AgreementContractFactory.deploy();
    await agreementContract.deployed();

    return agreementContract;
};

export const deployPoMContract = async (): Promise<PoM> => {
    const PoMContract = await ethers.getContractFactory("PoM");
    const pomContract = await PoMContract.deploy();
    await pomContract.deployed();
    return pomContract;
};
