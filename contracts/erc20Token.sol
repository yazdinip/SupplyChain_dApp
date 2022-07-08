// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import "./erc20Interface.sol";

contract ERC20Token is ERC20Interface{
    
    uint256 constant MAX_UINT256 = 2**256 - 1;
    //token balances for each address
    mapping(address => uint256) public balances;
    //token allowances for each address and spender
    mapping(address => mapping(address => uint256)) public allowed;

    uint256 public totSupply;
    string public symbol;
    string public name;
    uint8 public decimals;

    constructor(
        uint256 _initialAmount,
        string memory _tokenSymbol,
        string memory _tokenName,
        uint8 _decimalPoint
    ) public {
        balances[msg.sender] = _initialAmount;  //initialize sender's balance to _initialAmount
        totSupply = _initialAmount;             //initialize total supply to _initialAmount
        symbol = _tokenSymbol;                  //initialize symbol to _tokenSymbol
        name = _tokenName;                      //initialize name to _tokenName
        decimals = _decimalPoint;               //initialize decimals to _decimalPoint
    }

    function tranfer(address _to, uint256 _value) public returns (bool success) {
        //Check to see if the receipient is not the owner of the token
        if (_to == address(0)) {
            return false;
        }
        if (_value == 0) {
            return false;
        }
        if (_value > balances[msg.sender]) {
            return false;
        }
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        //Check to see if the receipient is not the owner of the token
        if (_to == address(0)) {
            return false;
        }
        if (_value == 0) {
            return false;
        }
        if (_value > allowed[_from][msg.sender]) {
            return false;
        }
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
}

