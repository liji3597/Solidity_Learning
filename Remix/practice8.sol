// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract testArray {
    // storage 位置
    uint[] public arr1 = new uint[](1);

    function add(uint x) public {
        arr1.push(x);
    }

    function arr1Len() public view returns (uint len) {
        return arr1.length;
    }
}
