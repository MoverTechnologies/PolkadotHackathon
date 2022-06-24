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

    let agreement: any;

    beforeEach(async () => {
        pomContract = await deployPoMContract();

        await pomContract.initialize("PoM", "POM", "BASE_URL");

        // eslint-disable-next-line @typescript-eslint/no-unused-vars
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

        // For the testing purpose
        // When production contract address should be given
        // To see if this works fine in app, passing tests in agreement.test.ts should prove it
        await pomContract.setAgreementContractAddress(agreementContractAddress);

        [owner, founder, moderator, ...otherSigners] =
            await ethers.getSigners();
        agreement = {
            id: ethers.utils.formatBytes32String("agreementId"),
            daoName: daoNameParam,
            startTime: BigNumber.from(1640592293),
            endTime: BigNumber.from(1640592300),
            isCompleted: false,
            rewardAmount: BigNumber.from(10),
            founder: founder.address,
            moderator: moderator.address,
        };
    });

    // describe("initialize", () => {
    //     it("should initialize", async () => {
    //         await pomContract.initialize("ProofOfModerate", "PoM", "baseURI");
    //         await expect(
    //             await pomContract.hasRole(
    //                 await pomContract.DEFAULT_ADMIN_ROLE(),
    //                 owner.address
    //             )
    //         ).to.be.true;
    //         expect(await pomContract.name()).to.equal("ProofOfModerate");
    //         expect(await pomContract.symbol()).to.equal("PoM");
    //         expect(await pomContract.getIsMintActive()).to.equal(true);
    //     });
    // });

    describe("mintToken", () => {
        it("should mint token", async () => {
            const result = await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, agreement);

            const expected = [
                founder.address,
                1640592293,
                1640592300,
                "0x00000000000000000000000000000064616f4e616d65", // hex value of string "daoName"
                BigNumber.from(10),
                "",
            ];

            await expect(await result).to.emit(pomContract, "MintPoM");

            const proof = await pomContract.getProofDetail(1);

            expect(await pomContract.balanceOf(moderator.address)).to.equal(1);
            expect(proof).to.deep.equal(expected);
        });

        it("should leave review with empty string", async () => {
            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, agreement);

            const proof = await pomContract.getProofDetail(1);
            expect(proof.review).to.equal("");
        });

        it("should increment counter by 1", async () => {
            expect(await pomContract.totalSupply()).to.equal(0);

            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, agreement);

            expect(await pomContract.totalSupply()).to.equal(1);
        });

        it("should revert if proofId already exists", async () => {
            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, agreement);

            await expect(
                pomContract
                    .connect(agreementContract.signer)
                    .mintToken(moderator.address, agreement)
            ).to.be.revertedWith("ProofId exists");
        });

        it("should revert if isMintActive is false", async () => {
            await pomContract.connect(owner).setIsMintActive(false);

            await expect(
                pomContract.mintToken(moderator.address, agreement)
            ).to.be.revertedWith("Mint not active");
        });

        it("should revert if not from Agreement contract", async () => {
            await pomContract.connect(owner).setIsMintActive(false);

            await expect(
                pomContract
                    .connect(otherSigners[0])
                    .mintToken(moderator.address, agreement)
            ).to.be.revertedWith("Mint not active");
        });
    });

    describe("addReview", () => {
        beforeEach(async () => {
            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, agreement);
        });
        it("should add review", async () => {
            const result = await pomContract
                .connect(agreementContract.signer)
                .addReview(agreement.id, "this is review");

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

        it("should revert if not from Agreement contract", async () => {
            await expect(
                pomContract
                    .connect(otherSigners[0])
                    .addReview(agreement.id, "this is review")
            ).to.be.revertedWith("Not authorized");
        });
    });

    describe("burnToken", () => {
        beforeEach(async () => {
            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, agreement);
        });

        it("should burn token", async () => {
            expect(await pomContract.balanceOf(moderator.address)).to.equal(1);

            const result = await pomContract
                .connect(founder)
                .burnToken(agreement.id);

            await expect(await result).to.emit(pomContract, "BurnPoM");

            expect(await pomContract.balanceOf(moderator.address)).to.equal(0);
            await expect(pomContract.getProofDetail(1)).to.be.revertedWith(
                "Proof doesn't exist"
            );
            await expect(pomContract.tokenID(agreement.id)).to.be.revertedWith(
                "Token doesn't exist"
            );
            expect(
                await pomContract.getAllTokenIds(moderator.address)
            ).to.deep.equal([]);
        });

        it("should return token if they have other tokens after one burnt", async () => {
            const secondAgreement = Object.assign({}, agreement);
            secondAgreement.id =
                ethers.utils.formatBytes32String("secondToken");
            // Add another token
            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, secondAgreement);

            expect(await pomContract.balanceOf(moderator.address)).to.equal(2);
            expect(
                await pomContract.getAllTokenIds(moderator.address)
            ).to.deep.equal([BigNumber.from(1), BigNumber.from(2)]);

            const result = await pomContract
                .connect(founder)
                .burnToken(agreement.id);

            await expect(await result).to.emit(pomContract, "BurnPoM");

            const remainedProof = [
                founder.address,
                1640592293, // startTime
                1640592300, // endTime
                "0x00000000000000000000000000000064616f4e616d65", // 22bytes hash of "daoName"
                BigNumber.from(10), // rewardAmount
                "", // review
            ];

            expect(await pomContract.balanceOf(moderator.address)).to.equal(1);
            await expect(pomContract.getProofDetail(1)).to.be.revertedWith(
                "Proof doesn't exist"
            );
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

        it("should decrement count", async () => {
            expect(await pomContract.totalSupply()).to.equal(1);

            await pomContract.connect(founder).burnToken(agreement.id);
            expect(await pomContract.totalSupply()).to.equal(0);
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
                1640592293, // startTime
                1640592300, // endTime
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

        it("should return empty array[]", async () => {
            const expected = [];
            await expect(
                await pomContract.getAllTokenIds(moderator.address)
            ).to.deep.equal(expected);
        });
    });

    describe("tokenID", () => {
        beforeEach(async () => {
            await pomContract
                .connect(agreementContract.signer)
                .mintToken(moderator.address, agreement);
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
            ).to.be.revertedWith("Token doesn't exist");
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
