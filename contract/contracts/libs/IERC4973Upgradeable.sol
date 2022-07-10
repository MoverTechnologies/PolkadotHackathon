// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC4973Upgradeable is IERC165Upgradeable {
    /// @dev This emits when a new token is created and bound to an account by
    /// any mechanism.
    /// Note: For a reliable `_from` parameter, retrieve the transaction's
    /// authenticated `from` field.
    event Attest(address indexed _to, uint256 indexed _tokenId);
    /// @dev This emits when an existing ABT is revoked from an account and
    /// destroyed by any mechanism.
    /// Note: For a reliable `_from` parameter, retrieve the transaction's
    /// authenticated `from` field.
    event Revoke(address indexed _to, uint256 indexed _tokenId);

    /// @notice Find the address bound to an ERC4973 account-bound token
    /// @dev ABTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an ABT
    /// @return The address of the owner bound to the ABT
    function ownerOf(uint256 _tokenId) external view returns (address);

    /// @notice Destroys `tokenId`. At any time, an ABT receiver must be able to
    ///  disassociate themselves from an ABT publicly through calling this
    ///  function.
    /// @dev Must emit a `event Revoke` with the `address _to` field pointing to
    ///  the zero address.
    /// @param _tokenId The identifier for an ABT
    function burn(uint256 _tokenId) external;

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);
}
