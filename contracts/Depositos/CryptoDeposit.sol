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

    uint256 public tiempoFinBloqueo;
    bool public bloqueoPermanente;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // funcion que se encarga de revisar el dueño actual del contrato
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Solo el propietario puede ejecutar esta funcion"
        );
        _;
    }

    modifier retirosDeshabilitados() {
        require(
            bloqueoPermanente,
            "Los retiros estan bloqueados permanentemente"
        );
        require(
            block.timestamp <= tiempoFinBloqueo,
            "Los retiros estan temporalmente bloqueados"
        );
        _;
    }

    // función para transferir la propiedad
    function transferOwnership(address newOwner) public onlyOwner {
        require(
            newOwner != address(0),
            "Nueva direccion de propietario invalida"
        );
        owner = newOwner;
    }

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

    // permite a los usuarios retirar una cantidad específica de alguna criptomoneda
    function retirar(uint256 cantidad, bytes10 moneda)
        external
        retirosDeshabilitados
    {
        Cuenta storage cuenta = cuentas[msg.sender][moneda];
        require(cuenta.saldo >= cantidad, "Saldo insuficiente");

        cuenta.saldo -= cantidad; // cuenta.saldo = cuenta.saldo - cantidad

        bool success = payable(msg.sender).send(cantidad);
        require(success, "Fallo en la transferencia");

        if (cuenta.saldo == 0) {
            delete cuentas[msg.sender][moneda];
        }
    }

    // permite al dueño del contrato bloquear los retiros temporalmente.
    function bloquearRetirosTemp(uint256 tiempoBloqueo) public onlyOwner {
        require(!bloqueoPermanente, "Los retiros ya se encuentran bloqueados.");
        tiempoFinBloqueo = block.timestamp + tiempoBloqueo;
    }

    // permite al dueño del contrato bloquear los retiros permanentemente.
    function bloquearRetirosPerma() public view onlyOwner {
        bloqueoPermanente == true;
    }

    // permite al dueño del contrato retaurar el retiro de activos del contrato.
    function restaurarRetiros() public onlyOwner {
        bloqueoPermanente = false;
        tiempoFinBloqueo = block.timestamp;
    }
}
