//SPDX-License-Identifier: 0BSD
// Copyright Knot, inc.
// Author tomo@knot.inc

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import {PoM} from "./PoM.sol";
import "./libs/SharedStructs.sol";

contract AgreementContract is
    Initializable,
    AccessControlUpgradeable,
    SharedStructs
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    event CreateAgreement(
        address indexed moderator,
        bytes32 indexed agreementId
    );
    event UpdateAgreement(bytes32 indexed agreementId);
    event CompleteAgreement(bytes32 indexed agreementId);

    PoM private pom;

    // Mapping address to agreement id list
    // Founder and moderator have both the same agreementId
    mapping(address => bytes32[]) public holderToIds;

    // Mapping agreementId(bytes32) to agreement detail
    mapping(bytes32 => Agreement) public agreements;

    // Count total agreements that have been made
    // Incremented when agreement is created
    // Decremented when agreemenet is cancelled
    CountersUpgradeable.Counter private totalAgreements;

    bytes32 public constant AUTH_ROLE = keccak256("AUTH_ROLE");

    /*************************************
     * Modifier
     *************************************/
    modifier onlyFounder(bytes32 agreementId) {
        require(
            agreements[agreementId].founder == msg.sender,
            "Not authorized"
        );
        _;
    }
    modifier agreementExists(bytes32 agreementId) {
        require(agreements[agreementId].id > 0, "Agreement not exists");
        _;
    }

    /*************************************
     * Functions
     *************************************/
    function initialize(address _pom) public initializer {
        __AccessControl_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        pom = PoM(_pom);
    }

    /**
     * @dev Create agreement
     * @notice msg.sender should be a founder who tries to hire the moderator
     * @param moderator address, moderator address
     * @param daoName string, DAO name
     * @param startTime uint256, start time of the agreement
     * @param endTime uint256, end time of the agreement
     * @param rewardAmount uint256, reward amount
     */
    function createAgreement(
        address moderator,
        bytes22 daoName,
        uint32 startTime,
        uint32 endTime,
        uint256 rewardAmount
    ) external {
        // Create unique id for agreement
        bytes32 id = keccak256(
            abi.encodePacked(
                msg.sender,
                moderator,
                block.timestamp,
                blockhash(block.number - 1)
            )
        );

        // make sure there is no duplicated agreementIds
        require(agreements[id].id != id, "agreementId already exists");

        holderToIds[msg.sender].push(id);
        holderToIds[moderator].push(id);

        agreements[id] = Agreement({
            id: id,
            daoName: daoName,
            startTime: startTime,
            endTime: endTime,
            isCompleted: false,
            rewardAmount: rewardAmount,
            founder: msg.sender,
            moderator: moderator
        });

        // TODO: call vesting contract too
        pom.mintToken(moderator, agreements[id]);

        totalAgreements.increment();

        emit CreateAgreement(moderator, id);
    }

    /**
     * @dev Update agreement (only propeties specified with non-zero value)
     * @param agreementId uint256, agreementId (index) of agreement
     * @param startTime uint256, start time of agreement
     * @param endTime uint256, end time of agreement
     * @param rewardAmount uint256, reward amount
     */
    function updateAgreement(
        bytes32 agreementId,
        uint32 startTime,
        uint32 endTime,
        uint256 rewardAmount
    ) external onlyFounder(agreementId) agreementExists(agreementId) {
        Agreement storage agreement = agreements[agreementId];
        if (startTime != 0) {
            agreement.startTime = startTime;
        }
        if (endTime != 0) {
            agreement.endTime = endTime;
        }
        if (rewardAmount != 0) {
            agreement.rewardAmount = rewardAmount;
        }
        emit UpdateAgreement(agreementId);
    }

    /**
     * @dev Complete agreement
     * @notice Reverts if current time has not yet passed endTime of agreement
     * @param agreementId uint256, agreementId (index) of agreement
     * @param review string, client review about moderator work
     * NOTE: 140 chars review costs 613652 gas tx/ex cost 533610
     */
    function completeAgreement(bytes32 agreementId, string memory review)
        external
        onlyFounder(agreementId)
        agreementExists(agreementId)
    {
        require(
            block.timestamp > agreements[agreementId].endTime,
            "Contract not ended"
        );
        Agreement storage agreement = agreements[agreementId];
        agreement.isCompleted = true;

        pom.addReview(agreementId, review);

        emit CompleteAgreement(agreementId);
    }

    /**
     * @dev Gets agreements a moderator holds
     * @notice return values include completed agreement
     * @param holder address, holder address (either founder or moderator)
     * @return agreements array of agreement info holder holds
     */
    function getAllAgreements(address holder)
        external
        view
        returns (Agreement[] memory)
    {
        bytes32[] memory ids = holderToIds[holder];
        Agreement[] memory _agreements = new Agreement[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            _agreements[i] = agreements[ids[i]];
        }

        return _agreements;
    }

    /**
     * @dev Gets agreement specified by agreementId
     * @notice return agreement details
     * @param holder address, holder address (founder or moderator)
     * @return id list bytes32[], agreement id array
     */
    function getAllIds(address holder)
        external
        view
        returns (bytes32[] memory)
    {
        return holderToIds[holder];
    }

    /**
     * @dev Gets agreement specified by agreementId
     * @notice return agreement details
     * @param agreementId bytes32, agreement id that specifies agreement
     * @return agreement Agreement, single agreement specified with agreementId
     */
    function getAgreementDetail(bytes32 agreementId)
        external
        view
        returns (Agreement memory)
    {
        return agreements[agreementId];
    }

    function getTotalAgreements() external view returns (uint256) {
        return totalAgreements.current();
    }

    /*************************************
     ************* Admin Only ************
     *************************************/

    function grantAuth(address user) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _setupRole(AUTH_ROLE, user);
    }

    function revokeAuth(address user) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(AUTH_ROLE, user);
    }
}
