// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 1. 目标合约 (服务端)
contract Target {
    uint256 public data;
    address public sender;

    // 我们要调用的目标函数
    function setData(uint256 _data) public {
        data = _data;
        sender = msg.sender; // 记录是谁调用的
    }
}

// 2. 攻击者合约 (客户端 - 手动组包)
contract Hacker {
    
    // 方法 A: 正常调用 (编译器帮您打包)
    function callNormal(address _target, uint256 _val) public {
        Target(_target).setData(_val);
    }

    // 方法 B: 低级调用 (手搓数据帧 - 重点！)
    function callLowLevel(address _target, uint256 _val) public {
        
        // --- 第一步：手动构建 Payload ---
        // 类似于: uint8_t buffer[36];
        // memcpy(buffer, selector, 4);
        // memcpy(buffer+4, data, 32);
        
        // abi.encodeWithSignature 会自动计算哈希前4字节并拼接参数
        bytes memory payload = abi.encodeWithSignature("setData(uint256 )", _val);

        // --- 第二步：发送裸数据包 ---
        // 类似于: HAL_UART_Transmit(&huart1, payload, len, timeout);
        // .call 返回两个值: success (bool) 和 returnData (bytes)
        (bool success, ) = _target.call(payload);

        require(success, "Call failed!");
    }
}