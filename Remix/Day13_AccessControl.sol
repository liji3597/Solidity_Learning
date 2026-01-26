// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract SupplyChain is AccessControl {
    // 1. 定义角色 (本质上是 bytes32 哈希值)
    // ADMIN_ROLE 是默认管理员角色
    bytes32 public constant LOGISTICS_ROLE = keccak256("LOGISTICS");
    bytes32 public constant FINANCE_ROLE = keccak256("FINANCE");

    constructor() {
        // 2. 给部署者赋予最高管理员权限
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // 3. 只有“物流员”能调用的函数
    function shipProduct() public onlyRole(LOGISTICS_ROLE) {
        // 发货逻辑...
    }

    // 4. 只有“财务”能调用的函数
    function approvePayment() public onlyRole(FINANCE_ROLE) {
        // 付款逻辑...
    }

    // 5. 管理员可以添加新人
    function hireLogistics(address _newWorker) public onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(LOGISTICS_ROLE, _newWorker);
    }
}