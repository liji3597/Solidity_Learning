// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// --- 1. 定义接口 (相当于 .h 头文件) ---
// 规定所有传感器必须具备读取 value 的能力
interface ISensor {
    // 接口函数只有声明，没有实现 (没有 {})
    function getValue() external view returns (uint256);
}

// --- 2. 具体传感器实现 (相当于 .c 驱动文件) ---
contract TemperatureSensor is ISensor {
    uint256 public temp;
    
    constructor(uint256 _startTemp) {
        temp = _startTemp;
    }

    function setTemp(uint256 _t) public {
        temp = _t;
    }

    // 必须实现接口定义的函数，并加上 override 关键字
    function getValue() external view override returns (uint256) {
        return temp;
    }
}

// --- 3. 中央控制器 (主控 MCU) ---
contract CentralHub {
    
    // 这里的参数类型是接口 ISensor，而不是具体的合约地址
    // 这意味着它可以接收任何实现了 ISensor 的合约
    function readSensor(ISensor _sensorAddress) public view returns (uint256) {
        // 编译器会自动生成底层的 call 指令
        // 相当于: _sensorAddress.call(abi.encodeWithSignature("getValue()"))
        return _sensorAddress.getValue();
    }
    
    // 进阶：批量读取多个传感器
    function readAll(ISensor[] memory _sensors) public view returns (uint256[] memory) {
        uint256[] memory results = new uint256[](_sensors.length);
        for(uint i=0; i<_sensors.length; i++) {
            results[i] = _sensors[i].getValue();
        }
        return results;
    }
}