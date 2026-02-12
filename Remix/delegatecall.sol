// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    // 存储实现合约的地址
    address public implementation;
    address public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    // 只有 owner 可以升级实现合约
    function upgradeTo(address newImplementation) external {
        require(msg.sender == owner, "Only owner");
        implementation = newImplementation;
    }

    // 转发所有调用到实现合约
    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "Implementation not set");

        assembly {
            // 复制 calldata 到内存
            calldatacopy(0, 0, calldatasize())

            // 使用 delegatecall 调用实现合约
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)

            // 复制返回数据
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}
