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

    struct ModInfo_Vesting {
        uint256 amount;
        uint256 released;
        uint256 lockTime;
        uint256 vestingDuration;
    }

    mapping (address => ModInfo_Vesting[]) public modInfo_Vestings;

    event Release(
        address user,
        uint256 releaseAmount
    );

    function deposit() public {
        //
    }

    function release() public virtual {
        //
    }

    function modContractsCount() public view returns(uint256) {
        return modInfo_Vestings[msg.sender].length;
    }
}