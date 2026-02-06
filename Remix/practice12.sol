// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CalledContract {
    function getTwo() external pure returns (uint256) {
        return 2;
    }

    function failing() external pure {
        revert("This function always fails");
    }
}

contract TryCatcher {
    CalledContract public externalContract;
    uint256 public result;
    bool public success;

    constructor(address _addr) {
        externalContract = CalledContract(_addr);
    }

    function executeExternal() public {
        // 使用 try/catch 捕获外部调用
        try externalContract.getTwo() returns (uint256 v) {
            // 外部调用成功
            result = v + 2;
            success = true;
        } catch {
            // 外部调用失败
            result = 0;
            success = false;
        }
    }
}

