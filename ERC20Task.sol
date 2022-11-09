// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract ERC20 is IERC20 { 

    uint public totalSupply;
    address public owner;
    bool public paused;

    constructor () {
        owner = msg.sender;
        // minting 1K supply for owner at the deployment
        balanceOf[msg.sender] += 1000;
        totalSupply += 1000;
    }

    mapping(address => uint) public balanceOf;

    // to set pause
    function setPause( bool _paused) external {
        require(owner == msg.sender, "Not Owner");
        paused = _paused;
    }

    // to transfer
    function transfer(address recipient, uint amount) external returns (bool) {
        require(!paused, "This function is paused");        

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // to mint supply
    function mint(uint amount) external {
        require(totalSupply + amount <= 10000, "totalSupply should be less then  or equal to 10k"); 
        require(owner == msg.sender, "Not Owner");
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // to burn supply
    function burn(uint amount) external {
        require(owner == msg.sender, "Not Owner");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}