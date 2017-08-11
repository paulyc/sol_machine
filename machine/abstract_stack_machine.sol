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

import '../ethereum_specification.sol';
import '../ethereum_abi.sol';
import '../logging.sol';

contract ExecutionContext is EvmSpec {
    SystemState _state;
    AbstractStackMachine _vm;
    TransactionSubstate _substate;

    function ExecutionContext(AbstractStackMachine vm) {
        _state.status = ExecutionStatus.PRE_EXECUTION;
        _vm = vm;
    }

    function executeTransactionCode(byte[] program) {

        if (isHalted()) {
            // Already ran in this context! What to do?
        }
        _state.status = ExecutionStatus.EXECUTING;
        _state.executingCode = program;

        while (!isHalted() && _state.programCounter < program.length) {
            byte opCode = program[_state.programCounter++];
            _vm.dispatch(opCode, this);
        }
        if (!isHalted()) {
            halt();
        }
    }

    function getStack() returns (EvmStack) {
        return _state.stack;
    }

    function getGasConsumed() returns (uint256) {
        return _substate.gasConsumed;
    }

    function setStatus(EvmSpec.ExecutionStatus status) {
        _state.status = status;
    }

    function halt() {
        _state.status = ExecutionStatus.HALTED;
    }

    function isHalted() returns (bool) {
        return _state.status == ExecutionStatus.HALTED;
    }

    function consumeGas(uint256 gas) {
        _substate.gasConsumed += gas;
    }
}

contract AbstractStackMachine is EvmSpec, EthereumABI {
    mapping(byte => function (ExecutionContext) internal) _operandDispatchTable;

    WorldState _worldState;

    function getContext() returns (ExecutionContext) {
        return new ExecutionContext(this);
    }

    function dispatch(byte opCode, ExecutionContext context) external {
        _operandDispatchTable[opCode](context);
    }
}
