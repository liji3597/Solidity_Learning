// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasTest {
    uint256 public counter = 0;

    // 这是一个会触发看门狗复位（Gas耗尽）的函数
    function foreverLoop() public {
        // while(true) 的区块链版本
        while(true) {
            counter++;
        }
    }

    // 这是一个正常的函数，对比Gas消耗
    function normalAdd() public {
        counter++;
    }
}