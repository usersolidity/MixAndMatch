pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./AssemblyNFTInterface.sol";

abstract contract AssemblyNFT is ERC721Enumerable, ERC721Holder, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    using Strings for uint256;
    string public baseURI = "https://";

    struct Record {
        address localTokenAddress;
        uint256 localTokenID;
        uint16 totalRecord;
    }
    // Mapping from owner to list of owned token IDs
    mapping(uint256 => mapping(uint256 => Record)) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedBalance;
    mapping(address => bool) private approvedNFT;

    event AssemblyAsset(
        address indexed firstHolder,
        uint256 indexed tokenId,
        address owner,
        address[] addresses,
        uint256[] numbers
    );

    // Must approve before Minting.
    function mint(
        address _to,
        address[] memory _addresses, // Address.
        uint256[] memory _numbers // tokenIDs
    ) external returns (uint256) {
        require(_to != address(0), "can't mint to address(0)");
        require(
            _addresses.length == _numbers.length,
            "can't mint to address(0)"
        );
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        Record storage localStruct;
        for (uint256 j = 0; j < _numbers.length; j++) {
            address _localAddress = _addresses[j];
            require(approvedNFT[_localAddress] == true, "Not approved NFT");
            uint256 _localTokenId = _numbers[j];
            IERC721(_addresses[j]).safeTransferFrom(
                _msgSender(),
                address(this),
                _numbers[j]
            );
            localStruct = _ownedTokens[newItemId][j];
            localStruct.localTokenAddress = _localAddress;
            localStruct.localTokenID = _localTokenId;
        }
        _ownedBalance[newItemId] = _numbers.length;

        super._mint(_to, newItemId);
        emit AssemblyAsset(_to, newItemId, _msgSender(), _addresses, _numbers);
        return newItemId;
    }

    /*
    function safeMint(
        address _to,
        address[] memory _addresses,
        uint256[] memory _numbers
    ) external returns (uint256) {
        require(_to != address(0), "can't mint to address(0)");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        Record storage localStruct;
        for (uint256 j = 0; j < _numbers.length; j++) {
            address _localAddress = _addresses[j];
            uint256 _localTokenId = _numbers[j];
            IERC721(_addresses[j]).safeTransferFrom(
                _msgSender(),
                address(this),
                _numbers[j]
            );
            localStruct = _ownedTokens[newItemId][j];
            localStruct.localTokenAddress = _localAddress;
            localStruct.localTokenID = _localTokenId;
        }

        super._safeMint(_to, newItemId);
        emit AssemblyAsset(_to, newItemId, _msgSender(), _addresses, _numbers);
        return newItemId;

    }
*/
    function recordOfOwnerByIndex(uint256 _id, uint256 _index)
        public
        view
        returns (address, uint256)
    {
        return (
            _ownedTokens[_id][_index].localTokenAddress,
            _ownedTokens[_id][_index].localTokenID
        );
    }

    function burn(address _to, uint256 _tokenId) external {
        require(_msgSender() == ownerOf(_tokenId), "not owned");
        super._burn(_tokenId);
        address _localAddress;
        uint256 _localTokenId;
        for (uint256 j = 0; j < _ownedBalance[_tokenId]; j++) {
            Record storage localStruct = _ownedTokens[_tokenId][j];
            _localAddress = localStruct.localTokenAddress;
            _localTokenId = localStruct.localTokenID;
            IERC721(_localAddress).safeTransferFrom(
                address(this),
                _to,
                _localTokenId
            );
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721)
        returns (string memory)
    {
        if (_exists(tokenId) == false) {
            return string(abi.encodePacked(baseURI, "0"));
        }
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    function setBaseURI(string memory _base) external onlyOwner {
        baseURI = _base;
    }

    // Governance

    function setApprovedNFT(address _protocol, bool _status)
        external
        onlyOwner
    {
        approvedNFT[_protocol] = _status;
    }

    function viewApprovedNFT(address _protocol) public view returns (bool) {
        return approvedNFT[_protocol];
    }
}
