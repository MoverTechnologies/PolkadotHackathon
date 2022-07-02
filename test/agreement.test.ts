// import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/signers";
// import {AgreementContract, PoM, Vesting, Token} from "../typechain";
// import {expect} from "chai";
// import {BigNumber} from "ethers";
// import {ethers, network} from "hardhat";
// import {
//     deployAgreementContract,
//     deployPoMContract,
//     deployVestingAndTokenContracts,
// } from "./helpers";

// const DAO_NAME_PARAM = ethers.utils.zeroPad(
//     ethers.utils.toUtf8Bytes("daoName"),
//     22
// );

// const ETHER_10 = ethers.utils.parseEther("10");

// describe("AgreementContract", function () {
//     let agreementContract: AgreementContract;
//     let vestingContract: Vesting;
//     let tokenContract: Token;
//     let pomContract: PoM;
//     let owner: SignerWithAddress;
//     let founder: SignerWithAddress;
//     let moderator: SignerWithAddress;
//     let otherSigners: SignerWithAddress[];

//     let startTime = Math.floor(Date.now() / 1000);
//     let endTime = Math.floor(Date.now() / 1000);

//     let agreementId;

//     // WARNING: THIS METHOD HEAVILY RELIES ON VARIABLES DEFINED ABOVE AND THIS SCOPE
//     const setUp = async () => {
//         // Deploy & initilize PoM contract
//         pomContract = await deployPoMContract();
//         await pomContract.initialize("PoM", "POM", "BASE_URL");

//         // Deploy token and vesting contracts
//         const contracts = await deployVestingAndTokenContracts();
//         tokenContract = contracts.tokenContract;
//         vestingContract = contracts.vestingContract;

//         // Deploy & initialize Agreement contract
//         agreementContract = await deployAgreementContract();
//         await agreementContract.initialize(
//             pomContract.address,
//             vestingContract.address
//         );

//         /**
//          * Setting up necessary data
//          */
//         await tokenContract.mint(
//             founder.address,
//             ethers.utils.parseEther("10000")
//         );
//         const tx = await tokenContract
//             .connect(founder)
//             .approve(vestingContract.address, ethers.utils.parseEther("10000"));
//         await tx.wait();

//         await pomContract.setAgreementContractAddress(
//             agreementContract.address
//         );
//         await vestingContract.setAgreementContractAddress(
//             agreementContract.address
//         );

//         // Set block time
//         const latestBlock = await ethers.provider.getBlock("latest");
//         await network.provider.send("evm_setNextBlockTimestamp", [
//             latestBlock.timestamp + 100,
//         ]);

//         // Create agreement id based on above block time and other info
//         const hash = ethers.utils.solidityPack(
//             ["address", "address", "uint256", "bytes32"],
//             [
//                 founder.address,
//                 moderator.address,
//                 latestBlock.timestamp + 100,
//                 latestBlock.hash,
//             ]
//         );
//         agreementId = ethers.utils.keccak256(hash);

//         startTime = latestBlock.timestamp + 110;
//         endTime = latestBlock.timestamp + 120;
//     };

//     beforeEach(async () => {
//         [owner, founder, moderator, ...otherSigners] =
//             await ethers.getSigners();
//     });

//     describe("initialize", () => {
//         it("should set admin role to owner", async () => {
//             const contracts = await deployVestingAndTokenContracts();
//             vestingContract = contracts.vestingContract;
//             pomContract = await deployPoMContract();
//             await pomContract.initialize("PoM", "POM", "BASE_URL");

//             agreementContract = await deployAgreementContract();
//             await agreementContract.initialize(
//                 pomContract.address,
//                 vestingContract.address
//             );
//             await expect(
//                 await agreementContract.hasRole(
//                     await agreementContract.DEFAULT_ADMIN_ROLE(),
//                     owner.address
//                 )
//             ).to.be.true;
//         });
//     });

