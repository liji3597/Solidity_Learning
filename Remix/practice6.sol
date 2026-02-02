// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TODO: 定义一个 Counter 合约，包含：
// - 一个 count 状态变量
// - increment() 函数增加计数
// - getCount() 函数返回当前计数
contract Counter{
    uint public count;

    function increment() public {
        count++;
    }

    function getCount() public view returns (uint)
    {
        return count;
    }
}


// TODO: 定义一个 CounterFactory 合约，包含：
// - createCounter() 函数创建新的 Counter
// - incrementCounter() 函数调用创建的 Counter 的 increment
// - getCounterValue() 函数获取 Counter 的当前值
contract CounterFactory{

    Counter public myCounter;
    function createCounter() public {
        myCounter = new Counter();
    }

    function incrementCounter() public 
    {
        require(address(myCounter) != address(0), "Counter not created yet");
        myCounter.increment();
    }

    function getCounterValue() public view returns(uint)
    {
        require(address(myCounter) != address(0), "Counter not created yet");
        return myCounter.getCount();
    }
}