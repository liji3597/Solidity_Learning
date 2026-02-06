// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Base {
    uint public a;
    function foo() virtual public {
    	a += 2;
    }
}

contract Sub is Base {

	  function foo() public override {
   // highlight-next-line
        super.foo(); // 或者 Base.foo();
	  	  a += 1;
	  }
}
