import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";
import {expect} from "chai";
import {ethers} from "hardhat";
import {Token, Vesting} from "../typechain";

describe("Vesting", () => {
    let VestingContract: Vesting;
    let MockTokenContract: Token;
    let owner: SignerWithAddress;
    let spender: SignerWithAddress;
    let holder: SignerWithAddress;
    let otherSigners: SignerWithAddress[];
    const date = Math.floor(new Date().getTime() / 1000);

    beforeEach(async () => {
        // set mock token
        const MockTokenContractFactory = await ethers.getContractFactory(
            "Token"
        );
        MockTokenContract = await MockTokenContractFactory.deploy("New", "NEW");
        await MockTokenContract.deployed();
        // set vesting contract
        const VestingContractFactory = await ethers.getContractFactory(
            "Vesting"
        );
        VestingContract = await VestingContractFactory.deploy(
            MockTokenContract.address
        );
        await VestingContract.deployed();
        [owner, spender, holder, ...otherSigners] = await ethers.getSigners();
        // setUp
        await MockTokenContract.mint(
            owner.address,
            ethers.utils.parseEther("10000")
        );
        const tx = await MockTokenContract.approve(
            owner.address,
            ethers.constants.MaxUint256
        );
        await tx.wait();
        const vtx = await MockTokenContract.approve(
            VestingContract.address,
            ethers.constants.MaxUint256
        );
        await vtx.wait();
    });

    describe("initialize", () => {
        it("should initialize", async () => {
            //
        });
    });

    describe("addVestingInfo", () => {
        it("should addVestingInfo", async () => {
            await VestingContract.addVestingInfo(
                1,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
        });
    });

    describe("release", () => {
        //
    });

    describe("releaseAmount", () => {
        //
    });

    describe("revoke", () => {
        //
    });
});
