// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SensorRegistry {
    
    struct SensorInfo {
        uint256 id;
        string location; // 安装位置，如 "Factory_A"
        bool isRegistered; // 防止重复注册的标志位
    }

    // 1. 核心存储：ID -> 详细信息 (类似于 Flash 里的数据区)
    mapping(uint256 => SensorInfo) public sensors;

    // 2. 索引数组：存储所有已注册的 ID (类似于文件系统的目录表)
    uint256[] public sensorIds;

    // 事件
    event SensorRegistered(uint256 id, string location);

    // 注册新传感器
    function registerSensor(uint256 _id, string memory _location) public {
        // [Check] 检查 ID 是否已存在 (利用 mapping 的 O(1) 查找优势)
        require(!sensors[_id].isRegistered, "ID already exists!");

        // [Effect 1] 存入详细数据
        sensors[_id] = SensorInfo(_id, _location, true);

        // [Effect 2] 记录 ID 到数组 (为了以后能遍历)
        sensorIds.push(_id);

        // [Interaction]
        emit SensorRegistered(_id, _location);
    }

    // 获取传感器总数
    function getSensorCount() public view returns (uint256) {
        return sensorIds.length;
    }

    // --- 核心功能：获取所有传感器 ID ---
    // 注意：如果数组太大，这个函数可能会因为 Gas 超限而无法被合约内部调用，
    // 但外部前端调用是免费的。
    function getAllSensorIds() public view returns (uint256[] memory) {
        return sensorIds;
    }
}