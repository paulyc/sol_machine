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

library Environment {
    struct SystemState {
        uint256[1024]               stack;
        uint256[]                   memory_;
        mapping(uint256 => uint256) storage_;
        
        uint256 gasAvailable;
        uint256 programCounter;
        uint256 stackPointer;
    }
    
    struct ExecutionState {
        SystemState systemState;
        
        uint256 gasAvailable;
        uint256 programCounter;
        uint256 stackPointer;
    }
    
    struct MachineState {
        uint256[]                   stack;
        uint256[]                   memory_;
        mapping(uint256 => uint256) storage_;
    }
    
    struct ExecutionEnvironment {
        address codeOwner;
        address transactionOriginator;
        uint256 gasPrice;
        byte[] inputData; // if the execution agent is a transaction, this would be the transaction data
        uint256 valuePassedWithExecution; // if the execution agent is a transaction, this would be the transaction value
        byte[] machineCode;
        uint256 blockHeader;
        uint256 callOrCreateDepth; // the depth of the present message-call or contract-creation (i.e. the number of CALLs or CREATEs being executed at present)
    }
}
