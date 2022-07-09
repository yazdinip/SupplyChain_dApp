// SPDX-License-Identifier: MIT
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

pragma solidity >=0.4.17;


interface IERC20 {
    //uint256 public totSupply;

    // Optional
    // function decimals() external view returns (uint8);
    // function symbol() external view returns (string memory);
    // function name() external view returns (string memory);

    //Required
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function allowance(address _owner, address _spender) external view returns (uint256 remining);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    event Transfer(address indexed _to, address indexed _from, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}
