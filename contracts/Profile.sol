// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract Profile is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 public name;
    bytes32 public encryptionPublicKey;

    constructor(bytes32 _name, bytes32 _encryptionPublicKey) {
        name = _name;
        encryptionPublicKey = _encryptionPublicKey;
    }

    function updateName(bytes32 _name) external onlyOwner {
        name = _name;
    }

    function destroy() external onlyOwner {
        selfdestruct(payable(owner()));
    }
}
