// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyMapping {
    mapping(address => uint256) private balance; // storage slot 0

    function setValues() public {
        balance[address(0x01)] = 9;
        balance[address(0x03)] = 10;
    }
    
    function getValue(address _key) public view returns (uint256 value) {
        // 调用辅助函数获取
        bytes32 slot = getStorageSlot(_key);

        assembly {
            // 加载存储在槽中的值
            value := sload(slot)
        }
    }
    function getStorageSlot(address _key) public pure returns (bytes32 slot) {
        uint256 balanceMappingSlot;

        assembly {
            // `.slot` 返回状态变量（balance）在存储槽中的位置。
            // 在我们的例子中，0
            balanceMappingSlot := balance.slot
        }

        slot = keccak256(abi.encode(_key, balanceMappingSlot));
    }
}
 