//     describe("createAgreement", () => {
//         beforeEach(async () => {
//             await setUp();
//         });
//         it("should create agreement", async () => {
//             const latestBlock = await ethers.provider.getBlock("latest");
//             await network.provider.send("evm_setNextBlockTimestamp", [
//                 latestBlock.timestamp + 100,
//             ]);

//             const result = await agreementContract
//                 .connect(founder)
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ETHER_10,
//                     5184000
//                 );

//             const hash = ethers.utils.solidityPack(
//                 ["address", "address", "uint256", "bytes32"],
//                 [
//                     founder.address,
//                     moderator.address,
//                     latestBlock.timestamp + 100,
//                     latestBlock.hash,
//                 ]
//             );

//             const id = ethers.utils.keccak256(hash);

//             const expected = [
//                 id,
//                 "0x00000000000000000000000000000064616f4e616d65", // 22bytes of string "daoName"
//                 startTime,
//                 endTime,
//                 false,
//                 ethers.utils.parseEther("10"),
//                 founder.address,
//                 moderator.address,
//             ];

//             await expect(await result).to.emit(
//                 agreementContract,
//                 "CreateAgreement"
//             );

//             const proof = await agreementContract.getAgreementDetail(id);
//             expect(proof).to.deep.equal(expected);
//         });

//         it("should increase token balance by 1", async () => {
//             await agreementContract
//                 .connect(founder)
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );
//             const balance = await pomContract.balanceOf(moderator.address);
//             expect(balance).to.be.equal(1);
//         });

//         it("should increase totalAgreements by 1", async () => {
//             let totalAgreements = await agreementContract.getTotalAgreements();
//             expect(totalAgreements).to.be.equal(0);

//             await agreementContract
//                 .connect(founder)
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );
//             totalAgreements = await agreementContract.getTotalAgreements();
//             expect(totalAgreements).to.be.equal(1);
//         });

//         it("should increase id count by 1 for both founder and moderator", async () => {
//             // Reverts when holders have no agreementIds
//             await expect(agreementContract.getAllIds(founder.address)).to.be
//                 .reverted;
//             await expect(agreementContract.getAllIds(moderator.address)).to.be
//                 .reverted;

//             await agreementContract
//                 .connect(founder)
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );
//             const founderIds = await agreementContract.getAllIds(
//                 founder.address
//             );
//             const moderatorIds = await agreementContract.getAllIds(
//                 moderator.address
//             );
//             expect(founderIds.length).to.be.equal(1);
//             expect(moderatorIds.length).to.be.equal(1);
//         });

//         it("should revert if it is to address zero", async () => {
//             const latestBlock = await ethers.provider.getBlock("latest");
//             await network.provider.send("evm_setNextBlockTimestamp", [
//                 latestBlock.timestamp + 100,
//             ]);
//             // await ethers.provider.incr
//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .createAgreement(
//                         ethers.constants.AddressZero,
//                         DAO_NAME_PARAM,
//                         startTime,
//                         endTime,
//                         ETHER_10,
//                         5184000
//                     )
//             ).to.be.revertedWith("moderator is the zero address");
//         });

//         it("should revert if current time is after startTime", async () => {
//             await expect(
//                 agreementContract.connect(founder).createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     1625140800, // 2021/7/1 12:00:00
//                     endTime,
//                     ETHER_10,
//                     5184000
//                 )
//             ).to.be.revertedWith("startTime must be after now");
//         });

//         it("should revert if startTime is after endTime", async () => {
//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .createAgreement(
//                         moderator.address,
//                         DAO_NAME_PARAM,
//                         endTime,
//                         startTime,
//                         ETHER_10,
//                         5184000
//                     )
//             ).to.be.revertedWith("endTime must be after startTime");
//         });

