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
    const bytes32 =
        "0x05416460deb76d57af601be17e777b93592d8d4d4a4096c57876a91c84f4a712";
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
        VestingContract = await VestingContractFactory.deploy();
        await VestingContract.initialize(MockTokenContract.address);

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
                bytes32,
                owner.address,
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
                    await VestingContract.modInfo_Vesting(bytes32)
                ).founderAddress
            ).to.equal(owner.address);
            // check modAddress
            await expect(
                (
                    await VestingContract.modInfo_Vesting(bytes32)
                ).modAddress
            ).to.equal(spender.address);
            // check amount
            await expect(
                (
                    await VestingContract.modInfo_Vesting(bytes32)
                ).amount
            ).to.equal(ethers.utils.parseEther("1000"));
            // check released
            await expect(
                (
                    await VestingContract.modInfo_Vesting(bytes32)
                ).released
            ).to.equal(0);
            // check jobEndTime
            await expect(
                (
                    await VestingContract.modInfo_Vesting(bytes32)
                ).jobEndTime
            ).to.equal(date + 1800);
            // check duration
            await expect(
                (
                    await VestingContract.modInfo_Vesting(bytes32)
                ).duration
            ).to.equal(3600);
            // check completed
            await expect(
                (
                    await VestingContract.modInfo_Vesting(bytes32)
                ).completed
            ).to.equal(false);
        });
        it("should revert when amount = 0", async () => {
            await expect(
                VestingContract.addVestingInfo(
                    bytes32,
                    owner.address,
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
                    bytes32,
                    owner.address,
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
                    bytes32,
                    owner.address,
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
                    bytes32,
                    owner.address,
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
                bytes32,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            await expect(VestingContract.release(bytes32)).revertedWith(
                "release: block.timestamp must be > jobEndTime"
            );
        });
        // it("should revert when modAddress not equal msg.sender", async () => {
        //     // // addVestingInfo
        //     await VestingContract.addVestingInfo(
        //         1,
        //         owner.address,
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
                bytes32,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );

            // 時間を進めて確認
            await ethers.provider.send("evm_increaseTime", [12000]);
            await ethers.provider.send("evm_mine", []);

            // console.log(await VestingContract.releaseAmount(bytes32));
            expect(await VestingContract.releaseAmount(bytes32)).to.equal(
                ethers.utils.parseEther("1000")
            );

            // 時間戻さないと後のテストがコケる！！
            await ethers.provider.send("evm_increaseTime", [-12000]);
            await ethers.provider.send("evm_mine", []);
        });
        it("should return 0 when now < jobEndTime", async () => {
            await VestingContract.addVestingInfo(
                bytes32,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            expect(await VestingContract.releaseAmount(bytes32)).to.equal(0);
        });
    });

    describe("revoke", () => {
        it("should revoke", async () => {
            // addVestingInfo
            await VestingContract.addVestingInfo(
                bytes32,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 1800,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            // revoke
            const tx = await VestingContract.revoke(bytes32);
            await tx.wait();
            // check owner balance
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("10000")
            );
        });

        it("should revert when msg.sender not equal founderAddress", async () => {
            // addVestingInfo
            await VestingContract.addVestingInfo(
                bytes32,
                owner.address,
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
            await VestingContract.setDepoistedToken(
                SecondMockTokenContract.address
            );
            // check depoistedToken address
            expect(await VestingContract.depositedToken()).to.equal(
                SecondMockTokenContract.address
            );
        });
    });
});
