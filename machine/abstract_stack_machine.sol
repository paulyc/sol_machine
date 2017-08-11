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

contract ExecutionContext {
    AbstractStackMachine _machineCodeExecutor;
    EvmSpec.SystemState _state;

    function ExecutionContext(AbstractStackMachine machineCodeExecutor) {
        _machineCodeExecutor = machineCodeExecutor;
        _state.status = EvmSpec.ExecutionStatus.PRE_EXECUTION;
    }

    function executeTransactionCode(byte[] program) {
        _state.status = EvmSpec.ExecutionStatus.EXECUTING;
        EvmSpec.TransactionSubstate substate;
        while (_state.programCounter < program.length) {
            _machineCodeExecutor.executeInstruction(_state, program, substate);

            if (context._state.status == EvmSpec.ExecutionStatus.HALTED) {
                // we are done here
                return;
            }
        }
        halt(context.systemState);
        _machineCodeExecutor.execute(this, program);
    }

    function getStack() returns (EvmStack) {
        return _state.stack;
    }

    function setStatus(EvmSpec.ExecutionStatus status) {
        _state.status = status;
    }

    function executeNextInstruction() {

    }
}

contract AbstractStackMachine is EthereumABI {
    mapping(byte => function (ExecutionContext) internal) _operandDispatchTable;

    EvmSpec.WorldState _worldState;

    function getContext() returns (ExecutionContext) {
        return new ExecutionContext(this);
    }

    function halt(ExecutionContext context) internal {
        context.setStatus(EvmSpec.ExecutionStatus.HALTED);
    }

    function executeInstruction(EvmSpec.SystemState state, byte[] program, EvmSpec.TransactionSubstate substate) {
        byte operand = program[state.programCounter++];

        _operandDispatchTable[operand](state);
    }

    function execute(ExecutionContext context, byte[] program) {
        context.setStatus(EvmSpec.ExecutionStatus.EXECUTING);

        while (context._state.programCounter < program.length) {
            byte operand = program[context._state.programCounter++];

            _operandDispatchTable[operand](context);

            if (context._state.status == EvmSpec.ExecutionStatus.HALTED) {
                // we are done here
                return;
            }
        }
        halt(context.systemState);
    }

    function isHalted(EvmSpec.SystemState systemState) returns (bool) {
        return systemState.status == EvmSpec.ExecutionStatus.HALTED;
    }
}
