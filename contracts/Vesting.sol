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
        uint256 amount;
        uint256 released;
        uint256 jobEndTime; // 基準点
        uint256 duration;
        bool completed;
    }

    mapping (address => mapping(uint256 => ModInfo_Vesting)) public modInfo_Vesting;

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

    function addVestingInfo(uint256 _proofId, uint256 _amount, uint256 _jobEndTime, uint256 _duration) public {
        require(_amount > 0, "addVestingInfo: amount must be > 0");
        require(_jobEndTime > block.timestamp, "addVestingInfo: jobEndtime must be > block.timestamp");
        require(_duration > 0, "addVestingInfo: duration must be > 0");
        modInfo_Vesting[msg.sender][_proofId].amount = _amount;
        modInfo_Vesting[msg.sender][_proofId].released = 0;
        modInfo_Vesting[msg.sender][_proofId].jobEndTime = _jobEndTime;
        modInfo_Vesting[msg.sender][_proofId].duration = _duration;
        modInfo_Vesting[msg.sender][_proofId].completed = false;
    }

    function release(uint256 _proofId) public virtual {
        require(block.timestamp > modInfo_Vesting[msg.sender][_proofId].jobEndTime, "release: block.timestamp must be > jobEndTime ");
        uint256 releasable = releaseAmount(_proofId);
        emit Released(msg.sender, _proofId, releasable);
        if (modInfo_Vesting[msg.sender][_proofId].amount == modInfo_Vesting[msg.sender][_proofId].released) {
            modInfo_Vesting[msg.sender][_proofId].completed = true;
        }
        depositedToken.safeTransfer(address(msg.sender), releasable);
    }

    function releaseAmount(uint256 _proofId) public view virtual returns (uint256) {
        uint remainingAmount = modInfo_Vesting[msg.sender][_proofId].amount - modInfo_Vesting[msg.sender][_proofId].released;
        if (block.timestamp > modInfo_Vesting[msg.sender][_proofId].jobEndTime + modInfo_Vesting[msg.sender][_proofId].duration) {
            return remainingAmount;
        } else {
            return ((remainingAmount * (block.timestamp - modInfo_Vesting[msg.sender][_proofId].jobEndTime)) / modInfo_Vesting[msg.sender][_proofId].duration);
        }
    }

    // Practically essential (No need for this in the demo.)
    function revoke(uint256 _proofId) public virtual {
        emit Revoked(msg.sender, _proofId);
    }

    function setDepoistedToken(address _depositedToken) public onlyOwner {
        depositedToken = IERC20(_depositedToken);
    }
}