//         it("should revert if rewardAmount is 0", async () => {
//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .createAgreement(
//                         moderator.address,
//                         DAO_NAME_PARAM,
//                         startTime,
//                         endTime,
//                         0,
//                         5184000
//                     )
//             ).to.be.revertedWith("rewardAmount must be > 0");
//         });
//     });

//     describe("updateAgreement", () => {
//         beforeEach(async () => {
//             await setUp();
//             await agreementContract
//                 .connect(founder)
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );
//         });
//         it("should update agreement", async () => {
//             const result = await agreementContract
//                 .connect(founder)
//                 .updateAgreement(
//                     agreementId,
//                     startTime + 100,
//                     endTime + 100,
//                     ethers.utils.parseEther("12")
//                 );

//             const expected = [
//                 agreementId,
//                 "0x00000000000000000000000000000064616f4e616d65", // 22bytes of string "daoName"
//                 startTime + 100,
//                 endTime + 100,
//                 false,
//                 ethers.utils.parseEther("12"),
//                 founder.address,
//                 moderator.address,
//             ];

//             await expect(await result).to.emit(
//                 agreementContract,
//                 "UpdateAgreement"
//             );

//             const proof = await agreementContract.getAgreementDetail(
//                 agreementId
//             );

//             expect(proof).deep.equal(expected);
//         });

//         it("should update agreement only rewardAmount property", async () => {
//             await agreementContract.connect(founder).updateAgreement(
//                 agreementId,
//                 0, // startTime param
//                 0, // endTime param
//                 12
//             );

//             const expected = {
//                 startTime: BigNumber.from(startTime),
//                 endTime: BigNumber.from(endTime),
//                 rewardAmount: BigNumber.from(12),
//             };

//             const proof = await agreementContract.getAgreementDetail(
//                 agreementId
//             );

//             expect(await proof.startTime).equal(expected.startTime);
//             expect(await proof.endTime).equal(expected.endTime);
//             expect(await proof.rewardAmount).equal(expected.rewardAmount);
//         });

//         it("should update agreement only startTime and endTime properties", async () => {
//             let proof = await agreementContract.getAgreementDetail(agreementId);

//             expect(proof.startTime).equal(BigNumber.from(startTime));
//             expect(proof.endTime).equal(BigNumber.from(endTime));
//             expect(proof.rewardAmount).equal(ethers.utils.parseEther("10"));

//             await agreementContract.connect(founder).updateAgreement(
//                 agreementId,
//                 startTime + 100,
//                 endTime + 100,
//                 0 // rewardAmount property
//             );

//             proof = await agreementContract.getAgreementDetail(agreementId);

//             expect(proof.startTime).equal(startTime + 100);
//             expect(proof.endTime).equal(endTime + 100);
//             expect(proof.rewardAmount).equal(ethers.utils.parseEther("10"));
//         });

//         it("should call updateVestingInfo", async () => {
//             // Check the value in Vesting info to check updateVestingInfo is called
//             let result = await vestingContract.modInfoVesting(agreementId);
//             expect(result[2]).to.equal(ethers.utils.parseEther("10"));
//             expect(result[4]).to.equal(endTime);

//             await agreementContract
//                 .connect(founder)
//                 .updateAgreement(
//                     agreementId,
//                     startTime + 100,
//                     endTime + 100,
//                     ethers.utils.parseEther("12")
//                 );

//             result = await vestingContract.modInfoVesting(agreementId);

//             expect(result[2]).to.equal(ethers.utils.parseEther("12"));
//             expect(result[4]).to.equal(endTime + 100);
//         });

//         it("should revert if paused", async () => {
//             await agreementContract.connect(owner).pause();
//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .updateAgreement(agreementId, 0, 0, 12)
//             ).to.be.revertedWith("Pausable: paused");
//         });

//         it("should revert if called by not the founder", async () => {
//             await expect(
//                 agreementContract
//                     .connect(otherSigners[0])
//                     .updateAgreement(agreementId, 1640592294, 1640592301, 12)
//             ).to.be.revertedWith("Not authorized");
//         });

