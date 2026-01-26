// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventLogger {
    
    // 1. 定义事件 (协议头)
    // indexed 关键字：相当于建立索引，允许外部工具快速过滤搜索 (类似 Wireshark 的 Filter)
    event DataUpdated(uint256 indexed deviceId, uint256 temperature, address indexed operator);
    
    // 报警事件
    event HighTempAlert(uint256 indexed deviceId, uint256 temperature, string message);

    struct SensorData {
        uint16 temperature;
        bool isValid;
    }
    mapping(uint256 => SensorData) public sensors;
    address public owner;

    constructor() { owner = msg.sender; }

    function updateData(uint256 _id, uint16 _temp) public {
        require(msg.sender == owner, "Auth Fail");

        // [Effects] 修改状态
        sensors[_id] = SensorData(_temp, true);

        // [Interaction] 发射事件 (就像 printf)
        // 这条日志会永久记录在区块里，但不会修改 State (省钱)
        emit DataUpdated(_id, _temp, msg.sender);

        // 模拟简单的阈值报警
        if (_temp > 5000) { // 假设 50.00 度是阈值
            emit HighTempAlert(_id, _temp, "Warning: Overheat!");
        }
    }
}