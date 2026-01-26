// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeAccessControl {
    address public owner;
    address public pendingOwner; // 暂存的新管理员地址

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // --- 步骤 1: 现任管理员发起移交 ---
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Unsafe address");
        // 这里不直接改 owner，而是给 pendingOwner 赋值
        pendingOwner = _newOwner;
    }

    // --- 步骤 2: 新管理员确认接收 ---
    // 这个函数必须由 _newOwner 亲自调用
    function acceptOwnership() public {
        // [Check] 检查调用者是不是被指定的接班人
        require(msg.sender == pendingOwner, "You are not the pending owner");
        
        // [Effect] 正式移交
        owner = pendingOwner;
        pendingOwner = address(0); // 清空暂存区
    }
}