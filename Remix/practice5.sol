// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PiggyBank {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
// 新增这个函数
    function deposit() public payable {
    // 这里什么都不用写，只要有 payable，钱就会自动进账
}
    // 接收 ETH
    receive() external payable {}

    // 查询余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 提取 ETH（只有 owner 可以）
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }
}
