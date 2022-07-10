//SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";

import "./libs/ERC4973Upgradeable.sol";
import "./libs/SharedStructs.sol";

contract PoM is
    Initializable,
    ERC4973Upgradeable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    PausableUpgradeable,
    SharedStructs
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    event MintPoM(uint256 indexed tokenId, address indexed to);
    event ModifiyPoM(uint256 indexed tokenId, address indexed to);
    event BurnPoM(uint256 indexed tokenId, address indexed to);

    string private _baseURIForPoM;

    // Last Used id (used to generate new token ids)
    uint256 private _lastId;

    // Agreement contract address
    // To restrict minting function to this address
    address private _agreementContractAddress;

    // actualTokenURI for each tokenId
    mapping(uint256 => string) private _actualTokenURI;

    // proofId to tokenId
    // proofId is equal to agreementId
    mapping(bytes32 => uint256) private _proofIdToTokenId;

    // holder address to token id list
    mapping(address => uint256[]) private _holderToTokenIds;

    // tokenId to proofs
    mapping(uint256 => Proof) private _proofs;

    CountersUpgradeable.Counter private counter;

    /*************************************
     * Modifier
     *************************************/
    modifier onlyFounder(bytes32 proofId) {
        require(
            _proofs[_proofIdToTokenId[proofId]].founder == msg.sender,
            "Not authorized"
        );
        _;
    }
    modifier onlyFromAgreement() {
        require(_agreementContractAddress == msg.sender, "Invalid caller");
        _;
    }

    /*************************************
     * Functions
     *************************************/
    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) public initializer {
        __ERC4973_init(_name, _symbol);
        __AccessControl_init();
        __ReentrancyGuard_init();
        __Pausable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _baseURIForPoM = _baseURI;
    }

    /**
     * @notice agreement.id is equivalent to proofId
     *         Only allows Agreement contract to call
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param agreement agreement details to store in proof
     *         emit Event Atest(to address, tokenId uint256)
     */
    function mintToken(address to, Agreement calldata agreement)
        external
        nonReentrant
        whenNotPaused
        onlyFromAgreement
    {
        require(to != address(0), "Mint to the zero address");
        require(!(_proofIdToTokenId[agreement.id] > 0), "ProofId exists");

        _lastId += 1;
        counter.increment();

        _mintToken(_lastId, to, agreement);
    }

    /**
     * @dev Creates proof info accosiated with tokenId
     * @param tokenId uint256
     * @param to address, token holder
     * @param agreement Agreement, agreement info that will stored in proof
     */
    function _mintToken(
        uint256 tokenId,
        address to,
        Agreement memory agreement
    ) private {
        // _actualTokenURI[tokenId] = agreement.id;
        _proofIdToTokenId[agreement.id] = tokenId;
        _holderToTokenIds[to].push(tokenId);
        _proofs[tokenId] = Proof({
            founder: agreement.founder,
            startTime: agreement.startTime,
            endTime: agreement.endTime,
            daoName: agreement.daoName,
            rewardAmount: agreement.rewardAmount,
            review: ""
        });

        _safeMint(to, tokenId);
    }

    /**
     * @dev Adds review infomation to struct tied to token
     * @param proofId bytes32, proofId equal to agreementId
     * @param review string, review about moderator's work
     */
    function addReview(bytes32 proofId, string memory review)
        external
        onlyFromAgreement
    {
        uint256 tokenId = _proofIdToTokenId[proofId];
        _requireMinted(tokenId);

        Proof storage proof = _proofs[tokenId];
        proof.review = review;
        emit ModifiyPoM(tokenId, ownerOf(tokenId));
    }

    /**
     * @dev Modify proof infomation when changed by founder
     * @param agreement Agreement, modified agreement info
     */
    function updateProof(Agreement calldata agreement)
        external
        onlyFromAgreement
    {
        uint256 tokenId = _proofIdToTokenId[agreement.id];
        _requireMinted(tokenId);

        Proof storage proof = _proofs[tokenId];

        // Data validity is checked in AgreementContract
        if (proof.startTime != agreement.startTime) {
            proof.startTime = agreement.startTime;
        }

        if (proof.endTime != agreement.endTime) {
            proof.endTime = agreement.endTime;
        }

        if (proof.rewardAmount != agreement.rewardAmount) {
            proof.rewardAmount = agreement.rewardAmount;
        }

        emit ModifiyPoM(tokenId, ownerOf(tokenId));
    }

    /**
     * @notice Only founder, NOT moderator (holder), can burn the token
     * @dev Burns token
     * @param proofId bytes32, proofId equal to agreementId
     * onlyFounder checks its caller and existence of proof
     */
    function burnToken(bytes32 proofId)
        external
        whenNotPaused
        onlyFounder(proofId)
    {
        uint256 tokenId = _proofIdToTokenId[proofId];

        address holder = ownerOf(tokenId);

        // Delete tokenId and proof info stored in storage
        delete _proofs[tokenId];
        delete _proofIdToTokenId[proofId];
        removeTokenFromAddress(holder, tokenId);

        counter.decrement();
        _burn(tokenId);
    }

    /**
     * @notice This is needed to prevent direct call to burn in ERC4973Upgradeable.sol by overriding burn method
     * @dev Burns token
     * @param tokenId uint256, tokenId
     */
    function burn(uint256 tokenId) public view override {
        require(msg.sender == address(0), "Method prohibited");
    }

    /*************************************
     *  View Functions
     *************************************/

    /**
     * @dev Returns proof details accociated with tokenId
     * @param tokenId uint256, tokenId
     * @return proof Proof, proof detail
     */
    function getProofDetail(uint256 tokenId)
        external
        view
        returns (Proof memory)
    {
        require(_proofs[tokenId].founder != address(0), "Proof doesn't exist");
        return _proofs[tokenId];
    }

    /**
     * @dev Returns token id array associated with holder address
     * @param holder address, holder address
     * @return tokenId array uint256[], tokenId
     */
    function getAllTokenIds(address holder)
        external
        view
        returns (uint256[] memory)
    {
        require(_holderToTokenIds[holder].length > 0, "No tokens");
        return _holderToTokenIds[holder];
    }

    /**
     * @dev Gets the tokenId
     * @param proofId bytes32, proof id (equivalent to agreementId)
     * @return tokenId from proofId
     */
    function tokenID(bytes32 proofId) external view returns (uint256) {
        require(_exists(_proofIdToTokenId[proofId]), "Invalid proofId");
        return _proofIdToTokenId[proofId];
    }

    /**
     * @dev Returns Agreement contract address
     */
    function getAgreementContractAddress() external view returns (address) {
        return _agreementContractAddress;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC4973Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function totalSupply() external view returns (uint256) {
        return counter.current();
    }

    /**
     * @dev Gets the token uri
     * @return string representing the token uri
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        _requireMinted(tokenId);
        return _strConcat(_baseURIForPoM, _actualTokenURI[tokenId]);
    }

    /*************************************
     * Utility
     *************************************/

    /**
     * @dev Function to concat strings
     * Taken from https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
     */
    function _strConcat(string memory _a, string memory _b)
        internal
        pure
        returns (string memory _concatenatedString)
    {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory abcde = new string(_ba.length + _bb.length);
        bytes memory babcde = bytes(abcde);
        uint256 k = 0;
        uint256 i = 0;
        for (i = 0; i < _ba.length; i++) {
            babcde[k++] = _ba[i];
        }
        for (i = 0; i < _bb.length; i++) {
            babcde[k++] = _bb[i];
        }
        return string(babcde);
    }

    /**
     * @dev Remove tokenId from token id array associated with holder address
     * @param holder address, holder address
     * @param tokenId uint256, tokenId
     */
    function removeTokenFromAddress(address holder, uint256 tokenId) private {
        uint256[] storage tokenIds = _holderToTokenIds[holder];
        int256 index = findIndexOfTokenId(_holderToTokenIds[holder], tokenId);

        require(index >= 0, "Token does not exist");

        for (uint256 i = uint256(index); i < tokenIds.length - 1; i++) {
            tokenIds[i] = tokenIds[i + 1];
        }

        // Remove duplicated last two elements from the above loop
        tokenIds.pop();
    }

    /**
     * @dev Remove tokenId from token id array associated with holder address
     * @param array uint256[], token id list
     * @param tokenId utin256, tokenId that should be removed
     * @return index number int256, index of tokenId that will be removed
     *               will return -1 if not token index found
     */
    function findIndexOfTokenId(uint256[] memory array, uint256 tokenId)
        private
        pure
        returns (int256)
    {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == tokenId) {
                return int256(i);
            }
        }

        return -1;
    }

    /*************************************
     *  Admin
     *************************************/

    /**
     * @dev Sets the Agreement contract address to allow it to mint token
     * @param contractAddr address, AgreeemntContract address
     */
    function setAgreementContractAddress(address contractAddr)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _agreementContractAddress = contractAddr;
    }

    /**
     * @dev Function to set baseURI
     * @param baseURI baseURI e.g. "https://mover.com/pom/"
     */
    function setBaseURI(string memory baseURI)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _baseURIForPoM = baseURI;
    }

    /**
     * @notice Changes _paused status to true under emergency situations
     */
    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    /**
     * @notice Changes _paused status to false
     */
    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }
}
