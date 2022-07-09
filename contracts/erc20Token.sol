// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "./erc20Interface.sol";

contract ERC20Token is IERC20{
    
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
    ) {
        balances[msg.sender] = _initialAmount;  //initialize sender's balance to _initialAmount
        totSupply = _initialAmount;             //initialize total supply to _initialAmount
        symbol = _tokenSymbol;                  //initialize symbol to _tokenSymbol
        name = _tokenName;                      //initialize name to _tokenName
        decimals = _decimalPoint;               //initialize decimals to _decimalPoint
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
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
        emit Transfer(msg.sender, _to, _value);
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
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner)public view returns (uint256 remaining){
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value)public returns (bool success){
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)public view returns(uint256 remaining){
        return allowed[_owner][_spender];
    }

    function totalSupply()public view returns (uint256 totSupp){
        return totSupply;
    }
}

