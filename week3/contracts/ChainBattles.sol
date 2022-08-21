// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  struct NFTAttributes {
    uint256 level;
    uint256 speed;
    uint256 strength;
    uint256 life;
  }

  mapping(uint256 => NFTAttributes) public tokenIdToAttrs;

  constructor() ERC721("Chain Battles", "CBTLS") {}

  function getLevel (uint256 tokenId) public view returns (string memory) {
    uint256 level = tokenIdToAttrs[tokenId].level;
    return level.toString();
  }

  function getSpeed (uint256 tokenId) public view returns (string memory) {
    uint256 speed = tokenIdToAttrs[tokenId].speed;
    return speed.toString();
  }

  function getStrength (uint256 tokenId) public view returns (string memory) {
    uint256 strength = tokenIdToAttrs[tokenId].strength;
    return strength.toString();
  }
  
  function getLife (uint256 tokenId) public view returns (string memory) {
    uint256 life = tokenIdToAttrs[tokenId].life;
    return life.toString();
  }

  function generateCharacter(uint256 tokenId) public returns(string memory){
    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevel(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
  }

  function getTokenURI(uint256 tokenId) public returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
  }

  function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    NFTAttributes memory attrs = NFTAttributes(1, 10, 10, 1);
    tokenIdToAttrs[newItemId] = attrs;
    _setTokenURI(newItemId, getTokenURI(newItemId));
  }

  function train(uint256 tokenId) public {
    require(_exists(tokenId), "Use an existing token");
    require(ownerOf(tokenId) == msg.sender, "Only owner can train");
    NFTAttributes memory currentAttrs = tokenIdToAttrs[tokenId];
    tokenIdToAttrs[tokenId] = NFTAttributes(
      currentAttrs.level+1, 
      currentAttrs.speed * currentAttrs.level * 2,
      currentAttrs.strength * currentAttrs.level * 2,
      currentAttrs.life + currentAttrs.level * 2
    );
    _setTokenURI(tokenId, getTokenURI(tokenId));
  }
}