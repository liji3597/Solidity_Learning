const hre = require("hardhat");

async function main() {
  const ImplementationContract = await hre.ethers.getContractFactory(
    "ImplementationContract"
  );
  // 部署实现合约
  const implementationContract = await ImplementationContract.deploy();
  await implementationContract.deployed();

  console.log("实现合约地址 ", implementationContract.address);

  const MinimalProxyFactory = await hre.ethers.getContractFactory(
    "MinimalProxyFactory"
  );
  // 部署最小工厂合约
  const minimalProxyFactory = await MinimalProxyFactory.deploy();
  await minimalProxyFactory.deployed();

  console.log("最小代理工厂合约地址 ", minimalProxyFactory.address);

  // 在最小工厂合约上调用部署克隆函数并传递参数
  const deployCloneContract = await minimalProxyFactory.deployClone(
    implementationContract.address
  );
  deployCloneContract.wait();

  // 获取部署的代理地址
  const ProxyAddress = await minimalProxyFactory.proxies(0);
  console.log("代理合约地址 ", ProxyAddress);

  // 加载克隆合约
  const proxy = await hre.ethers.getContractAt(
    "ImplementationContract",
    ProxyAddress
  );

  console.log("代理是否已初始化 == ", await proxy.isInitialized()); // 获取已初始化布尔值 == true
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


const hre = require("hardhat");

async function main() {
  const ImplementationContract = await hre.ethers.getContractFactory(
    "ImplementationContract"
  );
  // 部署实现合约
  const implementationContract = await ImplementationContract.deploy();
  await implementationContract.deployed();

  console.log("实现合约地址 ", implementationContract.address);

  const MinimalProxyFactory = await hre.ethers.getContractFactory(
    "MinimalProxyFactory"
  );
  // 部署最小工厂合约
  const minimalProxyFactory = await MinimalProxyFactory.deploy();
  await minimalProxyFactory.deployed();

  console.log("最小代理工厂合约地址 ", minimalProxyFactory.address);

  // 在最小工厂合约上调用部署克隆函数并传递参数
  const deployCloneContract = await minimalProxyFactory.deployClone(
    implementationContract.address
  );
  deployCloneContract.wait();

  // 获取部署的代理地址
  const ProxyAddress = await minimalProxyFactory.proxies(0);
  console.log("代理合约地址 ", ProxyAddress);

  // 加载克隆合约
  const proxy = await hre.ethers.getContractAt(
    "ImplementationContract",
    ProxyAddress
  );

  console.log("代理是否已初始化 == ", await proxy.isInitialized()); // 获取已初始化布尔值 == true
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});