//         it("should revert if agreement already completed", async () => {
//             // move the time forward to complete agreement
//             await ethers.provider.send("evm_increaseTime", [26784000]);
//             await ethers.provider.send("evm_mine", []);

//             await agreementContract
//                 .connect(founder)
//                 .completeAgreement(agreementId, "THIS IS REVIEW");

//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .updateAgreement(agreementId, 1640592294, 1640592301, 12)
//             ).to.be.revertedWith("Agreement already completed");

//             // Move the time back to normal
//             await ethers.provider.send("evm_increaseTime", [-26784000]);
//             await ethers.provider.send("evm_mine", []);
//         });

//         it("should revert if agreement does not exist", async () => {
//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .updateAgreement(
//                         ethers.utils.keccak256(
//                             ethers.utils.solidityPack(
//                                 ["string"],
//                                 ["randomAgreemendId"]
//                             )
//                         ),
//                         1640592294,
//                         1640592301,
//                         12
//                     )
//             ).to.be.revertedWith("Not authorized");
//         });

//         it("should revert if start time is set before current time", async () => {
//             // move the time forward
//             await ethers.provider.send("evm_increaseTime", [2678400]);
//             await ethers.provider.send("evm_mine", []);

//             await expect(
//                 agreementContract.connect(founder).updateAgreement(
//                     agreementId,
//                     startTime + 100,
//                     0, // 2022/6/1 12:00:00
//                     0
//                 )
//             ).to.be.revertedWith("startTime must be after now");

//             // Move the time back to normal
//             await ethers.provider.send("evm_increaseTime", [-2678400]);
//             await ethers.provider.send("evm_mine", []);
//         });

//         it("should revert if startTime is before currenct block time", async () => {
//             await expect(
//                 agreementContract.connect(founder).updateAgreement(
//                     agreementId,
//                     1625140800, // 2021/7/1 12:00:00
//                     endTime + 100,
//                     12
//                 )
//             ).to.be.revertedWith("startTime must be after now");
//         });

//         it("should revert if starTime is after endTime already set", async () => {
//             await expect(
//                 agreementContract.connect(founder).updateAgreement(
//                     agreementId,
//                     1688212800, // 2023/7/1 12:00:00
//                     0,
//                     0
//                 )
//             ).to.be.revertedWith("startTime must be before endTime set");
//         });

//         it("should revert if endTime is before startTime param", async () => {
//             await expect(
//                 agreementContract.connect(founder).updateAgreement(
//                     agreementId,
//                     1688212800, // 2023/7/1 12:00:00
//                     1685620800, // 2023/6/1 12:00:00
//                     0
//                 )
//             ).to.be.revertedWith("startTime must be before endTime");
//         });

//         it("should revert if endTime is before startTime already set", async () => {
//             await expect(
//                 agreementContract.connect(founder).updateAgreement(
//                     agreementId,
//                     0,
//                     1654084800, // 2022/6/1 12:00:00
//                     0
//                 )
//             ).to.be.revertedWith("endTime must be after startTime");
//         });
//     });

//     describe("completeAgreement", () => {
//         beforeEach(async () => {
//             await setUp();
//             await agreementContract
//                 .connect(founder)
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );
//             await ethers.provider.send("evm_increaseTime", [3199178]);
//             await ethers.provider.send("evm_mine", []);
//         });
//         afterEach(async () => {
//             await ethers.provider.send("evm_increaseTime", [-3199178]);
//             await ethers.provider.send("evm_mine", []);
//         });
//         it("should complete agreement", async () => {
//             const result = await agreementContract
//                 .connect(founder)
//                 .completeAgreement(agreementId, "this is review");
//             await expect(await result).to.emit(
//                 agreementContract,
//                 "CompleteAgreement"
//             );

