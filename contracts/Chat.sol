// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Customizable.sol";

contract Chat is Customizable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Counters for Counters.Counter;

    event MsgSent(uint256 indexed id, address indexed sender);
    event MemberAdded(address indexed member);
    event MemberRemoved(address indexed member);

    struct Message {
        uint256 id;
        uint256 time;
        uint256 replyTo;
        address sender;
        string data;
        bool encrypted;
    }

    EnumerableSet.AddressSet members;

    Counters.Counter public idCounter;
    mapping(uint256 => Message) public messages;
    mapping(bytes32 => bytes) public messagesCipher;

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

    function membersCount() public view returns (uint256) {
        return members.length();
    }

    function sendMsg(string memory data, uint256 replyTo) public onlyMember {
        idCounter.increment();
        uint256 id = idCounter.current();

        Message memory message;
        message.id = id;
        message.time = block.timestamp;
        message.replyTo = replyTo;
        message.sender = msg.sender;
        message.data = data;

        messages[id] = message;

        emit MsgSent(id, msg.sender);
    }

    function sendCipherMsg(bytes[] memory ciphers, uint256 replyTo)
        public
        onlyMember
    {
        require(members.length() == ciphers.length);

        idCounter.increment();
        uint256 id = idCounter.current();

        Message memory message;
        message.id = id;
        message.time = block.timestamp;
        message.replyTo = replyTo;
        message.sender = msg.sender;
        message.encrypted = true;

        messages[id] = message;
        for (uint256 i = 0; i < ciphers.length; i++) {
            messagesCipher[
                keccak256(abi.encodePacked(id, members.at(i)))
            ] = ciphers[i];
        }

        emit MsgSent(id, msg.sender);
    }

    function addMember(address member) public onlyOwner {
        require(members.add(member));

        emit MemberAdded(member);
    }

    function removeMember(address member) public onlyOwner {
        require(members.remove(member));

        emit MemberRemoved(member);
    }
}
