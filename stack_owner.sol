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

contract StackOwner {
    uint256[] _stack;
    uint256 _stackPointer; // offset of the invalid element on the very top of stack

    function StackOwner(uint256 stackSize) internal {
        _stack.length = stackSize;
        _stackPointer = 0;
    }

    function push(uint256 value) {
        require(_stackPointer < _stack.length);
        _stack[_stackPointer++] = value;
    }

    function pop() returns (uint256) {
        require(_stackPointer > 0);
        return _stack[--_stackPointer];
    }

    function top() returns (uint256) {
        require(_stackPointer > 0);
        return _stack[_stackPointer - 1];
    }

    function isEmpty() returns (bool) {
        return _stackPointer > 0;
    }

    function size() returns (uint256) {
        return _stackPointer;
    }

    function capacity() returns (uint256) {
        return _stack.length;
    }

    function stackOffset(uint256 offset) returns (uint256) {
        // this should probably be a debugging only facility
        require(_stackPointer > 0 &&
            _stackPointer >= (offset + 1) &&
            _stackPointer - (offset + 1) < _stack.length);
        return _stack[_stackPointer - (offset + 1)];
    }

    function setTop(uint256 value) returns (uint256) {
        require(_stackPointer > 0);
        uint256 top = top();
        _stack[_stackPointer - 1] = value;
        return top;
    }
}
