pragma solidity 0.4.24;

import "./Ownable.sol";
import "./StandardToken.sol";


contract CoAlphaToken is StandardToken, Ownable {
    string public name = "CoAlphaToken";
    string public symbol = "CAL";
    uint8 public decimals = 2;
    uint public initialSupply = 2000000000*(10**uint256(decimals));

    constructor() public {
        totalSupply_ = initialSupply;
        balances[msg.sender] = initialSupply;
    }
}