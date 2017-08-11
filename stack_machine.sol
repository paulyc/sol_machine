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

import './environment.sol';
import '../ethereum_abi.sol';

contract StackOwner {
    uint256[1024] _stack;
    uint256 _stackPointer; // offset of the invalid element on the very top of stack

    function StackOwner() internal {
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
    
    function stackOffset(uint256 offset) returns (uint256) {
        // this should probably be a debugging only facility
        require(_stackPointer > 0 &&
                _stackPointer >= (offset + 1) &&
                _stackPointer - (offset + 1) < _stack.length);
        return _stack[_stackPointer - (offset + 1)];
    }
}

contract AbstractStackMachine is StackOwner {
    mapping(byte => function () internal
        returns (AbstractStackMachine.ExecutionStatus)) _operandDispatchTable;
    
    Environment.MachineState _machineState;
    uint256 _gasAvailable;
    uint256 _programCounter;

    function AbstractStackMachine() StackOwner() {
        _machineState.stack = _stack; // may not even be necessary
        _programCounter = 0;
    }
    
    enum ExecutionStatus {
        PRE_EXECUTION,
        EXECUTING,
        HALTED
    }
    
    function halt() internal returns (ExecutionStatus) {
        return ExecutionStatus.HALTED;
    }
    
    function executeStop() internal returns (ExecutionStatus) {
        return halt();
    }
    
    function executeAdd() internal returns (ExecutionStatus) {
        --_stackPointer;
        _stack[_stackPointer] += _stack[_stackPointer - 1];
        return ExecutionStatus.EXECUTING;
    }
    
    function executeMul() internal returns (ExecutionStatus) {
        --_stackPointer;
        _stack[_stackPointer] *= _stack[_stackPointer - 1];
        return ExecutionStatus.EXECUTING;
    }
    
    function executeSub() internal returns (ExecutionStatus) {
        --_stackPointer;
        _stack[_stackPointer] -= _stack[_stackPointer - 1];
        return ExecutionStatus.EXECUTING;
    }

    function executeDiv() internal returns (ExecutionStatus) {
        --_stackPointer;
        _stack[_stackPointer] /= _stack[_stackPointer - 1];
        return ExecutionStatus.EXECUTING;
    }

    function execute(bytes program) {
        ExecutionStatus executionStatus = ExecutionStatus.EXECUTING;
        
        while (_programCounter < program.length) {
            byte operand = program[_programCounter++];
            
            (executionStatus) = _operandDispatchTable[operand]();
            
            if (executionStatus == ExecutionStatus.HALTED) {
                // we are done
                break;
            }
        }
    }
}

contract EthereumStackMachine is AbstractStackMachine, EthereumABI {
    function EthereumStackMachine() AbstractStackMachine() {
        _operandDispatchTable[OP_STOP] = executeStop;
        _operandDispatchTable[OP_ADD] = executeAdd;
        _operandDispatchTable[OP_MUL] = executeMul;
        _operandDispatchTable[OP_SUB] = executeSub;
        _operandDispatchTable[OP_DIV] = executeDiv;
    }
    
    struct PostInstructionState {
        
    }
}
