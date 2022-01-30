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
    event ProfileRemoved(address indexed account, address indexed creator);

    event ChatCreated(address indexed account, bytes32 id);
    event ChatRemoved(address indexed account, bytes32 indexed id);

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

    function removeProfile() external {
        address account = address(profiles[msg.sender]);
        require(account != address(0));

        delete profiles[msg.sender];
        emit ProfileRemoved(account, msg.sender);
    }

    function createChat(bytes32 id, address[] memory members) external {
        require(address(chats[id]) == address(0));

        Chat chat = new Chat(msg.sender, members);
        chats[id] = chat;

        emit ChatCreated(address(chat), id);
    }

    function removeChat(bytes32 id) external {
        address account = address(chats[id]);
        require(account != address(0));
        require(chats[id].owner() == msg.sender);

        delete chats[id];
        emit ChatRemoved(account, id);
    }
}
