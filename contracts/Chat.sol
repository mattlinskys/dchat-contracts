// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Chat is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;
    using Counters for Counters.Counter;

    event MemberAdded(address indexed member);
    event MemberRemoved(address indexed member);
    event MsgSent(uint256 indexed id, address indexed sender);
    event MsgRemoved(uint256 indexed id, address indexed sender);

    struct Message {
        uint256 id;
        uint256 time;
        uint256 replyTo;
        address sender;
    }

    EnumerableSet.AddressSet members;

    Counters.Counter public msgIdCounter;
    mapping(uint256 => Message) public messages;
    EnumerableSet.UintSet messagesKeys;
    mapping(bytes32 => bytes) public messagesCiphertext;

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
            members.add(membersList[i]);
        }
        require(doesMembersContainSender);

        _transferOwnership(owner);
    }

    function membersCount() public view returns (uint256) {
        return members.length();
    }

    function membersAccounts() public view returns (address[] memory) {
        return members.values();
    }

    function addMember(address member) external onlyOwner {
        require(members.add(member));

        emit MemberAdded(member);
    }

    function removeMember(address member) external onlyOwner {
        require(members.remove(member));

        emit MemberRemoved(member);
    }

    function messagesCount() public view returns (uint256) {
        return messagesKeys.length();
    }

    function paginateMessages(uint256 skip, uint256 take)
        public
        view
        returns (Message[] memory)
    {
        Message[] memory _messages = new Message[](take);
        for (uint256 i; i < take; i++) {
            _messages[i] = messages[messagesKeys.at(i + skip)];
        }

        return _messages;
    }

    function sendCipherMsg(
        address[] calldata addresses,
        bytes[] calldata ciphertexts,
        uint256 replyTo
    ) external onlyMember {
        require(addresses.length == ciphertexts.length);

        msgIdCounter.increment();
        uint256 id = msgIdCounter.current();

        Message memory message;
        message.id = id;
        message.time = block.timestamp;
        message.replyTo = replyTo;
        message.sender = msg.sender;

        messages[id] = message;
        messagesKeys.add(id);

        for (uint256 i = 0; i < addresses.length; i++) {
            messagesCiphertext[
                keccak256(abi.encodePacked(id, addresses[i]))
            ] = ciphertexts[i];
        }

        emit MsgSent(id, msg.sender);
    }

    function removeMsg(uint256 id) external {
        require(msg.sender == messages[id].sender);

        delete messages[id];
        messagesKeys.remove(id);

        emit MsgRemoved(id, msg.sender);
    }

    function destroy() external onlyOwner {
        selfdestruct(payable(owner()));
    }
}
