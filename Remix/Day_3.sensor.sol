// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SensorLogger {
    
    // --- 1. 数据结构定义 (类似于 struct) ---
    struct SensorData {
        uint8 id;           // 传感器ID (uint8: 0-255)
        uint16 temperature; // 温度 (定点数: 2550 代表 25.50度)
                            // 注意: Solidity 没有 float/double 类型！必须用整数表示。
        uint32 timestamp;   // UNIX 时间戳
        bool isValid;       // 状态标志位
    }

    // --- 2. 永久存储区 (Flash / Storage) ---
    // 这是一个哈希表：设备ID (Key) -> 传感器数据 (Value)
    // 'public' 关键字会自动生成一个 getter 函数
    mapping(uint256 => SensorData) public sensors;

    // --- 3. 写入函数 (Flash Write) ---
    function updateData(uint256 _deviceId, uint16 _temp) public {
        // [Check] 简单的参数检查
        require(_deviceId > 0, "Invalid Device ID");

        // [Effects] 写入 Storage
        // block.timestamp 是当前区块的时间 (类似于 RTC 时间)
        sensors[_deviceId] = SensorData({
            id: uint8(_deviceId),
            temperature: _temp,
            timestamp: uint32(block.timestamp),
            isValid: true
        });
    }

    // --- 4. 读取函数 (Flash Read) ---
    // 'view' 表示只读，不修改状态。
    // 如果是外部(User)直接调用，不消耗 Gas。如果是合约内部调用，消耗极少 Gas。
    function getTemperature(uint256 _deviceId) public view returns (uint16) {
        // 从 Storage 读取数据到 Memory (RAM)
        SensorData memory data = sensors[_deviceId];
        
        // 检查数据是否有效 (类似于检查 Flash 里的 Magic Number)
        if (data.isValid) {
            return data.temperature;
        } else {
            return 0; // 或者抛出错误
        }
    }
}