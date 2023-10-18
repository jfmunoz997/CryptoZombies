// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "./zombieFactory.sol";

contract ZombieFeeding is ZombieFactory {

  constructor(address initialOwner, string memory name_, string memory symbol_) ZombieFactory(initialOwner, name_, symbol_) {
  }

  modifier onlyOwnerOf(uint _zombieId) {
    require(msg.sender == _ownerOf(_zombieId));
    _;
  }

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(block.timestamp + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= block.timestamp);
  }

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    require(_isReady(myZombie));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    _triggerCooldown(myZombie);
  }

  function feedOnKitty(uint _zombieId, string memory _nameForDNA) public { //modified to not import or create cryptoKitty
    uint kittyDna = _generateRandomDna(_nameForDNA);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}
