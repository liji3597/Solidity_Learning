// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControlOptimized {
    
    address public owner;
    // 建议把变量名改成 isAdmin，语义更清晰（这是一个判断句：是管理员吗？）
    mapping(address => bool) public isAdmin;

    // --- 优化 1: 定义自定义错误 (省 Gas，替代长字符串) ---
    error NotAuthorized(address caller);
    error OnlyOwnerAllowed();

    constructor() {
        owner = msg.sender;
    }

    // --- 优化 2: 使用 Modifier (修饰符) ---
    // 这是 Solidity 的核心特性，把权限检查提取出来
    modifier onlyAuthorized() {
        // 逻辑：要么是 owner，要么在 isAdmin 表里是 true
        if (msg.sender != owner && !isAdmin[msg.sender]) {
            revert NotAuthorized(msg.sender);
        }
        _; // 继续执行后续代码
    }

    // --- 修复后的 TODO 1: 纯查询函数 ---
    // 这个函数只返回 true/false，绝不报错 (revert)
    // 前端网页可以用这个来决定要不要显示"管理按钮"
    function isAuthorized(address _user) public view returns (bool) {
        return (_user == owner || isAdmin[_user]);
    }

    // --- 修复后的 TODO 2: 授权管理员 ---
    function grantAdmin(address _user) public {
        // 逻辑修正：检查 "我(msg.sender)" 是不是 owner
        if (msg.sender != owner) {
            revert OnlyOwnerAllowed();
        }
        
        isAdmin[_user] = true;
    }

    // --- 修复后的 TODO 3: 受限操作 ---
    // 直接挂上 onlyAuthorized 修饰符，代码极其简洁
    function restrictedAction() public view onlyAuthorized {
        // 这里不需要再写 require 了，modifier 已经帮你挡住了坏人
        
        // 业务逻辑...
    }
}