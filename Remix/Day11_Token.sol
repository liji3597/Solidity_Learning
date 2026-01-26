// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract IoTRewardOptimized is ERC20, Ownable{
    constructor() ERC20("IoT Reward Token", "IORT") Ownable(msg.sender){

        _mint(msg.sender, 1000*10**18);

    }


    function rewardDevice(address _device, uint256 _amount) public onlyOwner{

        _mint(_device, _amount);
    }

    function initialmint() internal {
        _mint(msg.sender, 100 * 10**decimals());
    }

}

