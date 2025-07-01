// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20 {
    string public name;
    string public symbol;
    uint8 public constant decimal = 18;
    uint256 public totalsupply;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) private allowances;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function decimals() public view returns (uint8) {
        return decimal;
    }

    function Totalsupply(uint256 count) public pure returns (uint256) {
        return count * (10 ** uint256(decimal));
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "Insufficient balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(allowances[_from][msg.sender] >= _value, "Insufficient allowance");

    balances[_from] -= _value;
    balances[_to] += _value;
    allowances[_from][msg.sender] -= _value;
    return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] = _value;
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }

    function mint(address to, uint256 amount) public {
        balances[to] += amount;
        totalsupply += amount;
    }

    function burn(address from, uint256 amount) public {
        require(balances[from] >= amount, "Insufficient balance to burn");
        balances[from] -= amount;
        totalsupply -= amount;
    }

}