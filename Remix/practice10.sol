// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CalculatorOptimized {
    uint public lastResult;

    // --- 优化 1: 定义事件 ---
    // indexed 关键字允许前端快速搜索特定的用户
    event Calculation(address indexed user, string operation, uint result);

    // --- 优化 2: 自定义错误 (省 Gas) ---
    // 当减法导致结果为负数时抛出
    error UnderflowError(uint a, uint b);

    // 1. 加法 (修改状态 + 发送事件)
    function add(uint a, uint b) public returns (uint) {
        lastResult = a + b;
        
        // 告诉全世界：有人做了一次加法，结果是 lastResult
        emit Calculation(msg.sender, "Add", lastResult);
        
        return lastResult;
    }

    // 2. 减法 (Pure + 错误检查)
    function subtract(uint a, uint b) public pure returns (uint) {
        // 虽然 0.8.0 会自动报错，但手动检查可以提供更清晰的业务逻辑
        if (b > a) {
            revert UnderflowError(a, b);
        }
        return a - b;
    }

    // 3. 乘法 (View)
    function multiplyByLast(uint a) public view returns (uint) {
        return lastResult * a;
    }

    // 4. 重载加法 (复用逻辑)
    function add(uint a, uint b, uint c) public returns (uint) {
        lastResult = a + b + c;
        
        emit Calculation(msg.sender, "Add3", lastResult);
        
        return lastResult;
    }
}