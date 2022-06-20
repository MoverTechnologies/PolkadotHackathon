//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vesting is Ownable {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public depositedToken;

    struct ModInfo_Vesting {
        address founderAddress;
        address modAddress;
        uint256 amount;
        uint256 released;
        uint256 jobEndTime; // 基準点
        uint256 duration;
        bool completed;
        // bool revoked;
    }

    mapping (uint256 =>  ModInfo_Vesting) public modInfo_Vesting;

    event Released(
        address user,
        uint256 proofId,
        uint256 releaseAmount
    );

    event Revoked(
        address user,
        uint256 proofId
    );

    constructor (IERC20 _depositedToken) {
        depositedToken = IERC20(_depositedToken);
    }

    // founder が実行する
    function addVestingInfo(uint256 _proofId, address _modAddress, uint256 _amount, uint256 _jobEndTime, uint256 _duration) public {
        require(_amount > 0, "addVestingInfo: amount must be > 0");
        require(depositedToken.balanceOf(msg.sender) >= _amount, "addVestingInfo: insufficient token balance");
        require(_jobEndTime > block.timestamp, "addVestingInfo: jobEndtime must be > block.timestamp");
        require(_duration > 0, "addVestingInfo: duration must be > 0");

        depositedToken.safeTransferFrom(address(msg.sender), address(this), _amount);

        modInfo_Vesting[_proofId].founderAddress = msg.sender;
        modInfo_Vesting[_proofId].modAddress = _modAddress;
        modInfo_Vesting[_proofId].amount = _amount;
        modInfo_Vesting[_proofId].released = 0;
        modInfo_Vesting[_proofId].jobEndTime = _jobEndTime;
        modInfo_Vesting[_proofId].duration = _duration;
        modInfo_Vesting[_proofId].completed = false;
        // modInfo_Vesting[_proofId].revoked = false;
    }

    // mod が実行する
    function release(uint256 _proofId) public virtual {
        require(block.timestamp > modInfo_Vesting[_proofId].jobEndTime, "release: block.timestamp must be > jobEndTime");
        require(modInfo_Vesting[_proofId].modAddress == msg.sender, "release: modAddress must be msg.sender");
        require(modInfo_Vesting[_proofId].completed == false, "release: you already completed");
        uint256 releasable = releaseAmount(_proofId);
        depositedToken.safeTransfer(address(msg.sender), releasable);

        if (modInfo_Vesting[_proofId].amount == modInfo_Vesting[_proofId].released) {
            modInfo_Vesting[_proofId].completed = true;
        }

        emit Released(msg.sender, _proofId, releasable);
    }

    function releaseAmount(uint256 _proofId) public view virtual returns (uint256) {
        if (block.timestamp < modInfo_Vesting[_proofId].jobEndTime) {
            return 0;
        }

        uint remainingAmount = modInfo_Vesting[_proofId].amount - modInfo_Vesting[_proofId].released;
    
        if (block.timestamp > modInfo_Vesting[_proofId].jobEndTime + modInfo_Vesting[_proofId].duration) {
            return remainingAmount;
        } else {
            return ((remainingAmount * (block.timestamp - modInfo_Vesting[_proofId].jobEndTime)) / modInfo_Vesting[_proofId].duration);
        }
    }

    // founder が実行する
    function revoke(uint256 _proofId) public virtual {
        require(modInfo_Vesting[_proofId].founderAddress == msg.sender, "revoke: founderAddress must be msg.sender");
        depositedToken.safeTransfer(address(msg.sender), modInfo_Vesting[_proofId].amount);
        emit Revoked(msg.sender, _proofId);
    }

    function setDepoistedToken(address _depositedToken) public onlyOwner {
        depositedToken = IERC20(_depositedToken);
    }
}