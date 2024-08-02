// SPDX-License-Identifier: MPL-2.0
pragma solidity >=0.4.21 <0.9.0;

contract StorageGetSet {
    string nombre;

    constructor() {
        nombre = "NA";
    }

    // Función que se encarga de traer el valor actual de number
    function getNombre() public view returns (string memory) {
        return nombre;
    }

    function setNombre(string memory newNombre) public {
        nombre = newNombre;
    }
}