//             const expected = [
//                 agreementId,
//                 "0x00000000000000000000000000000064616f4e616d65", // 22bytes of string "daoName"
//                 startTime,
//                 endTime,
//                 true, // isCompleted property
//                 ethers.utils.parseEther("10"),
//                 founder.address,
//                 moderator.address,
//             ];

//             const proof = await agreementContract.getAgreementDetail(
//                 agreementId
//             );
//             await expect(proof).to.deep.equal(expected);
//         });

//         it("should revert if the currenct time has not passed agreement endTime", async () => {
//             // Set time much later than current block time
//             await agreementContract.connect(founder).updateAgreement(
//                 agreementId,
//                 0,
//                 2524628634, // 2050/1/1 5:43:54
//                 0
//             );

//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .completeAgreement(agreementId, "this is review")
//             ).to.be.revertedWith("Contract not ended");
//         });

//         it("should revert if agreement has already completed", async () => {
//             // Set time much later than current block time
//             await agreementContract
//                 .connect(founder)
//                 .completeAgreement(agreementId, "this is review");

//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .completeAgreement(agreementId, "this is review")
//             ).to.be.revertedWith("Agreement already completed");
//         });
//     });

//     describe("getAllAgreements", () => {
//         beforeEach(async () => {
//             await setUp();
//             await agreementContract
//                 .connect(founder)
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );
//             await tokenContract.mint(
//                 otherSigners[0].address,
//                 ethers.utils.parseEther("10000")
//             );
//             const tx = await tokenContract
//                 .connect(otherSigners[0])
//                 .approve(
//                     vestingContract.address,
//                     ethers.utils.parseEther("10000")
//                 );
//             await tx.wait();

//             await agreementContract
//                 .connect(otherSigners[0])
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("12"),
//                     5184000
//                 );
//         });

//         it("should return two agreements for moderator", async () => {
//             const result = await agreementContract
//                 .connect(moderator)
//                 .getAllAgreements(moderator.address);
//             expect(result.length).equal(2);

//             const expected = [
//                 agreementId,
//                 "0x00000000000000000000000000000064616f4e616d65", // 22bytes of string "daoName"
//                 startTime,
//                 endTime,
//                 false, // isCompleted property
//                 ethers.utils.parseEther("10"),
//                 founder.address,
//                 moderator.address,
//             ];

//             expect(result[0]).to.deep.equal(expected);
//             expect(result[1].founder).to.equal(otherSigners[0].address);
//         });

//         it("should return 1 agreement for each founder", async () => {
//             const founderResult1 = await agreementContract
//                 .connect(founder)
//                 .getAllAgreements(founder.address);
//             await expect(founderResult1.length).equal(1);
//             const founderResult2 = await agreementContract
//                 .connect(otherSigners[0])
//                 .getAllAgreements(otherSigners[0].address);
//             await expect(founderResult2.length).equal(1);
//         });

//         it("should revert if address does not hold agreements", async () => {
//             await expect(
//                 agreementContract
//                     .connect(otherSigners[1])
//                     .getAllAgreements(otherSigners[1].address)
//             ).to.be.revertedWith("Agreement not exists");
//         });
//     });

//     describe("getAllIds", () => {
//         beforeEach(async () => {
//             await setUp();

//             await agreementContract
//                 .connect(founder)
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );

//             await tokenContract.mint(
//                 otherSigners[0].address,
//                 ethers.utils.parseEther("10000")
//             );
//             await tokenContract
//                 .connect(otherSigners[0])
//                 .approve(
//                     vestingContract.address,
//                     ethers.utils.parseEther("10000")
//                 );

//             await agreementContract
//                 .connect(otherSigners[0])
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );
//         });

//         it("should return two ids for moderator", async () => {
//             const result = await agreementContract
//                 .connect(moderator)
//                 .getAllIds(moderator.address);
//             expect(result.length).equal(2);
//         });

