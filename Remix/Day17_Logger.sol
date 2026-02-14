// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlackBox {
    // 定义两种信号
    // 1. 普通日志 (便宜，不能快速检索)
    event SystemLog(string message);

    // 2. 关键告警 (带索引，可像 CAN ID 一样过滤)
    // indexed 允许我们按 errorCode 或 deviceId 快速筛选
    event ErrorOccurred(uint256 indexed errorCode, uint256 indexed deviceId, string message);

    // 模拟系统运行
    function runDiagnostics(uint256 _deviceId) public {
        emit SystemLog("Start diagnostics...");
        
        // 模拟产生一些数据
        if (_deviceId % 2 == 0) {
            emit ErrorOccurred(404, _deviceId, "Sensor not found");
        } else {
            emit SystemLog("Device OK");
        }
        
        emit ErrorOccurred(500, _deviceId, "Voltage unstable");
    }
}