// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./Customizable.sol";

contract Profile is Customizable {
    using EnumerableSet for EnumerableSet.AddressSet;

    bytes32 public name;
    bytes public encryptionPublicKey;

    // EnumerableSet.AddressSet followedChats;

    constructor(bytes32 _name, bytes memory _encryptionPublicKey) {
        require(_encryptionPublicKey.length == 44);

        name = _name;
        encryptionPublicKey = _encryptionPublicKey;
    }

    function profile()
        public
        view
        returns (
            bytes32,
            bytes memory,
            string memory
        )
    {
        return (
            name,
            encryptionPublicKey,
            getCustomKey(keccak256("avatarUrl"))
        );
    }
}
