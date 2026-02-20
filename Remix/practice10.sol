// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Car {
    string public model;
    address public owner;

    constructor(string memory _model, address _owner) {
        model = _model;
        owner = _owner;
    }

    function getModel() public view returns(string memory) {
        return model;
    }
}

contract CarFactory {
    Car[] private cars;

    function createCar(string memory _model) public {
        Car car = new Car(_model, msg.sender);
        cars.push(car);
    }

    function getCarsCount() public view returns(uint) {
        return cars.length;
    }
}
