// SPDX-License-Identifier: MPL-2.0
pragma solidity ^0.8.0;


contract AviancaFlightRegistry {
   
    struct Flight {
        uint256 id;
        string flightNumber;
        string origin;
        string destination;
        bool isInternational;
    }
   
    uint256 private flightCounter;
    mapping(uint256 => Flight) private flights;
   
    // Función para crear un nuevo vuelo
    function createFlight(string memory _flightNumber, string memory _origin, string memory _destination, bool _isInternational) public {
        flightCounter++;
        flights[flightCounter] = Flight(flightCounter, _flightNumber, _origin, _destination, _isInternational);
    }
   
    // Función para actualizar un vuelo existente
    function updateFlight(uint256 _id, string memory _flightNumber, string memory _origin, string memory _destination, bool _isInternational) public {
        require(_id <= flightCounter, "Flight ID does not exist");
        flights[_id] = Flight(_id, _flightNumber, _origin, _destination, _isInternational);
    }
   
    // Función para eliminar un vuelo existente
    function deleteFlight(uint256 _id) public {
        require(_id <= flightCounter, "Flight ID does not exist");
        delete flights[_id];
    }
   
    // Función para obtener información de un vuelo por su ID
    function getFlightById(uint256 _id) public view returns (uint256 id, string memory flightNumber, string memory origin, string memory destination, bool isInternational) {
        require(_id <= flightCounter, "Flight ID does not exist");
        Flight memory flight = flights[_id];
        return (flight.id, flight.flightNumber, flight.origin, flight.destination, flight.isInternational);
    }
   
    // Función para consultar todos los registros de vuelos
    function getAllFlights() public view returns (Flight[] memory) {
        Flight[] memory allFlights = new Flight[](flightCounter);
        for (uint256 i = 1; i <= flightCounter; i++) {
            allFlights[i - 1] = flights[i];
        }
        return allFlights;
    }
}
