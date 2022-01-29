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

    function createProfile(bytes32 name, bytes32 encryptionPublicKey) external {
        require(address(profiles[msg.sender]) == address(0));
        require(name != 0);

        Profile profile = new Profile(name, encryptionPublicKey);
        profile.transferOwnership(msg.sender);
        profiles[msg.sender] = profile;

        emit ProfileCreated(address(profile), msg.sender, name);
    }

    function createChat(bytes32 id, address[] memory members) external {
        require(address(chats[id]) == address(0));

        Chat chat = new Chat(msg.sender, members);
        chats[id] = chat;

        emit ChatCreated(address(chat), msg.sender, id);
    }
}
