(async function () {
    try {
        // --- 1. 连接设备 ---
        const contractName = "BlackBox";
        const contractAddress = "0x3D42AD7A3AEFDf99038Cd61053913CFCA4944b95"; // <--- TODO: 替换为您刚才部署的地址
        
        const metadata = JSON.parse(await remix.call('fileManager', 'getFile', `artifacts/${contractName}.json`));
        let provider = new ethers.providers.Web3Provider(web3.currentProvider);
        const contract = new ethers.Contract(contractAddress, metadata.abi, provider);

        console.log(`Analyzing logs for Contract: ${contractAddress}`);

        // --- 2. 设置过滤器 (Filter Setup) ---
        // 就像配置逻辑分析仪的 Trigger
        // 语法: contract.filters.EventName(arg1, arg2)
        // arg1 (errorCode): null 表示"不过滤，接收所有错误码"
        // arg2 (deviceId): 102 表示"只看设备 102"
        const filter = contract.filters.ErrorOccurred(null, 102);

        // --- 3. 查询历史日志 (Query) ---
        // queryFilter(filter, fromBlock, toBlock)
        // 这里的 0 表示从创世区块开始查 (在主网上要慎用，太慢，但在测试网没事)
        const logs = await contract.queryFilter(filter, 0, "latest");

        console.log(`Found ${logs.length} error logs for Device 102:`);

        // --- 4. 解析显示 ---
        logs.forEach((log, index) => {
            // log.args 包含了解码后的参数
            const errCode = log.args.errorCode.toString();
            const devId = log.args.deviceId.toString();
            const msg = log.args.message;
            console.log(`[${index}] Block ${log.blockNumber}: Error ${errCode} on Device ${devId} -> ${msg}`);
        });

    } catch (e) {
        console.log(e.message);
    }
})();