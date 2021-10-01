pragma solidity ^0.8.0;

import "./AssemblyNFT.sol";

contract MixAndMatch is AssemblyNFT {
    constructor() ERC721("MixAndMatch", "MAM") {}
}
