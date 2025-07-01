// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Mycontract.sol";

contract CounterTest is Test {
    Mycontract counter;

    function setUp() public {
        counter = new Mycontract();
    }

    function testInitialValueIsZero() public {
        assertEq(counter.number(), 0);
    }

    function testSetNumber() public {
        counter.setNumber(42);
        assertEq(counter.number(), 42);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }
}
