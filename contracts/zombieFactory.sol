// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ZombieFactory is Ownable, ERC721 {

  event NewZombie(uint zombieId, string name, uint dna);

  uint dnaDigits = 16;
  uint dnaModulus = 10 ** dnaDigits;
  uint cooldownTime = 1 days;

  struct Zombie {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Zombie[] public zombies;

 // mapping (uint => address) public zombieToOwner; // _ownerOf
 // mapping (address => uint) ownerZombieCount; //_balanceOf

  constructor(address initialOwner, string memory name_, string memory symbol_) Ownable(initialOwner) ERC721(name_, symbol_) {
    
  }

  function _createZombie(string memory _name, uint _dna) internal {
    zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));
    uint id = zombies.length - 1;
    _safeMint(msg.sender, id);
    //_ownerOf[id] = msg.sender;
    //balanceOf[msg.sender] = balanceOf[msg.sender].add(1);
    emit NewZombie(id, _name, _dna);
  }

  function _generateRandomDna(string memory _str) internal view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    return rand % dnaModulus;
  }

  function createRandomZombie(string memory _name) public {
    require(balanceOf(msg.sender) == 0);
    uint randDna = _generateRandomDna(_name);
    randDna = randDna - randDna % 100;
    _createZombie(_name, randDna);
  }

}
