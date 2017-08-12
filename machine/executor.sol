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

import '../evm_stack.sol';

// Hoping this will all end up with no reentrancy issues, that was the goal anyway....

interface MachineCodeExecutor {
    function dispatch(byte opCode, ExecutionContext context);
}

contract ExecutionContext {
    enum ExecutionStatus {
        PRE_EXECUTION,
        EXECUTING,
        HALTED
    }

    struct ExecutionEnvironment {
        address codeOwner;                  // I_a, the address of the account which owns the code that is executing
        address transactionOriginator;      // I_o, the sender address of the transaction that originated this execution.
        uint256 gasPrice;                   // I_p, the price of gas in the transaction that origi- nated this execution
        byte[]  inputData;                  // I_d, the byte array that is the input data to this execution; if the execution agent is a transaction, this would be the transaction data
        address executor;                   // I_s, the address of the account which caused the code to be executing; if the execution agent is a transaction, this would be the transaction sender
        uint256 valuePassedWithExecution;   // I_v, the value, in Wei, passed to this account as part of the same procedure as execution; if the execution agent is a transaction, this would be the transaction value.
        byte[]  machineCode;                // I_b, the byte array that is the machine code to be executed
        uint256 blockHeader;                // I_H, the block header of the present block
        uint256 callOrCreateDepth;          // I_e, the depth of the present message-call or contract-creation (i.e. the number of CALLs or CREATEs being executed at present)
    }

    struct SystemState {
        EvmStack                    stack;
        uint256[]                   memory_;
        mapping(uint256 => uint256) storage_;

        uint256 gasAvailable;
        uint256 gasConsumed;
        uint256 programCounter;

        ExecutionStatus      status;
        ExecutionEnvironment environment;
    }

    SystemState _state;
    MachineCodeExecutor _executor;

    function ExecutionContext(MachineCodeExecutor executor) {
        _executor = executor;
        _state.status = ExecutionStatus.PRE_EXECUTION;
    }

    function executeTransactionCode(byte[] program) {
        if (isHalted()) {
            // Already ran in this context! What to do?
        }
        _state.status = ExecutionStatus.EXECUTING;
        _state.environment.machineCode = program;

        while (!isHalted() && _state.programCounter < program.length) {
            byte opCode = program[_state.programCounter++];
            _executor.dispatch(opCode, this);
        }

        if (!isHalted()) {
            halt();
        }
    }

    function getStack() constant returns (EvmStack) {
        return _state.stack;
    }

    function halt() {
        _state.status = ExecutionStatus.HALTED;
    }

    function isHalted() constant returns (bool) {
        return _state.status == ExecutionStatus.HALTED;
    }

    function consumeGas(uint256 gas) {
        _state.gasConsumed += gas;
    }

    function getGasConsumed() constant returns (uint256) {
        return _state.gasConsumed;
    }
}
