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

// Adapted from the original "yellowpaper" specification,
// which can be found in PDF form at http://yellowpaper.io/

import './evm_stack.sol';

contract EvmSpec {
    enum ExecutionStatus {
        PRE_EXECUTION,
        EXECUTING,
        HALTED
    }

    struct SystemState {
        EvmStack                    stack;
        uint256[]                   memory_;
        mapping(uint256 => uint256) storage_;
        
        uint256 gasAvailable;
        uint256 programCounter;

        ExecutionStatus status;
        byte[] executingCode;
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

    struct AccountState {
        uint256 nonce;
        uint256 balance;
        uint256 storageRoot;
        uint256 codeHash;
    }

    struct WorldState {
        mapping(address => AccountState) state;
    }
    
    struct BlockHeader {
        uint256 parentHash;    // The Keccak 256-bit hash of the par- ent block’s header, in its entirety; formally Hp. ommersHash: The Keccak 256-bit hash of the om-mers list portion of this block; formally Ho. beneficiary: The 160-bit address to which all fees collected from the successful mining of this blockbe transferred; formally H_c.
        uint256 stateRoot;     // The Keccak 256-bit hash of the root node of the state trie, after all transactions are executed and finalisations applied; formally Hr. transactionsRoot: TheKeccak256-bithashofthe root node of the trie structure populated with each transaction in the transactions list portionof the block; formally H_t.
        uint256 receiptsRoot;  // The Keccak 256-bit hash of the rootnode of the trie structure populated with the re- ceipts of each transaction in the transactions list portion of the block; formally H_e.
        uint256 logsBloom;     // The Bloom filter composed from in- dexable information (logger address and log top- ics) contained in each log entry from the receipt of each transaction in the transactions list; formally H_b.
        uint256 difficulty;    // A scalar value corresponding to the dif- ficulty level of this block. This can be calculated from the previous block’s difficulty level and the timestamp; formally H_d.
        uint256 number;        // A scalar value equal to the number of an- cestor blocks. The genesis block has a number of zero; formally H_i.
        uint256 gasLimit;      // A scalar value equal to the current limit of gas expenditure per block; formally H_l.
        uint256 gasUsed;       // A scalar value equal to the total gas used in transactions in this block; formally H_g.
        uint256 timestamp;     // A scalar value equal to the reasonable output of Unix’s time() at this block’s inception; formally H_s.
        bytes   extraData;     // An arbitrary byte array containing data relevant to this block. This must be 32 bytes or fewer; formally H_x.
        uint256 mixHash;       // A 256-bit hash which proves combined with the nonce that a sufficient amount of compu- tation has been carried out on this block; formally H_m.
        uint64  nonce;         // A 64-bit hash which proves combined with the mix-hash that a sufficient amount of compu- tation has been carried out on this block; formally H_n.
    }

    struct TransactionData {
        uint256 nonce;     // A scalar value equal to the number of trans- actions sent by the sender; formally T_n
        uint256 gasPrice;  // A scalar value equal to the number of Wei to be paid per unit of gas for all computa- tion costs incurred as a result of the execution of this transaction; formally T_p
        uint256 gasLimit;  // A scalar value equal to the maximum amount of gas that should be used in executing this transaction. This is paid up-front, before any computation is done and may not be increased later; formally T_g
        address to;        // The 160-bit address of the message call’s recipi- ent or, for a contract creation transaction, ∅, used here to denote the only member of B0 ; formally T_t
        uint256 value;     // A scalar value equal to the number of Wei to be transferred to the message call’s recipient or, in the case of contract creation, as an endowment to the newly created account; formally T_v
        // Values corresponding to the signature of the transaction and used to determine the sender of the transaction; formally T_w, T_r and T_s
        uint8   v;
        uint256 r;
        uint256 s;
        byte[]  initOrInput; // init code for contract creation, input data for message passing
    }
}
