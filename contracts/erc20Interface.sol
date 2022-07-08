// SPDX-License-Identifier: MIT
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

pragma solidity >=0.4.22 <0.9.0;


contract ERC20Interface {
    uint256 public totSupply;

    // Optional
    // function decimals() public view returns (uint8);
    // function symbol() public view returns (string memory);
    // function name() public view returns (string memory);

    //Required
    function totalSupply() public view returns (uint256);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function allowance(address _owner, address _spender) public view returns (uint256 remining);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    event Transfer(address indexed _to, address indexed _from, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}
