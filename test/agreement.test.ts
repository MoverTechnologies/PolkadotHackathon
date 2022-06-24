import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";
import {AgreementContract, PoM, Vesting, Token} from "../typechain";
import {expect} from "chai";
import {BigNumber} from "ethers";
import {ethers, network} from "hardhat";
import {
    deployAgreementContract,
    deployPoMContract,
    deployVestingAndTokenContracts,
} from "./helpers";

const daoNameParam = ethers.utils.zeroPad(
    ethers.utils.toUtf8Bytes("daoName"),
    22
);

const date = Math.floor(new Date().getTime() / 1000);

describe("AgreementContract", function () {
    let agreementContract: AgreementContract;
    let vestingContract: Vesting;
    let tokenContract: Token;
    let pomContract: PoM;
    let owner: SignerWithAddress;
    let founder: SignerWithAddress;
    let moderator: SignerWithAddress;
    let otherSigners: SignerWithAddress[];

    let agreementId;

    // WARNING: THIS METHOD HEAVILY RELIES ON VARIABLES DEFINED ABOVE AND THIS SCOPE
    const setUp = async () => {
        // Deploy & initilize PoM contract
        pomContract = await deployPoMContract();
        await pomContract.initialize("PoM", "POM", "BASE_URL");

        // Deploy token and vesting contracts
        const contracts = await deployVestingAndTokenContracts();
        tokenContract = contracts.tokenContract;
        vestingContract = contracts.vestingContract;

        // Deploy & initialize Agreement contract
        agreementContract = await deployAgreementContract();
        await agreementContract.initialize(
            pomContract.address,
            vestingContract.address
        );

        /**
         * Setting up necessary data
         */
        await tokenContract.mint(
            founder.address,
            ethers.utils.parseEther("10000")
        );
        const tx = await tokenContract
            .connect(founder)
            .approve(vestingContract.address, ethers.utils.parseEther("10000"));
        await tx.wait();

        await pomContract.setAgreementContractAddress(
            agreementContract.address
        );
        // Set block time
        const latestBlock = await ethers.provider.getBlock("latest");
        await network.provider.send("evm_setNextBlockTimestamp", [
            latestBlock.timestamp + 100,
        ]);

        const hash = ethers.utils.solidityPack(
            ["address", "address", "uint256", "bytes32"],
            [
                founder.address,
                moderator.address,
                latestBlock.timestamp + 100,
                latestBlock.hash,
            ]
        );

        agreementId = ethers.utils.keccak256(hash);
    };

    beforeEach(async () => {
        [owner, founder, moderator, ...otherSigners] =
            await ethers.getSigners();
    });

    describe("initialize", () => {
        it("should set admin role to owner", async () => {
            const contracts = await deployVestingAndTokenContracts();
            vestingContract = contracts.vestingContract;
            pomContract = await deployPoMContract();
            await pomContract.initialize("PoM", "POM", "BASE_URL");

            agreementContract = await deployAgreementContract();
            await agreementContract.initialize(
                pomContract.address,
                vestingContract.address
            );
            await expect(
                await agreementContract.hasRole(
                    await agreementContract.DEFAULT_ADMIN_ROLE(),
                    owner.address
                )
            ).to.be.true;
        });
    });

    describe("createAgreement", () => {
        beforeEach(async () => {
            await setUp();
        });
        it("should create agreement", async () => {
            const latestBlock = await ethers.provider.getBlock("latest");
            await network.provider.send("evm_setNextBlockTimestamp", [
                latestBlock.timestamp + 100,
            ]);

            const result = await agreementContract
                .connect(founder)
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );

            const hash = ethers.utils.solidityPack(
                ["address", "address", "uint256", "bytes32"],
                [
                    founder.address,
                    moderator.address,
                    latestBlock.timestamp + 100,
                    latestBlock.hash,
                ]
            );

            const id = ethers.utils.keccak256(hash);

            const expected = [
                id,
                "0x00000000000000000000000000000064616f4e616d65", // 22bytes of string "daoName"
                1640592293,
                date + 2000,
                false,
                ethers.utils.parseEther("10"),
                founder.address,
                moderator.address,
            ];

            await expect(await result).to.emit(
                agreementContract,
                "CreateAgreement"
            );

            const proof = await agreementContract.agreements(id);
            expect(proof).to.deep.equal(expected);
        });

        it("should increase token balance by 1", async () => {
            await agreementContract
                .connect(founder)
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );
            const balance = await pomContract.balanceOf(moderator.address);
            expect(balance).to.be.equal(1);
        });

        it("should increase totalAgreements by 1", async () => {
            let totalAgreements = await agreementContract.getTotalAgreements();
            expect(totalAgreements).to.be.equal(0);

            await agreementContract
                .connect(founder)
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );
            totalAgreements = await agreementContract.getTotalAgreements();
            expect(totalAgreements).to.be.equal(1);
        });

        it("should increase id count by 1 for both founder and moderator", async () => {
            let founderIds = await agreementContract.getAllIds(founder.address);
            let moderatorIds = await agreementContract.getAllIds(
                moderator.address
            );
            expect(founderIds.length).to.be.equal(0);
            expect(moderatorIds.length).to.be.equal(0);

            await agreementContract
                .connect(founder)
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );
            founderIds = await agreementContract.getAllIds(founder.address);
            moderatorIds = await agreementContract.getAllIds(moderator.address);
            expect(founderIds.length).to.be.equal(1);
            expect(moderatorIds.length).to.be.equal(1);
        });
    });

    describe("updateAgreement", () => {
        beforeEach(async () => {
            await setUp();
            await agreementContract
                .connect(founder)
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );
        });
        it("should update agreement", async () => {
            const result = await agreementContract
                .connect(founder)
                .updateAgreement(
                    agreementId,
                    1640592294,
                    1640592301,
                    ethers.utils.parseEther("12")
                );

            const expected = [
                agreementId,
                "0x00000000000000000000000000000064616f4e616d65", // 22bytes of string "daoName"
                1640592294,
                1640592301,
                false,
                ethers.utils.parseEther("12"),
                founder.address,
                moderator.address,
            ];

            await expect(await result).to.emit(
                agreementContract,
                "UpdateAgreement"
            );

            const proof = await agreementContract.agreements(agreementId);

            expect(proof).deep.equal(expected);
        });

        it("should update agreement only rewardAmount property", async () => {
            await agreementContract.connect(founder).updateAgreement(
                agreementId,
                0, // startTime property
                0, // endTime property
                12
            );

            const expected = {
                startTime: BigNumber.from(1640592293),
                endTime: BigNumber.from(date + 2000),
                rewardAmount: BigNumber.from(12),
            };

            const proof = await agreementContract.agreements(agreementId);

            expect(await proof.startTime).equal(expected.startTime);
            expect(await proof.endTime).equal(expected.endTime);
            expect(await proof.rewardAmount).equal(expected.rewardAmount);
        });

        it("should update agreement only startTime and endTime properties", async () => {
            let proof = await agreementContract.agreements(agreementId);

            expect(proof.startTime).equal(BigNumber.from(1640592293));
            expect(proof.endTime).equal(BigNumber.from(date + 2000));
            expect(proof.rewardAmount).equal(ethers.utils.parseEther("10"));

            await agreementContract.connect(founder).updateAgreement(
                agreementId,
                1640592295,
                1640592304,
                0 // rewardAmount property
            );

            const expected = {
                startTime: BigNumber.from(1640592295),
                endTime: BigNumber.from(1640592304),
                rewardAmount: ethers.utils.parseEther("10"),
            };

            proof = await agreementContract.agreements(agreementId);

            expect(await proof.startTime).equal(expected.startTime);
            expect(await proof.endTime).equal(expected.endTime);
            expect(await proof.rewardAmount).equal(expected.rewardAmount);
        });

        it("should revert if called by not the founder", async () => {
            await expect(
                agreementContract
                    .connect(otherSigners[0])
                    .updateAgreement(agreementId, 1640592294, 1640592301, 12)
            ).to.be.revertedWith("Not authorized");
        });

        it("should revert if agreement does not exists", async () => {
            await expect(
                agreementContract.connect(founder).updateAgreement(
                    ethers.utils.formatBytes32String("agreementId"), // generate random agreementId
                    1640592294,
                    1640592301,
                    12
                )
            ).to.be.revertedWith("Not authorized");
        });
    });

    describe("completeAgreement", () => {
        beforeEach(async () => {
            await setUp();
            await agreementContract
                .connect(founder)
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );
            await ethers.provider.send("evm_increaseTime", [12000]);
            await ethers.provider.send("evm_mine", []);
        });
        afterEach(async () => {
            await ethers.provider.send("evm_increaseTime", [-12000]);
            await ethers.provider.send("evm_mine", []);
        });
        it("should complete agreement", async () => {
            const result = await agreementContract
                .connect(founder)
                .completeAgreement(agreementId, "this is review");
            await expect(await result).to.emit(
                agreementContract,
                "CompleteAgreement"
            );

            const expected = [
                agreementId,
                "0x00000000000000000000000000000064616f4e616d65", // 22bytes of string "daoName"
                1640592293,
                date + 2000,
                true, // isCompleted property
                ethers.utils.parseEther("10"),
                founder.address,
                moderator.address,
            ];

            const proof = await agreementContract.agreements(agreementId);
            await expect(proof).to.deep.equal(expected);
        });

        it("should revert if the currenct time has not passed agreement endTime", async () => {
            // Set time much later than current block time
            await agreementContract.connect(founder).updateAgreement(
                agreementId,
                0,
                2524628634, // 2050/1/1 5:43:54
                0
            );

            await expect(
                agreementContract
                    .connect(founder)
                    .completeAgreement(agreementId, "this is review")
            ).to.be.revertedWith("Contract not ended");
        });
    });

    describe("getAllAgreements", () => {
        beforeEach(async () => {
            await setUp();
            await agreementContract
                .connect(founder)
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );
            await tokenContract.mint(
                otherSigners[0].address,
                ethers.utils.parseEther("10000")
            );
            const tx = await tokenContract
                .connect(otherSigners[0])
                .approve(
                    vestingContract.address,
                    ethers.utils.parseEther("10000")
                );
            await tx.wait();

            await agreementContract
                .connect(otherSigners[0])
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );
        });

        it("should return two agreements for moderator", async () => {
            const result = await agreementContract
                .connect(moderator)
                .getAllAgreements(moderator.address);
            await expect(result.length).equal(2);
        });

        it("should return 1 agreement for founder and another founder", async () => {
            const founderResult1 = await agreementContract
                .connect(founder)
                .getAllAgreements(founder.address);
            await expect(founderResult1.length).equal(1);
            const founderResult2 = await agreementContract
                .connect(otherSigners[0])
                .getAllAgreements(otherSigners[0].address);
            await expect(founderResult2.length).equal(1);
        });

        it("should return 0 agreement if address does not hold agreements", async () => {
            const result = await agreementContract
                .connect(otherSigners[1])
                .getAllAgreements(otherSigners[1].address);
            await expect(result.length).equal(0);
        });
    });

    describe("getAllIds", () => {
        beforeEach(async () => {
            await setUp();

            await agreementContract
                .connect(founder)
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );

            await tokenContract.mint(
                otherSigners[0].address,
                ethers.utils.parseEther("10000")
            );
            await tokenContract
                .connect(otherSigners[0])
                .approve(
                    vestingContract.address,
                    ethers.utils.parseEther("10000")
                );

            await agreementContract
                .connect(otherSigners[0])
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 2000,
                    ethers.utils.parseEther("10"),
                    5184000
                );
        });

        it("should return two ids for moderator", async () => {
            const result = await agreementContract
                .connect(moderator)
                .getAllIds(moderator.address);
            await expect(result.length).equal(2);
        });

        it("should return 1 id for founder and another founder", async () => {
            const founderResult1 = await agreementContract
                .connect(founder)
                .getAllIds(founder.address);
            await expect(founderResult1.length).equal(1);
            const founderResult2 = await agreementContract
                .connect(otherSigners[0])
                .getAllIds(otherSigners[0].address);
            await expect(founderResult2.length).equal(1);
        });

        it("should return 0 id if address does not hold agreements", async () => {
            const result = await agreementContract
                .connect(otherSigners[1])
                .getAllIds(otherSigners[1].address);
            await expect(result.length).equal(0);
        });
    });

    describe("getTotalAgreements", () => {
        beforeEach(async () => {
            await setUp();

            await tokenContract.mint(
                otherSigners[0].address,
                ethers.utils.parseEther("10000")
            );
            await tokenContract
                .connect(otherSigners[0])
                .approve(
                    vestingContract.address,
                    ethers.utils.parseEther("10000")
                );
        });

        it("should return 2 after 2 agreements are made", async () => {
            await agreementContract
                .connect(founder)
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 12000,
                    ethers.utils.parseEther("10"),
                    5184000
                );

            await agreementContract
                .connect(otherSigners[0])
                .createAgreement(
                    moderator.address,
                    daoNameParam,
                    1640592293,
                    date + 12000,
                    ethers.utils.parseEther("10"),
                    5184000
                );
            const result = await agreementContract
                .connect(moderator)
                .getTotalAgreements();
            await expect(result).equal(2);
        });

        it("should return 0 if no agreements are made", async () => {
            const result = await agreementContract
                .connect(moderator)
                .getTotalAgreements();
            await expect(result).equal(0);
        });
    });

    describe("forked methods", () => {
        const adminErrorMessage = (address: string, role: string) =>
            `AccessControl: account ${address.toLowerCase()} is missing role ${role}`;
        describe("grantAuth", () => {
            beforeEach(async () => {
                await setUp();
            });
            it("should set AUTH_ROLE", async () => {
                await agreementContract.grantAuth(otherSigners[0].address);

                await expect(
                    await agreementContract.hasRole(
                        await agreementContract.AUTH_ROLE(),
                        otherSigners[0].address
                    )
                ).to.be.true;
            });
            it("should revert if not admin", async () => {
                // https://github.com/ethers-io/ethers.js/issues/1449
                // transaction signer should be updated by reconnecting
                await expect(
                    agreementContract
                        .connect(otherSigners[3])
                        .grantAuth(otherSigners[4].address)
                ).to.be.revertedWith(
                    adminErrorMessage(
                        otherSigners[3].address,
                        await agreementContract.DEFAULT_ADMIN_ROLE()
                    )
                );
            });
        });

        describe("revokeAuth", () => {
            beforeEach(async () => {
                await setUp();
                await agreementContract.grantRole(
                    await agreementContract.AUTH_ROLE(),
                    otherSigners[3].address
                );
            });
            it("should revoke AUTH_ROLE", async () => {
                await agreementContract.revokeAuth(otherSigners[3].address);

                await expect(
                    await agreementContract.hasRole(
                        await agreementContract.AUTH_ROLE(),
                        otherSigners[3].address
                    )
                ).to.be.false;
            });

            it("should revert if not admin", async () => {
                await expect(
                    agreementContract
                        .connect(otherSigners[3])
                        .grantAuth(otherSigners[4].address)
                ).to.be.revertedWith(
                    adminErrorMessage(
                        otherSigners[3].address,
                        await agreementContract.DEFAULT_ADMIN_ROLE()
                    )
                );
            });
        });
    });
});
