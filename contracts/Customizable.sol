// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Contract module that allows children to customize contract
 * by setting keys with corresponding values.
 * Because mapping is used, there is no need to redeploy contract when
 * public string property needs to be added
 */
abstract contract Customizable is Ownable {
    mapping(bytes32 => string) private _customKeys;

    /**
     * @dev Get custom key
     */
    function getCustomKey(bytes32 key)
        public
        view
        virtual
        returns (string memory)
    {
        return _customKeys[key];
    }

    /**
     * @dev Set custom key
     */
    function setCustomKey(bytes32 key, string memory value)
        public
        virtual
        onlyOwner
    {
        _customKeys[key] = value;
    }

    /**
     * @dev Set multiple custom keys
     */
    function setCustomKeys(bytes32[] memory keys, string[] memory values)
        public
        virtual
        onlyOwner
    {
        for (uint256 i = 0; i < keys.length; i++) {
            _customKeys[keys[i]] = values[i];
        }
    }

    function destroy() public onlyOwner {
        selfdestruct(payable(owner()));
    }
}
