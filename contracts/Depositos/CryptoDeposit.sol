// SPDX-License-Identifier: MPL-2.0
pragma solidity >=0.8.11;

// Info Importante:
// Wei -> Ether(x) = [ x*10**18 ]
// https://web3-type-converter.onbrn.com/

contract CryptoDeposit {
    struct Cuenta {
        uint256 saldo;
        bytes10 moneda; // representa un array de byte con una longitud de 10
    }

    // se utiliza un mapeo bidimensional para almacenar las cuentas de los usuarios
    mapping(address => mapping(bytes10 => Cuenta)) cuentas;

    // permite a los usuarios depositar una cantidad específica de alguna criptomoneda
    function Depositar(uint256 cantidad, bytes10 moneda) external payable {
        require(msg.value == cantidad, "Cantidad no coincidente..."); // si la variable local 'value' es igual a la cantidad

        Cuenta storage cuenta = cuentas[msg.sender][moneda]; // cuenta de usuario y moneda que quiere depositar
        cuenta.saldo += cantidad; // cuenta.saldo = cuenta.saldo + cantidad

        // actualizamos la moneda si no está actualizada
        if (cuenta.moneda == "") {
            cuenta.moneda = moneda;
        }
    }

    // permite a los usuarios consultar su saldo en una moneda específica
    function getSaldo(bytes10 moneda) external view returns (uint256) {
        return cuentas[msg.sender][moneda].saldo;
    }
}
