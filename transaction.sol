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

import './stack_machine.sol';

contract Transaction {
    struct LogTopic {
        byte[32] topic;
    }
    
    struct LogEntry {
        address loggersAddress;
        LogTopic[] topics;
        bytes data;
    }
    
    struct Refund {
        
    }
    
    struct Suicide {
        
    }
    
    struct AccruedSubstrate {
        Suicide[] suicidesSet;
        LogEntry[] logSeries;
        Refund[] refunds;
    }
    
    function Transaction() {
        
    }
    
    function execute(Environment.SystemState systemState, 
                     uint256 remainingGas, 
                     Environment.ExecutionEnvironment executionEnvironment) private
                     returns (Environment.SystemState, uint256, AccruedSubstrate, bytes) {
        AccruedSubstrate storage accruedSubstate;
        bytes storage output;
        return (systemState, remainingGas, accruedSubstate, output);
    }
    
    function verifyTransaction() {
        
    }
}