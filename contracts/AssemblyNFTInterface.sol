pragma solidity ^0.8.0;

interface AssemblyNFTInterface {
    // @dev to assemble lossless assets
    // @param `_to` the receiver of the assembly token
    function mint(
        address _to,
        address[] memory _addresses,
        uint256[] memory _numbers
    ) external payable returns (uint256 tokenId);

    /// @dev mint with additional logic that calculates the actual received value for tokens.
    function safeMint(
        address _to,
        address[] memory _addresses,
        uint256[] memory _numbers
    ) external payable returns (uint256 tokenId);

    // @dev burn this token and releases assembled assets
    // @param `_to` to which address the assets is released
    function burn(
        address _to,
        uint256 _salt,
        address[] calldata _addresses,
        uint256[] calldata _numbers
    ) external;
}
