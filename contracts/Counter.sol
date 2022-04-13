// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Counter {
    uint256 total;

    constructor() {
        console.log("Couner initialized");
    }

    function add() public {
        total += 1;
        console.log("%s has added 1 the new total is %s", msg.sender, total);
    }

    function getTotal() public view returns (uint256) {
        console.log("The total is %d!", total);
        return total;
    }
}
