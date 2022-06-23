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

    // proof id (string) -> vesting info
    mapping (string =>  ModInfo_Vesting) public modInfo_Vesting;

    event Released(
        address user,
        string proofId,
        uint256 releaseAmount
    );

    event Revoked(
        address user,
        string proofId
    );

    function initialize(
        IERC20Upgradeable _depositedToken
    ) public initializer {
        depositedToken = IERC20Upgradeable(_depositedToken);
        __Ownable_init();
    }

    // コントラクトから実行する
    function addVestingInfo(string memory _proofId, address _founderAddress, address _modAddress, uint256 _amount, uint256 _jobEndTime, uint256 _duration) public {
        require(_amount > 0, "addVestingInfo: amount must be > 0");
        require(depositedToken.balanceOf(_founderAddress) >= _amount, "addVestingInfo: insufficient token balance");
        require(_jobEndTime > block.timestamp, "addVestingInfo: jobEndtime must be > block.timestamp");
        require(_duration > 0, "addVestingInfo: duration must be > 0");

        depositedToken.safeTransferFrom(_founderAddress, address(this), _amount);

        modInfo_Vesting[_proofId].founderAddress = _founderAddress;
        modInfo_Vesting[_proofId].modAddress = _modAddress;
        modInfo_Vesting[_proofId].amount = _amount;
        modInfo_Vesting[_proofId].released = 0;
        modInfo_Vesting[_proofId].jobEndTime = _jobEndTime;
        modInfo_Vesting[_proofId].duration = _duration;
        modInfo_Vesting[_proofId].completed = false;
        // modInfo_Vesting[_proofId].revoked = false;
    }

    // mod が実行する
    function release(string memory _proofId) public virtual {
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

    function releaseAmount(string memory _proofId) public view virtual returns (uint256) {
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

    // founder が実行する（ここもコントラクトからの処理の可能性あり）
    function revoke(string memory _proofId) public virtual {
        require(modInfo_Vesting[_proofId].founderAddress == msg.sender, "revoke: founderAddress must be msg.sender");
        depositedToken.safeTransfer(address(msg.sender), modInfo_Vesting[_proofId].amount);
        // modInfo_Vesting[_proofId].completed = true;
        emit Revoked(msg.sender, _proofId);
    }

    function setDepoistedToken(address _depositedToken) public onlyOwner {
        depositedToken = IERC20Upgradeable(_depositedToken);
    }
}