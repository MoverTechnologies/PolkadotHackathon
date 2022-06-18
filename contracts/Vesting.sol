//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vesting is Ownable {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    bool public _availableReleaseFlg;
    uint256 public _firstReleaseRate;
    uint256 public totalVestingAmount;

    struct ModInfo_Vesting {
        uint256 amount;
        uint256 released;
        uint256 lockTime;
        uint256 Duration;
    }

    mapping (address => ModInfo_Vesting[]) public modInfo_Vestings;

    event Release(
        address user,
        uint256 releaseAmount
    );

    function addVestingInfo(uint256 _amount, uint256 _lockTime, uint256 _duration) public {
        require(_amount > 0, "TokenVesting: amount must be > 0");
        require(_duration > 0, "TokenVesting: duration must be > 0");
        ModInfo_Vesting memory vesting = ModInfo_Vesting({
            amount: _amount,
            released: 0,
            lockTime: _lockTime,
            Duration: _duration
        });
        modInfo_Vestings[msg.sender].push(vesting);
    }

    function release() public virtual {
        //
    }

    function modVestingsCount() public view returns(uint256) {
        return modInfo_Vestings[msg.sender].length;
    }
}