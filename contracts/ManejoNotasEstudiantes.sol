// SPDX-License-Identifier: MPL-2.0
pragma solidity >=0.7.0 <0.9.0;


// MULTIPLIQUE TODAS LAS NOTAS x10 ANTES DE SUBIRLAS AL SISTEMA
// MULTIPLIQUE TODAS LAS NOTAS x10 ANTES DE SUBIRLAS AL SISTEMA
// MULTIPLIQUE TODAS LAS NOTAS x10 ANTES DE SUBIRLAS AL SISTEMA


contract ManejoNotas {
    struct Estudiante {
        string nombre;
        uint256 edad;
        uint256[] notas;
    }


    mapping(uint256 => Estudiante) private claseBC;
    uint256 private idCounter;


    constructor() {
        idCounter = 0;
    }


    // Función para agregar un nuevo estudiante
    function agregarEstudiante(string memory _nombre, uint256 _edad) public {
        claseBC[idCounter] = Estudiante(_nombre, _edad, new uint256[](0));
        idCounter++;
    }


    // Función para agregar una nota a un estudiante por ID
    function subirNota(uint256 _id, uint256 _nota) public {
        Estudiante storage estudiante = claseBC[_id];
        estudiante.notas.push(_nota);
    }


    // Función para obtener las notas de un estudiante por ID
    function buscarNotasPorId(uint256 _id)
        public
        view
        returns (uint256[] memory)
    {
        return claseBC[_id].notas;
    }


    // Función para establecer una nota específica para un estudiante por índice
    function setNota(
        uint256 _id,
        uint256 _index,
        uint256 _nota
    ) public {
        Estudiante storage estudiante = claseBC[_id];


        estudiante.notas[_index] = _nota;
    }


    // Función para eliminar una nota específica de un estudiante por índice
    function deleteNota(uint256 _id, uint256 _index) public {
        Estudiante storage estudiante = claseBC[_id];


        delete estudiante.notas[_index];
    }


    // Función para obtener el promedio de notas de un estudiante por ID
    function getPromedio(uint256 _id) public view returns (uint256) {
        Estudiante storage estudiante = claseBC[_id];
        uint256 suma = 0;
        if (estudiante.notas.length == 0) {
            return 0;
        } else {
            for (uint256 i = 0; i < estudiante.notas.length; i++) {
                suma += estudiante.notas[i];
            }
        }


        return (suma/10) / estudiante.notas.length;
    }
}


