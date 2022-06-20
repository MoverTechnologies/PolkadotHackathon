//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vesting is Ownable {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // IERC20 public collateralToken;
    bool public availableReleaseFlg;
    uint256 public firstReleaseRate;
    uint256 public totalVestingAmount;

    struct ModInfo_Vesting {
        uint id; // nft の id にする
        uint256 amount;
        uint256 released;
        uint256 jobEndTime; // 基準点
        uint256 duration;
    }

    mapping (address => ModInfo_Vesting[]) public modInfo_Vestings;

    event Released(
        address user,
        uint256 releaseAmount
    );

    event Revoked(
        address user,
        uint256 amount,
        uint256 jobEndTime
    );

    // constructor(
    //     IERC20 _collateralToken,
    //     uint256 _firstReleaseRate
    // ) public {
    //     collateralToken = IERC20(_collateralToken);
    //     firstReleaseRate = _firstReleaseRate;
    //     availableReleaseFlg = false;
    // }

    function addVestingInfo(uint256 _amount, uint256 _jobEndTime, uint256 _duration) public {
        require(_amount > 0, "addVestingInfo: amount must be > 0");
        require(_jobEndTime > block.timestamp, "addVestingInfo: jobEndtime must be > block.timestamp");
        require(_duration > 0, "addVestingInfo: duration must be > 0");
        ModInfo_Vesting memory vesting = ModInfo_Vesting({
            id: 1, // nft の id にする（引数で受ける）
            amount: _amount,
            released: 0,
            jobEndTime: _jobEndTime,
            duration: _duration
        });
        modInfo_Vestings[msg.sender].push(vesting);
    }

    function release() public virtual {
        uint256 releasable = releaseAmount();
        modInfo_Vestings[msg.sender];
        emit Released(msg.sender, releasable);
    }

    function releaseAmount() public view returns (uint256) {
        //
    }

    // Practically essential (No need for this in the demo.)
    function revoke() public virtual {
        //
    }

    function modVestingsCount() public view returns(uint256) {
        return modInfo_Vestings[msg.sender].length;
    }
}