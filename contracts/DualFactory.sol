// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {Collection} from "./Collection.sol";

import {DualArtist} from "./DualArtist.sol";

contract DualFactory {
    mapping(address => address[]) public ArtistToContracts;

    DualArtist artistContract;

    constructor(address _artistContract) {
        artistContract = DualArtist(_artistContract);
    }

    address[] public AllCollections;

    event ERC1155Created(address indexed owner, address indexed tokenContract); //emitted when ERC1155 token is deployed

    function deployERC1155(
        string memory _contractHash,
        string[] memory _hashOfNFTS,
        uint256[] memory _ids,
        uint256[] memory quantities
    ) public returns (address) {
        Collection t = new Collection(_contractHash, _hashOfNFTS, _ids, quantities, msg.sender);
        ArtistToContracts[msg.sender].push(address(t));
        AllCollections.push(address(t));
        emit ERC1155Created(msg.sender, address(t));

        return address(t);
    }

    function mintCollection(address t) external {
        Collection c = Collection(t);
        (bool success, ) = address(c).call(abi.encodeWithSignature("mintAll()"));
        require(success);
    }

    function AllArtistContracts(address artist) external view returns (address[] memory) {
        return ArtistToContracts[artist];
    }

    function getAllCollections() external view returns (address[] memory) {
        return AllCollections;
    }
}
