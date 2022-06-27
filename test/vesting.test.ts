import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";
import {expect} from "chai";
import {ethers} from "hardhat";
import {AgreementContract, PoM, Token, Vesting} from "../typechain/index";

import {deployAgreementContract, deployPoMContract} from "./helpers";

describe("Vesting", () => {
    let agreementContract: AgreementContract;
    let pomContract: PoM;
    let VestingContract: Vesting;
    let MockTokenContract: Token;
    let SecondMockTokenContract: Token;
    let owner: SignerWithAddress;
    let spender: SignerWithAddress;
    let holder: SignerWithAddress;
    let otherSigners: SignerWithAddress[];
    const bytesParam =
        "0x05416460deb76d57af601be17e777b93592d8d4d4a4096c57876a91c84f4a712";
    const date = Math.floor(new Date().getTime() / 1000);

    beforeEach(async () => {
        // Deploy & initilize PoM contract
        pomContract = await deployPoMContract();
        await pomContract.initialize("PoM", "POM", "BASE_URL");
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

        // Deploy & initialize Agreement contract
        agreementContract = await deployAgreementContract();
        await agreementContract.initialize(
            pomContract.address,
            VestingContract.address
        );

        const agreementSignerAddress =
            await agreementContract.signer.getAddress();

        await VestingContract.setAgreementContractAddress(
            agreementSignerAddress
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
            const tx = await VestingContract.connect(
                agreementContract.signer
            ).addVestingInfo(
                bytesParam,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 5000,
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
                    await VestingContract.modInfoVesting(bytesParam)
                ).founderAddress
            ).to.equal(owner.address);
            // check modAddress
            await expect(
                (
                    await VestingContract.modInfoVesting(bytesParam)
                ).modAddress
            ).to.equal(spender.address);
            // check amount
            await expect(
                (
                    await VestingContract.modInfoVesting(bytesParam)
                ).amount
            ).to.equal(ethers.utils.parseEther("1000"));
            // check released
            await expect(
                (
                    await VestingContract.modInfoVesting(bytesParam)
                ).released
            ).to.equal(0);
            // check jobEndTime
            await expect(
                (
                    await VestingContract.modInfoVesting(bytesParam)
                ).jobEndTime
            ).to.equal(date + 5000);
            // check duration
            await expect(
                (
                    await VestingContract.modInfoVesting(bytesParam)
                ).duration
            ).to.equal(3600);
            // check completed
            await expect(
                (
                    await VestingContract.modInfoVesting(bytesParam)
                ).completed
            ).to.equal(false);
        });
        it("should revert when amount = 0", async () => {
            await expect(
                VestingContract.connect(
                    agreementContract.signer
                ).addVestingInfo(
                    bytesParam,
                    owner.address,
                    spender.address,
                    0,
                    date + 1800,
                    3600
                )
            ).revertedWith("amount must be > 0");
        });
        it("should revert when insufficient token balance", async () => {
            await expect(
                VestingContract.connect(
                    agreementContract.signer
                ).addVestingInfo(
                    bytesParam,
                    owner.address,
                    spender.address,
                    ethers.utils.parseEther("10001"),
                    date + 1800,
                    3600
                )
            ).revertedWith("insufficient token balance");
        });
        it("should revert when jobEndtime < block.timestamp", async () => {
            await expect(
                VestingContract.connect(
                    agreementContract.signer
                ).addVestingInfo(
                    bytesParam,
                    owner.address,
                    spender.address,
                    ethers.utils.parseEther("1000"),
                    date - 10000,
                    3600
                )
            ).revertedWith("jobEndtime must be > now");
        });
        // it("should revert when duration equal 0", async () => {
        //     await expect(
        //         VestingContract.connect(
        //             agreementContract.signer
        //         ).addVestingInfo(
        //             bytesParam,
        //             owner.address,
        //             spender.address,
        //             ethers.utils.parseEther("1000"),
        //             date + 3600,
        //             0
        //         )
        //     ).revertedWith("duration must be > 0");
        // });
    });

    describe("release", () => {
        it("should release", async () => {
            // addVestingInfo
            await VestingContract.connect(
                agreementContract.signer
            ).addVestingInfo(
                bytesParam,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 3600,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );

            await ethers.provider.send("evm_increaseTime", [12000]);
            await ethers.provider.send("evm_mine", []);

            await VestingContract.connect(spender).release(bytesParam);

            // check spender balance
            expect(await MockTokenContract.balanceOf(spender.address)).to.equal(
                ethers.utils.parseEther("1000")
            );

            // 時間戻さないと後のテストがコケる！！
            await ethers.provider.send("evm_increaseTime", [-12000]);
            await ethers.provider.send("evm_mine", []);
        });
        it("should revert when now < jobEndTime", async () => {
            // addVestingInfo
            await VestingContract.connect(
                agreementContract.signer
            ).addVestingInfo(
                bytesParam,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 3600,
                3600
            );
            await expect(
                VestingContract.connect(spender).release(bytesParam)
            ).revertedWith("now must be > jobEndTime");
        });
        it("should revert when modAddress not equal msg.sender", async () => {
            // // addVestingInfo
            await VestingContract.connect(
                agreementContract.signer
            ).addVestingInfo(
                bytesParam,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 3600,
                3600
            );

            // 時間を進めて確認
            await ethers.provider.send("evm_increaseTime", [12000]);
            await ethers.provider.send("evm_mine", []);

            await expect(VestingContract.release(bytesParam)).revertedWith(
                "msg.sender must be modAddress"
            );

            await ethers.provider.send("evm_increaseTime", [-12000]);
            await ethers.provider.send("evm_mine", []);
        });
    });

    describe("releaseAmount", () => {
        it("should releaseAmount", async () => {
            // addVestingInfo
            await VestingContract.connect(
                agreementContract.signer
            ).addVestingInfo(
                bytesParam,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 5000,
                5000
            );

            // 時間を進めて確認
            await ethers.provider.send("evm_increaseTime", [12000]);
            await ethers.provider.send("evm_mine", []);

            // console.log(await VestingContract.releaseAmount(bytesParam));
            expect(await VestingContract.releaseAmount(bytesParam)).to.equal(
                ethers.utils.parseEther("1000")
            );

            // 時間戻さないと後のテストがコケる！！
            await ethers.provider.send("evm_increaseTime", [-12000]);
            await ethers.provider.send("evm_mine", []);
        });
        it("should return 0 when now < jobEndTime", async () => {
            await VestingContract.connect(
                agreementContract.signer
            ).addVestingInfo(
                bytesParam,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 3600,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            expect(await VestingContract.releaseAmount(bytesParam)).to.equal(0);
        });
    });

    describe("revoke", () => {
        it("should revoke", async () => {
            // addVestingInfo
            await VestingContract.connect(
                agreementContract.signer
            ).addVestingInfo(
                bytesParam,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 3600,
                3600
            );
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("9000")
            );
            // revoke
            const tx = await VestingContract.connect(
                agreementContract.signer
            ).revoke(bytesParam);
            await tx.wait();
            // check owner balance
            expect(await MockTokenContract.balanceOf(owner.address)).to.equal(
                ethers.utils.parseEther("10000")
            );
        });

        it("should revert when msg.sender not equal agreementContract", async () => {
            // addVestingInfo
            await VestingContract.connect(
                agreementContract.signer
            ).addVestingInfo(
                bytesParam,
                owner.address,
                spender.address,
                ethers.utils.parseEther("1000"),
                date + 3600,
                3600
            );

            await expect(
                VestingContract.connect(spender).revoke(bytesParam)
            ).revertedWith("Not authorized");
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
