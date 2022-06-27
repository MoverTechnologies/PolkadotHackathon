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
    address private agreementContractAddress;

    // proof id (bytes32) -> vesting info
    mapping (bytes32 =>  ModInfoVesting) public modInfoVesting;

    event AddVestingInfo(
        bytes32 indexed proofId,
        address indexed founder
    );

    event UpdateVestingInfo(
        bytes32 indexed proofId
    );

    event Released(
        bytes32 indexed proofId,
        address indexed mod,
        uint256 indexed reward
    );

    event Revoked(
        bytes32 indexed proofId,
        address indexed founder
    );

    /*************************************
     * Modifier
     *************************************/
    modifier proofExists(bytes32 _proofId) {
        require(modInfoVesting[_proofId].founderAddress != address(0), "Proof doesn't exist");
        _;
    }

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

    /**
     * @notice Only allows Agreement contract to call
     * @param _proofId bytes32
     * @param _founderAddress address
     * @param _modAddress address
     * @param _amount uint256 
     * @param _jobEndTime uint32 
     * @param _duration uint256
     */
    function addVestingInfo(bytes32 _proofId, address _founderAddress, address _modAddress, uint256 _amount, uint32 _jobEndTime, uint256 _duration) external {
        require(agreementContractAddress == msg.sender, "Not authorized");
        require(_founderAddress != address(0), "founder is the zero address");
        require(_modAddress != address(0), "mod is the zero address");
        require(_amount != 0, "amount must be > 0");
        require(depositedToken.balanceOf(_founderAddress) >= _amount, "insufficient token balance");
        require(_jobEndTime > block.timestamp, "jobEndtime must be > now");
        // require(_duration != 0, "duration must be > 0");

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

        emit AddVestingInfo(_proofId, _founderAddress);
    }

    /**
     * @notice Only allows Agreement contract to call
     * @param _proofId bytes32
     * @param _amount uint256
     * @param _jobEndTime uint32 
     */
    function updateVestingInfo(bytes32 _proofId, uint256 _amount, uint32 _jobEndTime) external proofExists(_proofId) {
        require(agreementContractAddress == msg.sender, "Not authorized");
        require(_amount != 0, "amount must be > 0");
        require(_jobEndTime > block.timestamp, "jobEndtime must be > now");
        ModInfoVesting storage modVestingInfo = modInfoVesting[_proofId];

        modVestingInfo.amount = _amount;
        modVestingInfo.jobEndTime = _jobEndTime;

        emit UpdateVestingInfo(_proofId);
    }

    /**
     * @notice Only allows mods to call
     * @param _proofId bytes32
     */
    function release(bytes32 _proofId) external virtual proofExists(_proofId) {
        ModInfoVesting storage modVestingInfo = modInfoVesting[_proofId];
        require(modVestingInfo.modAddress == msg.sender, "msg.sender must be modAddress");
        require(block.timestamp > modVestingInfo.jobEndTime, "now must be > jobEndTime");
        require(modVestingInfo.completed == false, "release: you already completed");
        uint256 releasable = releaseAmount(_proofId);
        modVestingInfo.released += releasable;

        if (modVestingInfo.amount == modVestingInfo.released) {
            modVestingInfo.completed = true;
        }

        depositedToken.safeTransfer(msg.sender, releasable);
        emit Released(_proofId, msg.sender, releasable);
    }

    /**
     * @param _proofId bytes32
     * @return remainingamount remaining work rewards
     */
    function releaseAmount(bytes32 _proofId) public view virtual proofExists(_proofId) returns (uint256) {
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

    /**
     * @notice Only allows Agreement contract to call
     * @param _proofId bytes32
     */
    function revoke(bytes32 _proofId) external virtual proofExists(_proofId) {
        require(agreementContractAddress == msg.sender, "Not authorized");
        // require(modVestingInfo.founderAddress == msg.sender, "msg.sender must be founder");
        ModInfoVesting storage modVestingInfo = modInfoVesting[_proofId];
        require(modVestingInfo.completed == false, "revoke: you already completed");
        modVestingInfo.completed = true;

        depositedToken.safeTransfer(address(msg.sender), modVestingInfo.amount);
        emit Revoked(_proofId, msg.sender);
    }

    /**
     * @param _depositedToken address
     */
    function setDepoistedToken(address _depositedToken) external onlyOwner {
        depositedToken = IERC20Upgradeable(_depositedToken);
    }

    /**
     * @param _contractAddr address
     */
    function setAgreementContractAddress(address _contractAddr) external onlyOwner {
        agreementContractAddress = _contractAddr;
    }
}