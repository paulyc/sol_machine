/**
*  Copyright (c) 2017 Paul Ciarlo
*
*  Permission is hereby granted, free of charge, to any person obtaining a copy
*  of this software and associated documentation files (the "Software"), to deal
*  in the Software without restriction, including without limitation the rights
*  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*  copies of the Software, and to permit persons to whom the Software is
*  furnished to do so, subject to the following conditions:
*
*  The above copyright notice and this permission notice shall be included in all
*  copies or substantial portions of the Software.
*
*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*  SOFTWARE.
*/

pragma solidity ^0.4.15;

import '../stack_owner.sol';

contract TestStackOwner {
    StackOwner ownerUnderTest;

    function TestStackOwner() {
    }

    function testInit() {
        ownerUnderTest = new StackOwner(1024);
        require(ownerUnderTest.isEmpty());
        require(ownerUnderTest.capacity() == 1024);
        require(ownerUnderTest.size() == 0);
    }

    function testPush() {
        ownerUnderTest = new StackOwner(1024);
        ownerUnderTest.push(1);
        require(!ownerUnderTest.isEmpty());
        require(ownerUnderTest.size() == 1);
        ownerUnderTest.push(2);
        ownerUnderTest.push(3);
        require(ownerUnderTest.size() == 3);
        require(ownerUnderTest.top() == 3);
        require(ownerUnderTest.stackOffset(2) == 1);
        require(ownerUnderTest.capacity() == 1024);
    }

    function testPop() {
        ownerUnderTest = new StackOwner(1024);
        ownerUnderTest.push(1);
        ownerUnderTest.push(2);
        ownerUnderTest.push(3);
        require(ownerUnderTest.pop() == 3);
        require(ownerUnderTest.top() == 2);
        require(ownerUnderTest.size() == 2);
        require(ownerUnderTest.stackOffset(1) == 1);
        require(ownerUnderTest.pop() == 2);
        require(ownerUnderTest.pop() == 1);
        require(ownerUnderTest.isEmpty());
        require(ownerUnderTest.size() == 0);
        require(ownerUnderTest.capacity() == 1024);
    }

    function testSwapTop() {
        ownerUnderTest = new StackOwner(1024);
        ownerUnderTest.push(1);
        ownerUnderTest.push(2);
        ownerUnderTest.push(3);
        require(ownerUnderTest.swapTop(4) == 3);
        require(ownerUnderTest.top() == 4);
        require(ownerUnderTest.size() == 3);
        require(ownerUnderTest.pop() == 4);
        require(ownerUnderTest.pop() == 2);
        require(ownerUnderTest.pop() == 1);
        require(ownerUnderTest.isEmpty());
    }
}