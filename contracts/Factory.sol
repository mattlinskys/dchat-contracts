// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Profile.sol";
import "./Chat.sol";

contract Factory {
    event ProfileCreated(
        address indexed account,
        address indexed creator,
        bytes32 name
    );

    event ChatCreated(
        address indexed account,
        address indexed creator,
        bytes32 id
    );

    mapping(address => Profile) public profiles;
    mapping(bytes32 => Chat) public chats;

    function createProfile(
        bytes32 name,
        bytes memory encryptionPublicKey,
        bytes32[] memory keys,
        string[] memory values
    ) external {
        require(address(profiles[msg.sender]) == address(0));
        require(name != 0);

        Profile profile = new Profile(name, encryptionPublicKey);
        profile.setCustomKeys(keys, values);
        profile.transferOwnership(msg.sender);
        profiles[msg.sender] = profile;

        emit ProfileCreated(address(profile), msg.sender, name);
    }

    function createChat(address[] memory members) external {
        bytes32 id = keccak256(abi.encodePacked(members));
        require(address(chats[id]) == address(0));

        Chat chat = new Chat(msg.sender, members);
        chats[id] = chat;

        emit ChatCreated(address(chat), msg.sender, id);
    }
}
