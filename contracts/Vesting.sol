//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Vesting is Initializable, OwnableUpgradeable {

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

    function initialize(
        IERC20Upgradeable _depositedToken
    ) public initializer {
        depositedToken = IERC20Upgradeable(_depositedToken);
        __Ownable_init();
    }

    // コントラクトから実行する
    function addVestingInfo(bytes32 _proofId, address _founderAddress, address _modAddress, uint256 _amount, uint32 _jobEndTime, uint256 _duration) public {
        require(_amount > 0, "amount must be > 0");
        require(depositedToken.balanceOf(_founderAddress) >= _amount, "insufficient token balance");
        require(_jobEndTime > block.timestamp, "jobEndtime must be > now");
        require(_duration > 0, "duration must be > 0");

        depositedToken.safeTransferFrom(_founderAddress, address(this), _amount);

        modInfoVesting[_proofId].founderAddress = _founderAddress;
        modInfoVesting[_proofId].modAddress = _modAddress;
        modInfoVesting[_proofId].amount = _amount;
        modInfoVesting[_proofId].released = 0;
        modInfoVesting[_proofId].jobEndTime = _jobEndTime;
        modInfoVesting[_proofId].duration = _duration;
        modInfoVesting[_proofId].completed = false;
        // modInfoVesting[_proofId].revoked = false;
    }

    // mod が実行する
    function release(bytes32 _proofId) public virtual {
        require(block.timestamp > modInfoVesting[_proofId].jobEndTime, "now must be > jobEndTime");
        require(modInfoVesting[_proofId].modAddress == msg.sender, "msg.sender must be modAddress");
        require(modInfoVesting[_proofId].completed == false, "release: you already completed");
        uint256 releasable = releaseAmount(_proofId);
        depositedToken.safeTransfer(msg.sender, releasable);
        modInfoVesting[_proofId].released += releasable;

        if (modInfoVesting[_proofId].amount == modInfoVesting[_proofId].released) {
            modInfoVesting[_proofId].completed = true;
        }

        emit Released(msg.sender, _proofId, releasable);
    }

    function releaseAmount(bytes32 _proofId) public view virtual returns (uint256) {
        if (block.timestamp < modInfoVesting[_proofId].jobEndTime) {
            return 0;
        }

        uint remainingAmount = modInfoVesting[_proofId].amount - modInfoVesting[_proofId].released;
    
        if (block.timestamp > modInfoVesting[_proofId].jobEndTime + modInfoVesting[_proofId].duration) {
            return remainingAmount;
        } else {
            return ((remainingAmount * (block.timestamp - modInfoVesting[_proofId].jobEndTime)) / modInfoVesting[_proofId].duration);
        }
    }

    // founder が実行する（ここもコントラクトからの処理の可能性あり）
    function revoke(bytes32 _proofId) public virtual {
        require(modInfoVesting[_proofId].founderAddress == msg.sender, "msg.sender must be founder");
        depositedToken.safeTransfer(address(msg.sender), modInfoVesting[_proofId].amount);
        modInfoVesting[_proofId].completed = true;
        emit Revoked(msg.sender, _proofId);
    }

    function setDepoistedToken(address _depositedToken) public onlyOwner {
        depositedToken = IERC20Upgradeable(_depositedToken);
    }
}