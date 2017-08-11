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

import './transaction.sol';

contract Block {
    

    Environment.BlockHeader _blockHeader;
    Environment.BlockHeader[] _ommerBlockHeaders;
    Transaction[] _transactions;

    function Block(Environment.BlockHeader header, Environment.BlockHeader[] ommerBlockHeaders, Transaction[] transactions) {
        _blockHeader = header;
        _ommerBlockHeaders = ommerBlockHeaders;
        _transactions = transactions;
    }

    function finalize() {
        //(1) Validate (or, if mining, determine) ommers;
        //(2) validate (or, if mining, determine) transactions;
        //(3) apply rewards;
        //(4) verify (or, if mining, compute a valid) state and nonce.
    }
}