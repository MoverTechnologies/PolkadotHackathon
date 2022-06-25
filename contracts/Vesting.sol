//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Vesting is Initializable, ReentrancyGuardUpgradeable, OwnableUpgradeable {

    using SafeMathUpgradeable for uint256;
    using SafeERC20Upgradeable for IERC20Upgradeable;

    IERC20Upgradeable public depositedToken;

    struct ModInfoVesting {
        address founderAddress;
        address modAddress;
        uint256 amount;
        uint256 released;
        uint32 jobEndTime; // 基準点
        uint256 duration;
        bool completed;
        // bool revoked;
    }

    // Agreement contract address
    // To restrict addVestingInfo function to its address
    // address private _agreementContractAddress;

    // proof id (bytes32) -> vesting info
    mapping (bytes32 =>  ModInfoVesting) public modInfoVesting;

    event Released(
        address indexed mod,
        bytes32 indexed proofId,
        uint256 indexed releaseAmount
    );

    event Revoked(
        address indexed founder,
        bytes32 indexed proofId
    );

    /*************************************
     * Functions
     *************************************/
    function initialize(
        IERC20Upgradeable _depositedToken
    ) public initializer {
        __Ownable_init();
        __ReentrancyGuard_init();
        depositedToken = IERC20Upgradeable(_depositedToken);
    }

    // コントラクトから実行する
    function addVestingInfo(bytes32 _proofId, address _founderAddress, address _modAddress, uint256 _amount, uint32 _jobEndTime, uint256 _duration) public {
        // require(_agreementContractAddress == msg.sender, "Not authorized");
        require(_amount > 0, "amount must be > 0");
        require(depositedToken.balanceOf(_founderAddress) >= _amount, "insufficient token balance");
        require(_jobEndTime > block.timestamp, "jobEndtime must be > now");
        require(_duration > 0, "duration must be > 0");

        depositedToken.safeTransferFrom(_founderAddress, address(this), _amount);

        modInfoVesting[_proofId] = ModInfoVesting({
            founderAddress: _founderAddress,
            modAddress: _modAddress,
            amount: _amount,
            released: 0,
            jobEndTime: _jobEndTime,
            duration: _duration,
            completed: false
        });
    }

    // mod が実行する
    function release(bytes32 _proofId) public virtual {
        ModInfoVesting storage modVestingInfo = modInfoVesting[_proofId];
        require(block.timestamp > modVestingInfo.jobEndTime, "now must be > jobEndTime");
        require(modVestingInfo.modAddress == msg.sender, "msg.sender must be modAddress");
        require(modVestingInfo.completed == false, "release: you already completed");
        uint256 releasable = releaseAmount(_proofId);
        depositedToken.safeTransfer(msg.sender, releasable);
        modVestingInfo.released += releasable;

        if (modVestingInfo.amount == modVestingInfo.released) {
            modVestingInfo.completed = true;
        }

        emit Released(msg.sender, _proofId, releasable);
    }

    function releaseAmount(bytes32 _proofId) public view virtual returns (uint256) {
        ModInfoVesting storage modVestingInfo = modInfoVesting[_proofId];
        if (block.timestamp < modVestingInfo.jobEndTime) {
            return 0;
        }

        uint remainingAmount = modVestingInfo.amount - modVestingInfo.released;
    
        if (block.timestamp > modVestingInfo.jobEndTime + modVestingInfo.duration) {
            return remainingAmount;
        } else {
            return ((remainingAmount * (block.timestamp - modVestingInfo.jobEndTime)) / modVestingInfo.duration);
        }
    }

    // founder が実行する（ここもコントラクトからの処理の可能性あり）
    function revoke(bytes32 _proofId) public virtual {
        ModInfoVesting storage modVestingInfo = modInfoVesting[_proofId];
        require(modVestingInfo.founderAddress == msg.sender, "msg.sender must be founder");
        depositedToken.safeTransfer(address(msg.sender), modVestingInfo.amount);
        modVestingInfo.completed = true;
        emit Revoked(msg.sender, _proofId);
    }

    function setDepoistedToken(address _depositedToken) public onlyOwner {
        depositedToken = IERC20Upgradeable(_depositedToken);
    }

    // function setAgreementContractAddress(address contractAddr) public onlyOwner {
    //     _agreementContractAddress = contractAddr;
    // }
}