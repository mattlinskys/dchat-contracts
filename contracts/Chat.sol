// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Customizable.sol";

contract Chat is Customizable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Counters for Counters.Counter;

    event MsgSent(uint256 indexed id, address indexed sender);

    struct Message {
        uint256 id;
        uint256 time;
        string content;
        uint256 replyTo;
        address sender;
    }

    EnumerableSet.AddressSet members;

    Counters.Counter public idCounter;
    mapping(uint256 => Message) public messages;

    modifier onlyMember() {
        require(members.contains(msg.sender));
        _;
    }

    constructor(address owner, address[] memory membersList) {
        require(membersList.length > 0);

        bool doesMembersContainSender = false;
        for (uint256 i = 0; i < membersList.length; i++) {
            if (membersList[i] == owner) {
                doesMembersContainSender = true;
            }
            members.add(owner);
        }
        require(doesMembersContainSender);

        _transferOwnership(owner);
    }

    function sendMsg(string memory content, uint256 replyTo) public onlyMember {
        idCounter.increment();
        uint256 id = idCounter.current();

        Message memory message;
        message.id = id;
        message.time = block.timestamp;
        message.content = content;
        message.replyTo = replyTo;
        message.sender = msg.sender;

        messages[id] = message;
    }
}
