// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.0;

contract WalletInsegura {
    mapping(address => uint256) private balances;

    function balance() external view returns (uint256) {
        return address(this).balance;
    }

    function depositar() external payable {
        balances[msg.sender] += msg.value;
    }

    function retirar() external {
        require(balances[msg.sender] > 0, "Balance Insuficiente.");
        (bool success, ) = payable(msg.sender).call{
            value: balances[msg.sender]
        }("");
        require(success, "error al enviar ETH");
        balances[msg.sender] = 0;
    }
}
