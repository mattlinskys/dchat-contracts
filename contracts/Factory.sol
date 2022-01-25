// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Chat.sol";

contract Factory {
    event ChatCreated(
        address indexed account,
        address indexed creator,
        bytes32 id
    );

    mapping(bytes32 => Chat) public chats;

    function createChat(address[] memory members) external {
        bytes32 id = keccak256(abi.encodePacked(members));
        require(address(chats[id]) == address(0));

        Chat chat = new Chat(msg.sender, members);
        chats[id] = chat;

        emit ChatCreated(address(chat), msg.sender, id);
    }
}
