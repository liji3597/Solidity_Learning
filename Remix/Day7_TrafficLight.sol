//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TrafficLight{
    enum State { Red, Green, Yellow }
    State public currentState;

    uint256 public lastChangeTime;

    event LightChanged(State newState, uint256 timestamp);

    constructor(){
        currentState = State.Red;
        lastChangeTime = block.timestamp;

    }

    function nextState() public {
        uint256 timeElapsed = block.timestamp - lastChangeTime;
        if (currentState == State.Red ) {
            require(timeElapsed >= 10, "Red light: Wait more time!");
            currentState = State.Green;
            
        } 
        else if (currentState == State.Green) {
            require(timeElapsed >= 10, "Green light: Wait more time!");
            currentState = State.Yellow;
            
        }
        else if (currentState == State.Yellow ) {
            require(timeElapsed >= 10, "Yellow light: Wait more time!");
            currentState = State.Red; 
         }
         
         lastChangeTime = block.timestamp;

}

}