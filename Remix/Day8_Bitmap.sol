// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PackedSwitch{
    
    struct Config{
        uint64 startTime;
        uint64 endTime;
        uint8 mode;
        bool isActive;
    }
    Config public sysConfig;

    function updateConfig(uint64 _startTime, uint64 _endTime, uint8 _mode, bool _isActive)
    public{

        sysConfig = Config(_startTime, _endTime, _mode, _isActive);
    }
    }
