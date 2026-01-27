// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// --- 1. 模拟预言机 (ADC) ---
contract MockOracle {
    // 定义一个请求ID计数器
    uint256 private requestId = 0;
    
    // 记录谁发起了请求 (Mapping: RequestID => ClientAddress)
    mapping(uint256 => address) public pendingRequests;

    // 事件：通知链下节点 "有人要数据！"
    event RequestData(uint256 id, string url);

    // 1. 接收请求 (CPU 发指令给 ADC)
    function requestWeather(string memory _url) external returns (uint256) {
        requestId++;
        pendingRequests[requestId] = msg.sender;
        
        // 发射事件，链下的 Python/JS 脚本会监听到这个事件
        emit RequestData(requestId, _url);
        return requestId;
    }

    // 2. 回填数据 (ADC 转换完成，触发中断)
    // 在真实场景中，这个函数只有 Chainlink 节点能调用
    function fulfill(uint256 _id, uint256 _temperature) external {
        address client = pendingRequests[_id];
        require(client != address(0), "Request not found");

        // 回调客户端的 fulfillWeather 函数
        // 这里用了接口调用的方式
        IGreenhouse(client).fulfillWeather(_id, _temperature);
        
        // 清除请求
        delete pendingRequests[_id];
    }
}

// 定义客户端接口 (为了让 Oracle 能回调)
interface IGreenhouse {
    function fulfillWeather(uint256 _requestId, uint256 _temp) external;
}

// --- 2. 智能温室 (用户应用) ---
contract SmartGreenhouse is IGreenhouse {
    MockOracle public oracle;
    
    uint256 public temperature; // 当前温度
    bool public sprinklerOn;    // 洒水器状态
    
    // 只有 Oracle 能回调我 (安全检查)
    modifier onlyOracle() {
        require(msg.sender == address(oracle), "Only Oracle can call this");
        _;
    }

    constructor(address _oracleAddress) {
        oracle = MockOracle(_oracleAddress);
    }

    // A. 发起请求
    function updateWeather() public {
        // 调用 Oracle 合约
        oracle.requestWeather("api.weather.com/shanghai");
    }

    // B. 接收回调 (相当于 ISR 中断服务函数)
    function fulfillWeather(uint256, uint256 _temp) external override onlyOracle {
        temperature = _temp;
        
        // 自动化逻辑: 如果超过 30度，打开洒水器
        if (_temp > 30) {
            sprinklerOn = true;
        } else {
            sprinklerOn = false;
        }
    }
}