//         it("should return 1 id for founder and another founder", async () => {
//             const founderResult1 = await agreementContract
//                 .connect(founder)
//                 .getAllIds(founder.address);
//             await expect(founderResult1.length).equal(1);
//             const founderResult2 = await agreementContract
//                 .connect(otherSigners[0])
//                 .getAllIds(otherSigners[0].address);
//             expect(founderResult2.length).equal(1);
//         });

//         it("should reverts if address does not hold agreements", async () => {
//             await expect(
//                 agreementContract
//                     .connect(otherSigners[1])
//                     .getAllIds(otherSigners[1].address)
//             ).to.be.revertedWith("Agreement not exists");
//         });
//     });

//     describe("getTotalAgreements", () => {
//         beforeEach(async () => {
//             await setUp();

//             await tokenContract.mint(
//                 otherSigners[0].address,
//                 ethers.utils.parseEther("10000")
//             );
//             await tokenContract
//                 .connect(otherSigners[0])
//                 .approve(
//                     vestingContract.address,
//                     ethers.utils.parseEther("10000")
//                 );
//         });

//         it("should return 2 after 2 agreements are created", async () => {
//             await agreementContract
//                 .connect(founder)
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );

//             await agreementContract
//                 .connect(otherSigners[0])
//                 .createAgreement(
//                     moderator.address,
//                     DAO_NAME_PARAM,
//                     startTime,
//                     endTime,
//                     ethers.utils.parseEther("10"),
//                     5184000
//                 );
//             const result = await agreementContract
//                 .connect(moderator)
//                 .getTotalAgreements();
//             expect(result).equal(2);
//         });

//         it("should return 0 if no agreements are created", async () => {
//             const result = await agreementContract
//                 .connect(moderator)
//                 .getTotalAgreements();
//             expect(result).equal(0);
//         });
//     });

//     describe("pause", () => {
//         beforeEach(async () => {
//             await setUp();
//         });

//         it("should not create agreement", async () => {
//             await agreementContract.connect(owner).pause();
//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .createAgreement(
//                         moderator.address,
//                         DAO_NAME_PARAM,
//                         startTime,
//                         endTime,
//                         ethers.utils.parseEther("10"),
//                         5184000
//                     )
//             ).to.be.revertedWith("Pausable: paused");
//         });

//         it("should revert if not admin", async () => {
//             await expect(agreementContract.connect(otherSigners[0]).pause()).to
//                 .be.reverted;
//         });

//         it("should revert if already paused", async () => {
//             agreementContract.connect(owner).pause();
//             await expect(
//                 agreementContract.connect(owner).pause()
//             ).to.be.revertedWith("Pausable: paused");
//         });
//     });

//     describe("unpause", () => {
//         beforeEach(async () => {
//             await setUp();
//             await agreementContract.connect(owner).pause();
//         });

//         it("should create agreement", async () => {
//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .createAgreement(
//                         moderator.address,
//                         DAO_NAME_PARAM,
//                         startTime,
//                         endTime,
//                         ethers.utils.parseEther("10"),
//                         5184000
//                     )
//             ).to.be.revertedWith("Pausable: paused");
//             await agreementContract.connect(owner).unpause();
//             await expect(
//                 agreementContract
//                     .connect(founder)
//                     .createAgreement(
//                         moderator.address,
//                         DAO_NAME_PARAM,
//                         startTime,
//                         endTime,
//                         ethers.utils.parseEther("10"),
//                         5184000
//                     )
//             ).not.to.be.reverted;
//         });

//         it("should revert if not admin", async () => {
//             await expect(agreementContract.connect(otherSigners[0]).unpause())
//                 .to.be.reverted;
//         });

//         it("should revert if already unpaused", async () => {
//             agreementContract.connect(owner).unpause();
//             await expect(
//                 agreementContract.connect(owner).unpause()
//             ).to.be.revertedWith("Pausable: not paused");
//         });
//     });
// });
