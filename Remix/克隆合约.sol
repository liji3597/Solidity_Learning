// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImplementationContract {
    // ⚠️ 这里把 private 改成了 public，否则最后一步你无法查询它的状态
    bool public isInitialized;      

    function initializer() external {              
        require(!isInitialized, "Already initialized");
        isInitialized = true;     
    }          
}

contract MinimalProxyFactory {
    address[] public proxies;

    function deployClone(address _implementationContract) external returns (address) {
        bytes20 implementationContractInBytes = bytes20(_implementationContract);
        address proxy;
        
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), implementationContractInBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            proxy := create(0, clone, 0x37)
        }
        
        ImplementationContract(proxy).initializer();
        proxies.push(proxy);
        return proxy;
    }
}