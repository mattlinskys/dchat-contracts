// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./Customizable.sol";

contract Profile is Customizable {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 public name;

    // EnumerableSet.AddressSet followedChats;

    constructor(bytes32 _name) {
        name = _name;
    }
}
