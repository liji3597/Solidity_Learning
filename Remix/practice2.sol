//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract testInt {
    int8 a = -1;
    int16 b = 2;
    uint32 c = 10;
    uint8 d = 16;

    function add(uint x, uint y) public pure returns (uint z) {
        z = x + y;
    }

    function divide(uint x, uint y ) public pure returns (uint z) {
          z = x / y;
    }

    function leftshift(int x, uint y) public pure returns (int z){
        z = x << y;
    }

    function rightshift(int x, uint y) public pure returns (int z){
        z = x >> y;
    }

    function testPlusPlus() public pure returns (uint ) {
        uint x = 1;
        uint y = ++x; // c = ++a;
        return y;
    }

    function testMul1() public pure returns (uint8) {
       unchecked {
        uint8 x = 140;
        uint8 y = x * 2;
        return y;
       }
    }

    function testMul2() public pure returns (uint8) {
        uint8 x = 140;
        uint8 y = x * 2;
        return y;
    }
}