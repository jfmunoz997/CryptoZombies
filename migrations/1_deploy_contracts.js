var Migrations = artifacts.require("ZombieAttack");

var account0 = "0x188D87e4789597d2E5b38e8caF5b3614Be28Ee43"; // first account
var name = "Zombie";
var token = "Zomb";

console.log(account0);

module.exports = function(deployer, ) {
  deployer.deploy(Migrations,account0, name, token);
};