//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint counter;

    constructor() {
    }

    // 如何给 counter 赋值
    function set(uint x) public {
        counter = x;
    }

    // 如何返回  counter 变量
    function get() public view returns (uint) {
        return counter;

    }
}
