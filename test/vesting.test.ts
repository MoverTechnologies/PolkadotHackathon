import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";
import {expect} from "chai";
import {ethers, network} from "hardhat";
import {Token, Vesting} from "../typechain/index";

describe("Vesting", () => {
    let VestingContract: Vesting;
    let MockTokenContract: Token;
    let SecondMockTokenContract: Token;
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
        // mint 10000 token to owner
        await MockTokenContract.mint(
            owner.address,
            ethers.utils.parseEther("10000")
        );
        // mockToken approve owner
        const tx = await MockTokenContract.approve(
            owner.address,
            ethers.constants.MaxUint256
        );
        await tx.wait();
        // mockToken approve VestingContract
        const vtx = await MockTokenContract.approve(
            VestingContract.address,
            ethers.constants.MaxUint256
        );
        await vtx.wait();
    });

    describe("addVestingInfo", () => {
        it("should addVestingInfo", async () => {
            const tx = await VestingContract.addVestingInfo(
                "1",
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            await tx.wait();
            // check owner balance
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            // check VestingContract balance
            expect(
                await MockTokenContract.balanceOf(VestingContract.address)
            ).to.equal(ethers.utils.parseEther("1000"));
            // check founderAddress
            await expect(
                (
                    await VestingContract.modInfo_Vesting("1")
                ).founderAddress
            ).to.equal(owner.address);
            // check modAddress
            await expect(
                (
                    await VestingContract.modInfo_Vesting("1")
                ).modAddress
            ).to.equal(spender.address);
            // check amount
            await expect(
                (
                    await VestingContract.modInfo_Vesting("1")
                ).amount
            ).to.equal(ethers.utils.parseEther("1000"));
            // check released
            await expect(
                (
                    await VestingContract.modInfo_Vesting("1")
                ).released
            ).to.equal(0);
            // check jobEndTime
            await expect(
                (
                    await VestingContract.modInfo_Vesting("1")
                ).jobEndTime
            ).to.equal(date + 1800);
            // check duration
            await expect(
                (
                    await VestingContract.modInfo_Vesting("1")
                ).duration
            ).to.equal(3600);
            // check completed
            await expect(
                (
                    await VestingContract.modInfo_Vesting("1")
                ).completed
            ).to.equal(false);
        });
        it("should revert when amount = 0", async () => {
            await expect(
                VestingContract.addVestingInfo(
                    "1",
                    spender.address,
                    0,
                    date + 1800,
                    3600
                )
            ).revertedWith("addVestingInfo: amount must be > 0");
        });
        it("should revert when insufficient token balance", async () => {
            await expect(
                VestingContract.addVestingInfo(
                    "1",
                    spender.address,
                    ethers.utils.parseEther("10001"),
                    date + 1800,
                    3600
                )
            ).revertedWith("addVestingInfo: insufficient token balance");
        });
        it("should revert when jobEndtime < block.timestamp", async () => {
            await expect(
                VestingContract.addVestingInfo(
                    "1",
                    spender.address,
                    ethers.utils.parseEther("1000"),
                    date - 1800,
                    3600
                )
            ).revertedWith(
                "addVestingInfo: jobEndtime must be > block.timestamp"
            );
        });
        it("should revert when duration = 0", async () => {
            await expect(
                VestingContract.addVestingInfo(
                    "1",
                    spender.address,
                    ethers.utils.parseEther("1000"),
                    date + 1800,
                    0
                )
            ).revertedWith("addVestingInfo: duration must be > 0");
        });
    });

    describe("release", () => {
        it("should revert when now < jobEndTime", async () => {
            // addVestingInfo
            await VestingContract.addVestingInfo(
                "1",
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            await expect(VestingContract.release("1")).revertedWith(
                "release: block.timestamp must be > jobEndTime"
            );
        });
        // it("should revert when modAddress not equal msg.sender", async () => {
        //     // // addVestingInfo
        //     await VestingContract.addVestingInfo(
        //         1,
        //         spender.address,
        //         ethers.utils.parseEther("1000"),
        //         date + 1800,
        //         3600
        //     );
        //     expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
        //         ethers.utils.parseEther("9000")
        //     );
        //     // WIP 時間を進めて確認する必要がある
        //     // WIP テスト上の実行者のアドレスを変更して、テストする必要がある
        //     await expect(VestingContract.release(1)).revertedWith(
        //         "release: modAddress must be msg.sender"
        //     );
        // });
    });

    describe("releaseAmount", () => {
        it("should releaseAmount", async () => {
            // addVestingInfo
            await VestingContract.addVestingInfo(
                "1",
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            // WIP 時間を進めて確認する必要がある
            // await network.provider.send("evm_increaseTime", [6000]);
            // console.log(await VestingContract.releaseAmount("1"));
            // await expect(VestingContract.releaseAmount("1")).to.equal(
            //     ethers.utils.parseEther("1000")
            // );
        });
        it("should return 0 when now < jobEndTime", async () => {
            await VestingContract.addVestingInfo(
                "1",
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            expect(await VestingContract.releaseAmount("1")).to.equal(0);
        });
    });

    describe("revoke", () => {
        it("should revoke", async () => {
            // addVestingInfo
            await VestingContract.addVestingInfo(
                "1",
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            // revoke
            const tx = await VestingContract.revoke("1");
            await tx.wait();
            // check owner balance
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("10000")
            );
        });

        it("should revert when msg.sender not equal founderAddress", async () => {
            // addVestingInfo
            await VestingContract.addVestingInfo(
                "1",
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            // WIP テスト上の実行者のアドレスを変更して、テストする必要がある
        });
    });

    describe("setDepoistedToken", () => {
        it("should setDepoistedToken", async () => {
            // second mock token
            const MockTokenContractFactory = await ethers.getContractFactory(
                "Token"
            );
            SecondMockTokenContract = await MockTokenContractFactory.deploy(
                "Test",
                "TEST"
            );
            await SecondMockTokenContract.deployed();
            // change depoistedToken to second mock token
            VestingContract.setDepoistedToken(SecondMockTokenContract.address);
            // check depoistedToken address
            expect(await VestingContract.depositedToken()).to.equal(
                SecondMockTokenContract.address
            );
        });
    });
});
