// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import { ERC1155Supply } from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import {Counters } from "@openzeppelin/contracts/utils/Counters.sol";

///@notice error when uri for non-existent collection is queried
error NonExistentToken();
//@notice when array lengths are not equal
error ArrayLengthsNotEqual();

contract Collection is ERC1155Supply, Ownable {
    using Counters for Counters.Counter;

    /// @dev - Boolean to check if collection has been minted
    bool minted;
    ///@notice - Counters for tokenIDs
    Counters.Counter private _tokenID;

    ///@notice - Mapping for tokenURIs

    /**
     * @notice - Mapping for tokenURIs
     * @dev - tokenID => tokenURI
     */
    mapping(uint256 => string) public _tokenURIs;

    ///@dev hardcoded marketplace address for easy approval
    address public marketPlace = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
    string public contractHash; //the contract details hash
    uint[] public quantities; //the quantities of each token
    string[] public allTokenURIs; //an array of all tokenURIs
    uint256[] public token_ids; //an array of all tokenIDs 

    /*
    constructor is executed when the factory contract calls its own deployERC1155 method
    */
    constructor(
        string memory _contractHash,
        string[] memory _hashOfNFTS,
        uint256[] memory _ids,
        uint256[] memory _quantities,
        address owner
    ) ERC1155("") {
        if(_hashOfNFTS.length != _quantities.length || _hashOfNFTS.length != _ids.length)
            revert ArrayLengthsNotEqual();
        
        contractHash = _contractHash;
        quantities = _quantities;
        allTokenURIs = _hashOfNFTS;
        token_ids = _ids;

        uint length = _hashOfNFTS.length;
        for (uint i = 0; i < length; ) {
            _tokenID.increment();
            _tokenURIs[_tokenID.current()] = _hashOfNFTS[i];
            unchecked {
                ++i;
            }
        }
        transferOwnership(owner);
    }

    /**
     * @dev Returns the numbers of child tokens deployed.
     */
    function getTotalChildren() public view returns (uint256) {
        return _tokenID.current();
    }

    /**
     * @dev necessary override of _beforeTokenTransfer See {ERC1155-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    /**
     * @dev Returns the token uri for a token ID
     * @param id uint256 ID of the token uri
     * @return _tokenURIs of token ID
     */
    function uri(uint256 id) public view override returns (string memory) {
        if (!exists(id)) revert NonExistentToken();
        return _tokenURIs[id];
    }

    function mintAll() external onlyOwner {
        require(!minted);
        minted = true;
       _mintBatch(msg.sender, token_ids, quantities, "");
    }


    /**
     * Override isApprovedForAll to whitelist marketPlace for all token owners
     */
    function isApprovedForAll(address owner, address operator)
        public
        view
        override
        returns (bool)
    {
        if(operator == marketPlace) return true;
        return super.isApprovedForAll(owner, operator);
    }

}