// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./Customizable.sol";

contract Profile is Customizable {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 public name;
    bytes32 public encryptionPublicKey;

    // EnumerableSet.AddressSet followedChats;

    constructor(bytes32 _name, bytes32 _encryptionPublicKey) {
        name = _name;
        encryptionPublicKey = _encryptionPublicKey;
    }

    function updateName(bytes32 _name) public onlyOwner {
        name = _name;
    }
}
