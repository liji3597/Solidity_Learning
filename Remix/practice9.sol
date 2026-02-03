// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BytesUtils {
    bytes public data;

    // TODO: 添加多个字节
    function appendBytes(bytes memory newData) public {
        // 你的代码
        data = bytes.concat(data, newData);
    }

    // TODO: 清空数组
    function clear() public {
        // 你的代码
        delete data;
    }

    // TODO: 反转字节数组
    function reverse() public {
        // 你的代码
        uint length = data.length;

        for(uint  i=0; i < length/2; i++)
        {
            bytes1 temp = data[i];

            data[i] = data[length - 1 - i];

            data[length - 1 - i] = temp;
        }
    }
}
