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

import './stop_arithmetic_ops.sol';

contract EthereumStackMachine is MachineCodeExecutor, StopAndArithmeticOperations {

    // Opcodes
    // Stop and Arithmetic Operations
    byte constant OP_STOP       = 0x00;
    byte constant OP_ADD        = 0x01;
    byte constant OP_MUL        = 0x02;
    byte constant OP_SUB        = 0x03;
    byte constant OP_DIV        = 0x04;
    byte constant OP_SDIV       = 0x05;
    byte constant OP_MOD        = 0x06;
    byte constant OP_SMOD       = 0x07;
    byte constant OP_ADDMOD     = 0x08;
    byte constant OP_MULMOD     = 0x09;
    byte constant OP_EXP        = 0x0a;
    byte constant OP_SIGNEXTEND = 0x0b;

    // Comparison and Bitwise Logic Operations
    byte constant OP_LT     = 0x10;
    byte constant OP_GT     = 0x11;
    byte constant OP_SLT    = 0x12;
    byte constant OP_SGT    = 0x13;
    byte constant OP_EQ     = 0x14;
    byte constant OP_ISZERO = 0x15;
    byte constant OP_AND    = 0x16;
    byte constant OP_OR     = 0x17;
    byte constant OP_XOR    = 0x18;
    byte constant OP_NOT    = 0x19;
    byte constant OP_BYTE   = 0x1a;

    // SHA3
    byte constant OP_SHA3 = 0x20;

    // Environmental Information
    byte constant OP_ADDRESS      = 0x30;
    byte constant OP_BALANCE      = 0x31;
    byte constant OP_ORIGIN       = 0x32;
    byte constant OP_CALLER       = 0x33;
    byte constant OP_CALLVALUE    = 0x34;
    byte constant OP_CALLDATALOAD = 0x35;
    byte constant OP_CALLDATASIZE = 0x36;
    byte constant OP_CALLDATACOPY = 0x37;
    byte constant OP_CODESIZE     = 0x38;
    byte constant OP_CODECOPY     = 0x39;
    byte constant OP_GASPRICE     = 0x3a;
    byte constant OP_EXTCODESIZE  = 0x3b;
    byte constant OP_EXTCODECOPY  = 0x3c;

    // Block Information
    byte constant OP_BLOCKHASH  = 0x50;
    byte constant OP_COINBASE   = 0x51;
    byte constant OP_TIMESTAMP  = 0x52;
    byte constant OP_NUMBER     = 0x53;
    byte constant OP_DIFFICULTY = 0x54;
    byte constant OP_GASLIMIT   = 0x55;

    // Stack, Memory, Storage, and Flow Operations
    byte constant OP_POP      = 0x50;
    byte constant OP_MLOAD    = 0x51;
    byte constant OP_MSTORE   = 0x52;
    byte constant OP_MSTORE8  = 0x53;
    byte constant OP_SLOAD    = 0x54;
    byte constant OP_SSTORE   = 0x55;
    byte constant OP_JUMP     = 0x56;
    byte constant OP_JUMPI    = 0x57;
    byte constant OP_PC       = 0x58;
    byte constant OP_MSIZE    = 0x59;
    byte constant OP_GAS      = 0x5a;
    byte constant OP_JUMPDEST = 0x5b;

    // Push Operations
    byte constant OP_PUSH1  = 0x60;
    byte constant OP_PUSH2  = 0x61;
    byte constant OP_PUSH3  = 0x62;
    byte constant OP_PUSH4  = 0x63;
    byte constant OP_PUSH5  = 0x64;
    byte constant OP_PUSH6  = 0x65;
    byte constant OP_PUSH7  = 0x66;
    byte constant OP_PUSH8  = 0x67;
    byte constant OP_PUSH9  = 0x68;
    byte constant OP_PUSH10 = 0x69;
    byte constant OP_PUSH11 = 0x6a;
    byte constant OP_PUSH12 = 0x6b;
    byte constant OP_PUSH13 = 0x6c;
    byte constant OP_PUSH14 = 0x6d;
    byte constant OP_PUSH15 = 0x6e;
    byte constant OP_PUSH16 = 0x6f;
    byte constant OP_PUSH17 = 0x70;
    byte constant OP_PUSH18 = 0x71;
    byte constant OP_PUSH19 = 0x72;
    byte constant OP_PUSH20 = 0x73;
    byte constant OP_PUSH21 = 0x74;
    byte constant OP_PUSH22 = 0x75;
    byte constant OP_PUSH23 = 0x76;
    byte constant OP_PUSH24 = 0x77;
    byte constant OP_PUSH25 = 0x78;
    byte constant OP_PUSH26 = 0x79;
    byte constant OP_PUSH27 = 0x7a;
    byte constant OP_PUSH28 = 0x7b;
    byte constant OP_PUSH29 = 0x7c;
    byte constant OP_PUSH30 = 0x7d;
    byte constant OP_PUSH31 = 0x7e;
    byte constant OP_PUSH32 = 0x7f;

    // Duplication Operations
    byte constant OP_DUP1  = 0x80;
    byte constant OP_DUP2  = 0x81;
    byte constant OP_DUP3  = 0x82;
    byte constant OP_DUP4  = 0x83;
    byte constant OP_DUP5  = 0x84;
    byte constant OP_DUP6  = 0x85;
    byte constant OP_DUP7  = 0x86;
    byte constant OP_DUP8  = 0x87;
    byte constant OP_DUP9  = 0x88;
    byte constant OP_DUP10 = 0x89;
    byte constant OP_DUP11 = 0x8a;
    byte constant OP_DUP12 = 0x8b;
    byte constant OP_DUP13 = 0x8c;
    byte constant OP_DUP14 = 0x8d;
    byte constant OP_DUP15 = 0x8e;
    byte constant OP_DUP16 = 0x8f;

    // Exchange Operations
    byte constant OP_SWAP1  = 0x90;
    byte constant OP_SWAP2  = 0x91;
    byte constant OP_SWAP3  = 0x92;
    byte constant OP_SWAP4  = 0x93;
    byte constant OP_SWAP5  = 0x94;
    byte constant OP_SWAP6  = 0x95;
    byte constant OP_SWAP7  = 0x96;
    byte constant OP_SWAP8  = 0x97;
    byte constant OP_SWAP9  = 0x98;
    byte constant OP_SWAP10 = 0x99;
    byte constant OP_SWAP11 = 0x9a;
    byte constant OP_SWAP12 = 0x9b;
    byte constant OP_SWAP13 = 0x9c;
    byte constant OP_SWAP14 = 0x9d;
    byte constant OP_SWAP15 = 0x9e;
    byte constant OP_SWAP16 = 0x9f;

    // Logging Operations
    byte constant OP_LOG0 = 0xa0;
    byte constant OP_LOG1 = 0xa1;
    byte constant OP_LOG2 = 0xa2;
    byte constant OP_LOG3 = 0xa3;
    byte constant OP_LOG4 = 0xa4;

    // System Operations
    byte constant OP_CREATE       = 0xf0;
    byte constant OP_CALL         = 0xf1;
    byte constant OP_CALLCODE     = 0xf2;
    byte constant OP_RETURN       = 0xf3;
    byte constant OP_DELEGATECALL = 0xf4;

    // Halt Execution, Mark for Deletion
    byte constant OP_SELFDESTRUCT = 0xff;

    event TransactionComplete();
    event UnhandledException();

    struct AccountState {
        uint256 nonce;
        uint256 balance;
        uint256 storageRoot;
        uint256 codeHash;
    }

    mapping(address => AccountState) WorldState;

    mapping(byte => function (ExecutionContext)) _operandDispatchTable;

    function getContext() returns (ExecutionContext) {
        return new ExecutionContext(this);
    }

    function dispatch(byte opCode, ExecutionContext context) {
        _operandDispatchTable[opCode](context);
    }

    function illegalOperation(ExecutionContext context) {
        UnhandledException();
        revert();
    }

    function EthereumStackMachine() {
        for (uint8 i = 0x00; i <= 0xFF; ++i) {
            _operandDispatchTable[byte(i)] = illegalOperation;
        }

        // Stop and Arithmetic Operations
        _operandDispatchTable[OP_STOP]          = executeStop;
        _operandDispatchTable[OP_ADD]           = executeAdd;
        _operandDispatchTable[OP_MUL]           = executeMul;
        _operandDispatchTable[OP_SUB]           = executeSub;
        _operandDispatchTable[OP_DIV]           = executeDiv;
        _operandDispatchTable[OP_SDIV]          = executeSdiv;
        _operandDispatchTable[OP_MOD]           = executeMod;
        _operandDispatchTable[OP_SMOD]          = executeSmod;
        _operandDispatchTable[OP_ADDMOD]        = executeAddmod;
        _operandDispatchTable[OP_MULMOD]        = executeMulmod;
        _operandDispatchTable[OP_EXP]           = executeExp;
        _operandDispatchTable[OP_SIGNEXTEND]    = executeSignextend;

        // Comparison and Bitwise Logic Operations
        _operandDispatchTable[OP_LT];
        _operandDispatchTable[OP_GT];
        _operandDispatchTable[OP_SLT];
        _operandDispatchTable[OP_SGT];
        _operandDispatchTable[OP_EQ];
        _operandDispatchTable[OP_ISZERO];
        _operandDispatchTable[OP_AND];
        _operandDispatchTable[OP_OR];
        _operandDispatchTable[OP_XOR];
        _operandDispatchTable[OP_NOT];
        _operandDispatchTable[OP_BYTE];

        // SHA3
        _operandDispatchTable[OP_SHA3];

        // Environmental Information
        _operandDispatchTable[OP_ADDRESS];
        _operandDispatchTable[OP_BALANCE];
        _operandDispatchTable[OP_ORIGIN];
        _operandDispatchTable[OP_CALLER];
        _operandDispatchTable[OP_CALLVALUE];
        _operandDispatchTable[OP_CALLDATALOAD];
        _operandDispatchTable[OP_CALLDATASIZE];
        _operandDispatchTable[OP_CALLDATACOPY];
        _operandDispatchTable[OP_CODESIZE];
        _operandDispatchTable[OP_CODECOPY];
        _operandDispatchTable[OP_GASPRICE];
        _operandDispatchTable[OP_EXTCODESIZE];
        _operandDispatchTable[OP_EXTCODECOPY];

        // Block Information
        _operandDispatchTable[OP_BLOCKHASH];
        _operandDispatchTable[OP_COINBASE];
        _operandDispatchTable[OP_TIMESTAMP];
        _operandDispatchTable[OP_NUMBER];
        _operandDispatchTable[OP_DIFFICULTY];
        _operandDispatchTable[OP_GASLIMIT];

        // Stack, Memory, Storage, and Flow Operations
        _operandDispatchTable[OP_POP];
        _operandDispatchTable[OP_MLOAD];
        _operandDispatchTable[OP_MSTORE];
        _operandDispatchTable[OP_MSTORE8];
        _operandDispatchTable[OP_SLOAD];
        _operandDispatchTable[OP_SSTORE];
        _operandDispatchTable[OP_JUMP];
        _operandDispatchTable[OP_JUMPI];
        _operandDispatchTable[OP_PC];
        _operandDispatchTable[OP_MSIZE];
        _operandDispatchTable[OP_GAS];
        _operandDispatchTable[OP_JUMPDEST];

        // Push Operations
        _operandDispatchTable[OP_PUSH1];
        _operandDispatchTable[OP_PUSH2];
        _operandDispatchTable[OP_PUSH3];
        _operandDispatchTable[OP_PUSH4];
        _operandDispatchTable[OP_PUSH5];
        _operandDispatchTable[OP_PUSH6];
        _operandDispatchTable[OP_PUSH7];
        _operandDispatchTable[OP_PUSH8];
        _operandDispatchTable[OP_PUSH9];
        _operandDispatchTable[OP_PUSH10];
        _operandDispatchTable[OP_PUSH11];
        _operandDispatchTable[OP_PUSH12];
        _operandDispatchTable[OP_PUSH13];
        _operandDispatchTable[OP_PUSH14];
        _operandDispatchTable[OP_PUSH15];
        _operandDispatchTable[OP_PUSH16];
        _operandDispatchTable[OP_PUSH17];
        _operandDispatchTable[OP_PUSH18];
        _operandDispatchTable[OP_PUSH19];
        _operandDispatchTable[OP_PUSH20];
        _operandDispatchTable[OP_PUSH21];
        _operandDispatchTable[OP_PUSH22];
        _operandDispatchTable[OP_PUSH23];
        _operandDispatchTable[OP_PUSH24];
        _operandDispatchTable[OP_PUSH25];
        _operandDispatchTable[OP_PUSH26];
        _operandDispatchTable[OP_PUSH27];
        _operandDispatchTable[OP_PUSH28];
        _operandDispatchTable[OP_PUSH29];
        _operandDispatchTable[OP_PUSH30];
        _operandDispatchTable[OP_PUSH31];
        _operandDispatchTable[OP_PUSH32];

        // Duplication Operations
        _operandDispatchTable[OP_DUP1];
        _operandDispatchTable[OP_DUP2];
        _operandDispatchTable[OP_DUP3];
        _operandDispatchTable[OP_DUP4];
        _operandDispatchTable[OP_DUP5];
        _operandDispatchTable[OP_DUP6];
        _operandDispatchTable[OP_DUP7];
        _operandDispatchTable[OP_DUP8];
        _operandDispatchTable[OP_DUP9];
        _operandDispatchTable[OP_DUP10];
        _operandDispatchTable[OP_DUP11];
        _operandDispatchTable[OP_DUP12];
        _operandDispatchTable[OP_DUP13];
        _operandDispatchTable[OP_DUP14];
        _operandDispatchTable[OP_DUP15];
        _operandDispatchTable[OP_DUP16];

        // Exchange Operations
        _operandDispatchTable[OP_SWAP1];
        _operandDispatchTable[OP_SWAP2];
        _operandDispatchTable[OP_SWAP3];
        _operandDispatchTable[OP_SWAP4];
        _operandDispatchTable[OP_SWAP5];
        _operandDispatchTable[OP_SWAP6];
        _operandDispatchTable[OP_SWAP7];
        _operandDispatchTable[OP_SWAP8];
        _operandDispatchTable[OP_SWAP9];
        _operandDispatchTable[OP_SWAP10];
        _operandDispatchTable[OP_SWAP11];
        _operandDispatchTable[OP_SWAP12];
        _operandDispatchTable[OP_SWAP13];
        _operandDispatchTable[OP_SWAP14];
        _operandDispatchTable[OP_SWAP15];
        _operandDispatchTable[OP_SWAP16];

        // Logging Operations
        _operandDispatchTable[OP_LOG0];
        _operandDispatchTable[OP_LOG1];
        _operandDispatchTable[OP_LOG2];
        _operandDispatchTable[OP_LOG3];
        _operandDispatchTable[OP_LOG4];

        // System Operations
        _operandDispatchTable[OP_CREATE];
        _operandDispatchTable[OP_CALL];
        _operandDispatchTable[OP_CALLCODE];
        _operandDispatchTable[OP_RETURN];
        _operandDispatchTable[OP_DELEGATECALL];

        // Halt Execution, Mark for Deletion
        _operandDispatchTable[OP_SELFDESTRUCT];
    }
}
