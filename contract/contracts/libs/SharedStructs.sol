//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface SharedStructs {
    struct Agreement {
        bytes32 id;
        bytes22 daoName;
        uint32 startTime; // max value 4294967295 (= Sunday, 7 February 2106 06:28:15GMT)
        uint32 endTime;
        bool isCompleted;
        uint256 rewardAmount;
        address founder;
        address moderator;
    }

    struct Proof {
        address founder;
        uint32 startTime;
        uint32 endTime;
        bytes22 daoName;
        uint256 rewardAmount;
        string review;
    }
}
