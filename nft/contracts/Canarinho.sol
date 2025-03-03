// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Canarinho is Ownable, ERC721URIStorage {
    using Strings for uint256;

    bool public isSaleOn;
    string public baseURI;
    uint256 public price;
    mapping(address => uint256) public tokens;
    uint256 public immutable MAX_TOKENS_PER_ADDRESS;
    uint256 public immutable MAX_TOKENS;
    uint256 public totalSupply;

    constructor(
        string memory newBaseURI,
        uint256 maxTokensPerAddress,
        uint256 maxTokens,
        uint256 initialPrice
    ) Ownable(msg.sender) ERC721("Canarinho", "CNR") {
        require(
            maxTokensPerAddress < maxTokens,
            "max tokens per address cannot exceed total supply"
        );

        baseURI = newBaseURI;
        MAX_TOKENS_PER_ADDRESS = maxTokensPerAddress;
        MAX_TOKENS = maxTokens;
        price = initialPrice;
    }

    function mint() external payable {
        require(isSaleOn, "sale is off");
        require(totalSupply < MAX_TOKENS, "no more tokens can be minted");
        require(
            tokens[msg.sender] < MAX_TOKENS_PER_ADDRESS,
            "max tokens per address reached"
        );
        require(msg.value >= price, "insufficient ETH");

        _safeMint(msg.sender, totalSupply);

        uint256 excess;
        unchecked {
            totalSupply++;
            ++tokens[msg.sender];
            excess = msg.value - price;
        }

        if (excess > 0) {
            payable(msg.sender).transfer(excess);
        }
    }

    function setPrice(uint256 newPrice) external onlyOwner {
        require(newPrice > 0, "price must be greater than zero");
        price = newPrice;
    }

    function setSaleState(bool _isSaleOn) external onlyOwner {
        isSaleOn = _isSaleOn;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        require(bytes(newBaseURI).length > 0, "baseURI cannot be empty");
        baseURI = newBaseURI;
    }

    function getTokenURI(
        uint256 tokenId
    ) external view tokenMustExist(tokenId) returns (string memory) {
        return string(abi.encodePacked(_baseURI(), tokenId.toString()));
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function contractURI() external view returns (string memory) {
        return string(abi.encodePacked(_baseURI(), "metadata"));
    }

    modifier tokenMustExist(uint256 tokenId) {
        require(_ownerOf(tokenId) != address(0), "token must exist");
        _;
    }
}
