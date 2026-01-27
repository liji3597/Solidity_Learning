// Remix 自动注入了 ethers 库，就像自动 include 了头文件
// 这是一个异步函数 (Async/Await)
(async function () {
    try {
        // --- 1. 配置参数 (请填入您的真实信息) ---
        const contractAddress = "0x7b96aF9Bd211cBf6BA5b0dd53aa61Dc5806b6AcE"; // <--- TODO: 粘贴刚才复制的合约地址
        const contractName = "LogisticsSystem"; // 合约名字

        console.log(`Connecting to contract: ${contractName} at ${contractAddress}`);

        // --- 2. 获取合约对象 (上位机初始化) ---
        // 在 Remix 脚本里，artifacts 帮我们自动管理了 ABI，不用手动粘贴一大坨 JSON
        // 这相当于: Handle_t hDevice = InitDevice(Address);
        // ... 前面的代码保持不变 ...
        
        // --- 2. 获取合约对象 (上位机初始化) ---
        const metadata = JSON.parse(await remix.call('fileManager', 'getFile', `artifacts/${contractName}.json`));
        
        // [❌ 删除这行报错的代码]
        // const signer = (await ethers.getSigners())[0]; 

        // [✅ 替换为这段代码] 
        // 解释: 利用 Remix 全局注入的 web3 对象来创建一个 Ethers 提供者
        let provider;
        let signer;
        
        if (ethers.providers) {
            // Ethers.js v5 写法 (Remix 常用)
            provider = new ethers.providers.Web3Provider(web3.currentProvider);
            signer = provider.getSigner();
        } else {
            // Ethers.js v6 写法 (新版)
            provider = new ethers.BrowserProvider(web3.currentProvider);
            signer = await provider.getSigner();
        }

        // 实例化合约
        const contract = new ethers.Contract(contractAddress, metadata.abi, signer);

        // ... 后面的代码保持不变 ...

        // --- 3. 读数据 (Read) ---
        // 调用 mapping: orders(101)
        console.log("Reading Order 101 info...");
        const orderId = 101;
        const orderInfo = await contract.orders(orderId);
        
        // 打印结果 (注意: 嵌入式里的枚举 enum 返回的是整数)
        console.log(`[Result] Item: ${orderInfo.item}`);
        console.log(`[Result] State: ${orderInfo.state} (0=Pending, 1=Shipped, 2=Delivered)`);
        console.log(`[Result] Location: ${orderInfo.location}`);

        // --- 4. 写数据 (Write) ---
        // 只有当您是 Admin 且想做操作时才解开下面注释
        // console.log("Updating status...");
        // const tx = await contract.shipOrder(101, "Hong Kong Port");
        // await tx.wait(); // 等待区块确认
        // console.log("Transaction confirmed!");

    } catch (e) {
        console.log(e.message);
    }
});