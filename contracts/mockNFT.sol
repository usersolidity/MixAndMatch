//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract mockNFT is ERC721, Ownable {
    using Strings for uint256;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public wallet = 0;

    constructor() ERC721("NFT Token", "mNFT") {}

    function superMintTo(uint16 _count) external {
        for (uint256 i = 1; i <= _count; i++) {
            _tokenIds.increment();
            uint256 newItemId = _tokenIds.current();
            _mint(msg.sender, newItemId);
        }
    }

    string public baseURI = "ipfs://<hash/";
    string public baseExtension = ".json";

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721)
        returns (string memory)
    {
        if (_exists(tokenId) == false) {
            return string(abi.encodePacked(baseURI, "0", baseExtension));
        }
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(baseURI, tokenId.toString(), baseExtension)
                )
                : "";
    }

    function setBaseURI(string memory _base) external onlyOwner {
        baseURI = _base;
    }
}
