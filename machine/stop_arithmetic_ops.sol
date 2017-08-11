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

import './abstract_stack_machine.sol';
import '../ethereum_specification.sol';

contract StopAndArithmeticOperationsMachine is AbstractStackMachine {
    function StopAndArithmeticOperationsMachine() AbstractStackMachine() {
        _operandDispatchTable[OP_STOP] = executeStop;
        _operandDispatchTable[OP_ADD] = executeAdd;
        _operandDispatchTable[OP_MUL] = executeMul;
        _operandDispatchTable[OP_SUB] = executeSub;
        _operandDispatchTable[OP_DIV] = executeDiv;
        _operandDispatchTable[OP_SDIV] = executeSdiv;
        _operandDispatchTable[OP_MOD] = executeMod;
        _operandDispatchTable[OP_SMOD] = executeSmod;
        _operandDispatchTable[OP_ADDMOD] = executeAddmod;
        _operandDispatchTable[OP_MULMOD] = executeMulmod;
        _operandDispatchTable[OP_EXP] = executeExp;
        _operandDispatchTable[OP_SIGNEXTEND] = executeSignextend;
    }

    function executeStop(ExecutionContext context) internal {
        halt(context);
    }

    function executeAdd(ExecutionContext context) internal {
        EvmStack stack = context._state._stack;
        uint256 lhs = stack.pop();
        stack.swapTop(lhs + stack.top());
    }

    function executeMul(ExecutionContext context) internal {
        EvmStack stack = context._state._stack;
        uint256 lhs = stack.pop();
        stack.swapTop(lhs * stack.top());
    }

    function executeSub(ExecutionContext context) internal {
        EvmStack stack = context._state._stack;
        uint256 lhs = stack.pop();
        stack.swapTop(lhs - stack.top());
    }

    function executeDiv(ExecutionContext context) internal {
        EvmStack stack = context._state._stack;
        uint256 numerator = stack.pop();
        uint256 denominator = stack.top();
        if (denominator == 0) {
            stack.swapTop(0);
        } else {
            stack.swapTop(numerator / denominator);
        }
    }

    function executeSdiv(ExecutionContext context) internal {
        EvmStack stack = context._state._stack;
        int256 numerator = int256(stack.pop());
        int256 denominator = int256(stack.top());
        if (denominator == 0) {
            stack.swapTop(0);
        } else if (numerator == 0x800000000000000000000000000000000000000000000000 && denominator == -1) {
            // If you were wondering, 0x800000000000000000000000000000000000000000000000 is binary 2's complement for -2^255
            // and although -2^255 / -1 = 2^255 in normal math, in signed 256-bit 2's complement, it overflows,
            // so the actual result here is -2^255. Don't ask me, I don't make the rules, I just implement them
            stack.swapTop(0x800000000000000000000000000000000000000000000000);
        } else {
            stack.swapTop(uint256(numerator / denominator));
        }
    }

    function executeMod(ExecutionContext context) internal {
        EvmStack stack = context._state._stack;
        uint256 numerator = stack.pop();
        uint256 denominator = stack.top();
        if (denominator == 0) {
            stack.swapTop(0);
        } else {
            stack.swapTop(numerator % denominator);
        }
    }

    function executeSmod(ExecutionContext context) internal {
        EvmStack stack = context._state._stack;
        int256 numerator = int256(stack.pop());
        int256 denominator = int256(stack.top());
        if (denominator == 0) {
            stack.swapTop(0);
        } else {
            stack.swapTop(uint256(numerator % denominator));
        }
    }

    function executeAddmod(ExecutionContext context) internal {
        // stubbed no-op
    }

    function executeMulmod(ExecutionContext context) internal {
        // stubbed no-op
    }

    function executeExp(ExecutionContext context) internal {
        // stubbed no-op
    }

    function executeSignextend(ExecutionContext context) internal {
        // stubbed no-op
    }
}
