//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RequireExample {
    address public owner;
    bool public isPaused;

    constructor() {
        owner = msg.sender;
    }
    function setState(bool  _isPaused) public{
        isPaused = _isPaused;
    }
    function restrictedFunction() public view {
        require(!isPaused, "Contract is paused");
        require(msg.sender == owner, "Not owner");
        // 函数逻辑
    }
}
