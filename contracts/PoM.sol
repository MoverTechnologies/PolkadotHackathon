//SPDX-License-Identifier: 0BSD
// Copyright Knot, inc.
// Author tomo@knot.inc
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

import "./libs/ERC4973Upgradeable.sol";
import "./libs/SharedStructs.sol";

contract PoM is
    Initializable,
    ERC4973Upgradeable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    SharedStructs
{
    using CountersUpgradeable for CountersUpgradeable.Counter;

    event MintPoM(uint256 indexed tokenId, address indexed to);
    event ModifiyPoM(uint256 indexed tokenId, address indexed to);
    event BurnPoM(uint256 indexed tokenId, address indexed to);

    string private _baseURIForPoM;

    // Last Used id (used to generate new token ids)
    uint256 private _lastId;

    // mint status
    bool private _isMintActive;

    // Agreement contract address
    // To restrict minting function to its address
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
    modifier proofIdNotExists(bytes32 proofId) {
        require(!(_proofIdToTokenId[proofId] > 0), "ProofId exists");
        _;
    }
    modifier proofExists(uint256 tokenId) {
        require(_proofs[tokenId].founder != address(0), "Proof doesn't exist");
        _;
    }
    modifier tokenExists(bytes32 proofId) {
        require(_proofIdToTokenId[proofId] > 0, "Token doesn't exist");
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
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _baseURIForPoM = _baseURI;
        _isMintActive = true;
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
        return _strConcat(_baseURIForPoM, _actualTokenURI[tokenId]);
    }

    /**
     * @dev Gets the tokenId
     * @return tokenId from proofId
     */
    function tokenID(bytes32 proofId)
        public
        view
        tokenExists(proofId)
        returns (uint256)
    {
        return _proofIdToTokenId[proofId];
    }

    /**
     * @notice agreement.id is equivalent to proofId
     *         Only allows founder to call
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param agreement agreement details to store in proof
     * @return A boolean that indicates if the operation was successful.
     */
    function mintToken(address to, Agreement calldata agreement)
        external
        nonReentrant
        proofIdNotExists(agreement.id)
        returns (bool)
    {
        require(_isMintActive, "Mint not active");
        require(_agreementContractAddress == msg.sender, "Not authorized");

        _lastId += 1;
        return _mintToken(_lastId, to, agreement);
    }

    /**
     * @dev Function to set baseURI
     * @param baseURI baseURI e.g. "https://mover.com/pom/"
     */
    function setBaseURI(string memory baseURI) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Not authorized");
        _baseURIForPoM = baseURI;
    }

    /**
     * @dev Set mint activity. Pause mint in case of hack
     * @param isMintActive mint activity
     */
    function setIsMintActive(bool isMintActive) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Not authorized");
        _isMintActive = isMintActive;
    }

    function getIsMintActive() external view returns (bool) {
        return _isMintActive;
    }

    function setAgreementContractAddress(address contractAddr) external {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Not authorized");
        _agreementContractAddress = contractAddr;
    }

    function totalSupply() external view returns (uint256) {
        return counter.current();
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

    function _mintToken(
        uint256 tokenId,
        address to,
        Agreement memory agreement
    ) private returns (bool) {
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

        counter.increment();
        emit MintPoM(tokenId, to);

        return true;
    }

    /**
     * @dev Adds review infomation to struct tied to token
     * @param proofId bytes32, proofId equal to agreementId
     * @param review string, review about moderator's work
     */
    function addReview(bytes32 proofId, string memory review) external {
        require(_agreementContractAddress == msg.sender, "Not authorized");

        uint256 tokenId = _proofIdToTokenId[proofId];
        Proof storage proof = _proofs[tokenId];
        proof.review = review;
        emit ModifiyPoM(tokenId, ownerOf(tokenId));
    }

    /**
     * @notice Only founder, NOT moderator (holder), can burn the token
     * @dev Burns token
     * @param proofId bytes32, proofId equal to agreementId
     */
    function burnToken(bytes32 proofId)
        external
        tokenExists(proofId)
        onlyFounder(proofId)
    {
        uint256 tokenId = _proofIdToTokenId[proofId];
        address holder = ownerOf(tokenId);
        burn(tokenId);

        // Delete tokenId and proof info stored in storage
        delete _proofs[tokenId];
        delete _proofIdToTokenId[proofId];
        removeTokenFromAddress(holder, tokenId);
        counter.decrement();
        emit BurnPoM(tokenId, holder);
    }

    /**
     * @notice This is needed to prevent direct call to burn in ERC4973Upgradeable.sol by overriding burn method
     * @dev Burns token
     * @param tokenId uint256, tokenId
     */
    function burn(uint256 tokenId) public override {
        require(msg.sender == _proofs[tokenId].founder, "Not authorized");

        _burn(tokenId);
    }

    /**
     * @dev Remove tokenId from token id array associated with holder address
     * @param holder address, holder address
     * @param tokenId uint256, tokenId
     */
    function removeTokenFromAddress(address holder, uint256 tokenId) private {
        uint256[] storage tokenIds = _holderToTokenIds[holder];
        int256 index = findIndexOfTokenId(tokenIds, tokenId);

        require(index >= 0, "Token does not exist");

        for (uint256 i = uint256(index); i < tokenIds.length - 1; i++) {
            tokenIds[i] = tokenIds[i + 1];
        }

        // remove duplicated last two elements from the above loop
        tokenIds.pop();
    }

    /**
     * @dev Returns proof details accociated with tokenId
     * @param tokenId uint256, tokenId
     * @return proof Proof, proof detail
     */
    function getProofDetail(uint256 tokenId)
        external
        view
        proofExists(tokenId)
        returns (Proof memory)
    {
        return _proofs[tokenId];
    }

    /**
     * @dev Remove tokenId from token id array associated with holder address
     * @param holder address, holder address
     * @return tokenId array uint256[], tokenId
     */
    function getAllTokenIds(address holder)
        external
        view
        returns (uint256[] memory)
    {
        return _holderToTokenIds[holder];
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
     * @param array uint256[], token id list
     * @param tokenId utin256, tokenId that should be removed
     * @return index number int256, index of tokenId that will be removed
     */
    function findIndexOfTokenId(uint256[] storage array, uint256 tokenId)
        private
        view
        returns (int256)
    {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == tokenId) {
                return int256(i);
            }
        }

        return -1;
    }
}
