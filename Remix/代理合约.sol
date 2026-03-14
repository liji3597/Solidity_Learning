// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ==========================================
// 1. 旧大厨：每次只加 1
// ==========================================
contract LogicV1 {
    address public implementation; 
    uint256 public count;

    function increment() public {
        count += 1;
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}

// ==========================================
// 2. 新大厨 (升级版)：每次加 10！
// ==========================================
contract LogicV2 {
    address public implementation; 
    uint256 public count;          // 必须严格保持和 V1 一样的变量顺序！

    function increment() public {
        count += 10;               // 逻辑升级了！
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}

// ==========================================
// 3. 门店 (代理合约)：永远不变
// ==========================================
contract Proxy {
    address public implementation; 
    uint256 public count;          

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function upgrade(address newImplementation) public {
        implementation = newImplementation;
    }

    fallback() external payable {
        address impl = implementation;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
    receive() external payable {}
}