import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";
import {expect} from "chai";
import {BigNumber} from "ethers";
import {ethers} from "hardhat";
import {AgreementContract, PoM, Vesting} from "../typechain";
import {
    deployAgreementContract,
    deployPoMContract,
    deployVestingAndTokenContracts,
} from "./helpers";

const daoNameParam = ethers.utils.zeroPad(
    ethers.utils.toUtf8Bytes("daoName"),
    22
);

describe("PoM", () => {
    let pomContract: PoM;
    let agreementContract: AgreementContract;
    let vestingContract: Vesting;
    let owner: SignerWithAddress;
    let founder: SignerWithAddress;
    let moderator: SignerWithAddress;
    let otherSigners: SignerWithAddress[];

    let startTime = Math.floor(Date.now() / 1000);
    let endTime = Math.floor(Date.now() / 1000);

    let agreement: any;

    beforeEach(async () => {
        pomContract = await deployPoMContract();

        await pomContract.initialize("ProofOfModerate", "POM", "BASE_URL");

        const contracts = await deployVestingAndTokenContracts();
        vestingContract = contracts.vestingContract;

        // Deploy & initialize Agreement contract
        agreementContract = await deployAgreementContract();
        await agreementContract.initialize(
            pomContract.address,
            vestingContract.address
        );

        await pomContract.setAgreementContractAddress(
            agreementContract.address
        );

        const agreementContractAddress =
            await agreementContract.signer.getAddress();

        // For the testing purpose contract signer address is set
        // When production, contract address should be given
        await pomContract.setAgreementContractAddress(agreementContractAddress);

        [owner, founder, moderator, ...otherSigners] =
            await ethers.getSigners();

        const latestBlock = await ethers.provider.getBlock("latest");
        startTime = latestBlock.timestamp + 100;
        endTime = latestBlock.timestamp + 120;

        agreement = {
            id: ethers.utils.formatBytes32String("agreementId"),
            daoName: daoNameParam,
            startTime: BigNumber.from(startTime),
            endTime: BigNumber.from(endTime),
            isCompleted: false,
            rewardAmount: BigNumber.from(10),
            founder: founder.address,
            moderator: moderator.address,
        };
    });

    describe("initialize", () => {
        it("should initialize", async () => {
            // Initialized in beforeEach
            await expect(
                await pomContract.hasRole(
                    await pomContract.DEFAULT_ADMIN_ROLE(),
                    owner.address
                )
            ).to.be.true;
            expect(await pomContract.name()).to.equal("ProofOfModerate");
            expect(await pomContract.symbol()).to.equal("POM");
            expect(await pomContract.paused()).to.equal(false);
        });
    });

    describe("mintToken", () => {
        it("should mint token", async () => {
            const result = await pomContract.mintToken(
                moderator.address,
                agreement
            );

            await expect(await result).to.emit(pomContract, "Attest");

            expect(await pomContract.balanceOf(moderator.address)).to.equal(1);

            const expected = [
                founder.address,
                startTime,
                endTime,
                "0x00000000000000000000000000000064616f4e616d65", // hex value of string "daoName"
                BigNumber.from(10),
                "",
            ];
            const proof = await pomContract.getProofDetail(1);
            expect(proof).to.deep.equal(expected);
        });

        it("should increment counter by 1", async () => {
            expect(await pomContract.totalSupply()).to.equal(0);

            await pomContract.mintToken(moderator.address, agreement);

            expect(await pomContract.totalSupply()).to.equal(1);
        });

        it("should revert if paused", async () => {
            await pomContract.connect(owner).pause();

            await expect(
                pomContract.mintToken(moderator.address, agreement)
            ).to.be.revertedWith("Pausable: paused");
        });

        it("should revert if from an invalid caller", async () => {
            await expect(
                pomContract
                    .connect(otherSigners[0])
                    .mintToken(moderator.address, agreement)
            ).to.be.revertedWith("Invalid caller");
        });

        it("should revert if mint to zero address", async () => {
            await expect(
                pomContract
                    .connect(agreementContract.signer)
                    .mintToken(ethers.constants.AddressZero, agreement)
            ).to.be.revertedWith("Mint to the zero address");
        });

        it("should revert if proofId already exists", async () => {
            await pomContract.mintToken(moderator.address, agreement);

            await expect(
                pomContract.mintToken(moderator.address, agreement)
            ).to.be.revertedWith("ProofId exists");
        });
    });

    describe("addReview", () => {
        beforeEach(async () => {
            await pomContract.mintToken(moderator.address, agreement);
        });
        it("should add review", async () => {
            const result = await pomContract.addReview(
                agreement.id,
                "this is review"
            );

            await expect(await result).to.emit(pomContract, "ModifiyPoM");

            const proof = await pomContract.getProofDetail(1);

            expect(proof.review).to.equal("this is review");
        });

        it("should NOT increment count", async () => {
            expect(await pomContract.totalSupply()).to.equal(1);

            await pomContract
                .connect(agreementContract.signer)
                .addReview(agreement.id, "this is review");
            expect(await pomContract.totalSupply()).to.equal(1);
        });

        it("should revert if from an invalid caller", async () => {
            await expect(
                pomContract
                    .connect(otherSigners[0])
                    .addReview(agreement.id, "this is review")
            ).to.be.revertedWith("Invalid caller");
        });

        it("should revert if token does not exist", async () => {
            await expect(
                pomContract.addReview(
                    ethers.utils.formatBytes32String("randomAgreemendId"),
                    "this is review"
                )
            ).to.be.revertedWith("ERC4973: invalid token ID");
        });
    });

    describe("updateProof", () => {
        beforeEach(async () => {
            await pomContract.mintToken(moderator.address, agreement);
        });
        it("should update proof info", async () => {
            let proof = await pomContract.getProofDetail(1);

            expect(proof.startTime).equal(agreement.startTime);
            expect(proof.endTime).equal(agreement.endTime);
            expect(proof.rewardAmount).equal(agreement.rewardAmount);

            const now = Math.floor(Date.now() / 1000);

            const newAgreement = Object.assign({}, agreement);
            newAgreement.startTime = now + 100;
            newAgreement.endTime = now + 120;
            newAgreement.rewardAmount = agreement.rewardAmount + 100;

            const result = await pomContract.updateProof(newAgreement);

            await expect(await result).to.emit(pomContract, "ModifiyPoM");

            proof = await pomContract.getProofDetail(1);
            expect(proof.startTime).equal(newAgreement.startTime);
            expect(proof.endTime).equal(newAgreement.endTime);
            expect(proof.rewardAmount).equal(newAgreement.rewardAmount);
        });

        it("should NOT update fields that are not changed", async () => {
            let proof = await pomContract.getProofDetail(1);

            expect(proof.startTime).equal(agreement.startTime);
            expect(proof.endTime).equal(agreement.endTime);
            expect(proof.rewardAmount).equal(agreement.rewardAmount);

            const now = Math.floor(Date.now() / 1000);

            const newAgreement = Object.assign({}, agreement);
            newAgreement.startTime = now + 100;

            await pomContract.updateProof(newAgreement);

            proof = await pomContract.getProofDetail(1);
            expect(proof.startTime).equal(newAgreement.startTime);
            expect(proof.endTime).equal(agreement.endTime); // not updated
            expect(proof.rewardAmount).equal(agreement.rewardAmount); // not updated
        });

        it("should revert if from an invalid caller", async () => {
            await expect(
                pomContract.connect(otherSigners[0]).updateProof(agreement)
            ).to.be.revertedWith("Invalid caller");
        });

        it("should revert if token does not exist", async () => {
            const newAgreement = Object.assign({}, agreement);
            newAgreement.id =
                ethers.utils.formatBytes32String("randomAgreemendId");
            await expect(
                pomContract.updateProof(newAgreement)
            ).to.be.revertedWith("ERC4973: invalid token ID");
        });
    });

    describe("burnToken", () => {
        beforeEach(async () => {
            await pomContract.mintToken(moderator.address, agreement);
        });

        it("should burn token", async () => {
            expect(await pomContract.balanceOf(moderator.address)).to.equal(1);

            const result = await pomContract
                .connect(founder)
                .burnToken(agreement.id);

            await expect(await result).to.emit(pomContract, "Revoke");

            expect(await pomContract.balanceOf(moderator.address)).to.equal(0);
            await expect(pomContract.getProofDetail(1)).to.be.revertedWith(
                "Proof doesn't exist"
            );
            await expect(pomContract.tokenID(agreement.id)).to.be.revertedWith(
                "Invalid proofId"
            );
            await expect(
                pomContract.getAllTokenIds(moderator.address)
            ).to.be.revertedWith("No tokens");
        });

        it("should return token if they have other tokens after one burnt", async () => {
            // Add another token
            const secondAgreement = Object.assign({}, agreement);
            secondAgreement.id =
                ethers.utils.formatBytes32String("secondAgreementId");
            await pomContract.mintToken(moderator.address, secondAgreement);

            expect(await pomContract.balanceOf(moderator.address)).to.equal(2);
            expect(
                await pomContract.getAllTokenIds(moderator.address)
            ).to.deep.equal([BigNumber.from(1), BigNumber.from(2)]);

            const result = await pomContract
                .connect(founder)
                .burnToken(agreement.id);

            expect(result).to.emit(pomContract, "Revoke");
            expect(await pomContract.balanceOf(moderator.address)).to.equal(1);

            // Check token related to agreement1
            await expect(pomContract.getProofDetail(1)).to.be.revertedWith(
                "Proof doesn't exist"
            );
            await expect(pomContract.tokenID(agreement.id)).to.be.revertedWith(
                "Invalid proofId"
            );

            // Check token related to second agreement
            const remainedProof = [
                founder.address,
                startTime, // startTime
                endTime, // endTime
                "0x00000000000000000000000000000064616f4e616d65", // 22bytes hash of "daoName"
                BigNumber.from(10), // rewardAmount
                "", // review
            ];
            expect(await pomContract.getProofDetail(2)).to.deep.equal(
                remainedProof
            );
            expect(await pomContract.tokenID(secondAgreement.id)).to.equal(2);
            expect(
                (await pomContract.getAllTokenIds(moderator.address)).length
            ).to.equal(1);
            expect(
                await pomContract.getAllTokenIds(moderator.address)
            ).to.deep.equal([BigNumber.from(2)]);
        });

        it("should decrement total count", async () => {
            expect(await pomContract.totalSupply()).to.equal(1);

            await pomContract.connect(founder).burnToken(agreement.id);
            expect(await pomContract.totalSupply()).to.equal(0);
        });

        it("should revert if paused", async () => {
            await pomContract.pause();
            await expect(
                pomContract.connect(founder).burnToken(agreement.id)
            ).to.be.revertedWith("Pausable: paused");
        });

        it("should revert if not founder", async () => {
            await expect(
                pomContract.connect(otherSigners[0]).burnToken(agreement.id)
            ).to.be.revertedWith("Not authorized");
        });
    });

    describe("getProofDetail", () => {
        beforeEach(async () => {
            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, agreement);
        });

        it("should return proofDetail", async () => {
            const expected = [
                founder.address,
                startTime, // startTime
                endTime, // endTime
                "0x00000000000000000000000000000064616f4e616d65", // 22bytes hash of "daoName"
                BigNumber.from(10), // rewardAmount
                "", // review
            ];
            await expect(await pomContract.getProofDetail(1)).to.deep.equal(
                expected
            );
        });

        it("should revert if proof doesn't exist", async () => {
            await expect(pomContract.getProofDetail(100)).to.be.revertedWith(
                "Proof doesn't exist"
            );
        });
    });

    describe("getAllTokenIds", () => {
        it("should return tokenIds", async () => {
            const secondAgreement = Object.assign({}, agreement);
            secondAgreement.id =
                ethers.utils.formatBytes32String("secondToken");
            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, agreement);
            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, secondAgreement);

            const expected = [BigNumber.from(1), BigNumber.from(2)];
            await expect(
                await pomContract.getAllTokenIds(moderator.address)
            ).to.deep.equal(expected);
        });

        it("should revert if holder has no tokens", async () => {
            await expect(
                pomContract.getAllTokenIds(moderator.address)
            ).to.be.revertedWith("No tokens");
        });
    });

    describe("tokenID", () => {
        beforeEach(async () => {
            await pomContract.mintToken(moderator.address, agreement);
        });

        it("should return tokenID", async () => {
            const tokenID = await pomContract.tokenID(agreement.id);
            expect(tokenID).to.equal(1);
        });

        it("should revert when tokenID does not exist", async () => {
            await expect(
                pomContract.tokenID(
                    ethers.utils.formatBytes32String("randomAgreementId")
                )
            ).to.be.revertedWith("Invalid proofId");
        });
    });

    describe("getAgreementContractAddress", () => {
        it("should return agreementContractAddress", async () => {
            await pomContract.setAgreementContractAddress(
                otherSigners[0].address
            );
            expect(await pomContract.getAgreementContractAddress()).to.equal(
                otherSigners[0].address
            );
        });
    });

    describe("setAgreementContractAddress", () => {
        it("should change agreementContractAddress", async () => {
            expect(await pomContract.getAgreementContractAddress()).to.equal(
                owner.address
            );

            await pomContract.setAgreementContractAddress(
                otherSigners[0].address
            );
            expect(await pomContract.getAgreementContractAddress()).to.equal(
                otherSigners[0].address
            );
        });

        it("should revert if not admin", async () => {
            await expect(
                pomContract
                    .connect(otherSigners[0])
                    .setAgreementContractAddress(otherSigners[0].address)
            ).to.be.reverted;
        });
    });

    describe("pause", () => {
        it("should pause", async () => {
            expect(await pomContract.paused()).to.equal(false);
            await pomContract.connect(owner).pause();
            expect(await pomContract.paused()).to.equal(true);
        });

        it("should revert if not admin", async () => {
            await expect(pomContract.connect(otherSigners[0]).pause()).to.be
                .reverted;
        });

        it("should revert if already paused", async () => {
            pomContract.connect(owner).pause();
            await expect(pomContract.connect(owner).pause()).to.be.revertedWith(
                "Pausable: paused"
            );
        });
    });

    describe("unpause", () => {
        beforeEach(async () => {
            await pomContract.pause();
        });
        it("should unpause", async () => {
            expect(await pomContract.paused()).to.equal(true);
            await pomContract.unpause();
            expect(await pomContract.paused()).to.equal(false);
        });

        it("should revert if not admin", async () => {
            await expect(pomContract.connect(otherSigners[0]).unpause()).to.be
                .reverted;
        });

        it("should revert if already unpaused", async () => {
            await pomContract.connect(owner).unpause();
            await expect(
                pomContract.connect(owner).unpause()
            ).to.be.revertedWith("Pausable: not paused");
        });
    });

    /**********
     * To test method "findIndexOfTokenId" needs to change to public
     **********/
    // describe("findIndexOfTokenId", () => {
    //     it("should return index 0 and 1", async () => {
    //         const numArray: number[] = [1, 2, 3];
    //         await expect(
    //             await pomContract.findIndexOfTokenId(numArray, 1)
    //         ).to.equal(0);
    //         await expect(
    //             await pomContract.findIndexOfTokenId(numArray, 2)
    //         ).to.equal(1);
    //     });
    //     it("should return -1", async () => {
    //         const numArray: number[] = [1, 2];
    //         await expect(
    //             await pomContract.findIndexOfTokenId(numArray, 5)
    //         ).to.equal(-1);
    //     });
    // });

    /**********
     * Will test if methods are needed
     **********/
    // describe("tokenURI", () => {
    //     beforeEach(async () => {
    //         await pomContract.mintToken(moderator.address, agreement);
    //         await pomContract.setBaseURI("http://baseurl.com");
    //     });

    //     it("should return concat tokenURI", async () => {
    //         const tokenURI = await pomContract.tokenURI(1);
    //         expect(tokenURI).to.equal("https://proved.xyz/proofnft/someId");
    //     });

    //     it("should return baseUrl when no tokenId matches", async () => {
    //         const tokenURI = await pomContract.tokenURI(100);
    //         expect(tokenURI).to.equal("https://proved.xyz/proofnft/");
    //     });
    // });

    // describe("setBaseURI", () => {
    //     beforeEach(async () => {
    //         await pomContract.initialize(
    //             "Pow",
    //             "PowSymbol",
    //             "https://proved.xyz/proofnft/"
    //         );
    //         await pomContract.mintToken(moderator.address, "someId");
    //     });

    //     it("should update baseURI", async () => {
    //         await pomContract.setBaseURI("https://proved.xyz/updated/");
    //         const tokenURI = await pomContract.tokenURI(1);
    //         expect(tokenURI).to.equal("https://proved.xyz/updated/someId");
    //     });

    //     it("should revert if not admin", async () => {
    //         await expect(
    //             pomContract
    //                 .connect(spender)
    //                 .setBaseURI("https://proved.xyz/updated/")
    //         ).to.be.revertedWith("Not authorized");
    //     });
    // });
});
