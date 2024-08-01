// SPDX-License-Identifier: MPL-2.0
pragma solidity >=0.5.0 <0.9.0;


/*
Realiza un contrato inteligente donde mediante un tiempo definido se puedan realizar
votos, en cuanto el tiempo concluya no deberá generar votos (utilizar mappping, block.
Timestamp, struct, require y storage.
*/


contract TimeLimitedVotes {
    struct Voto {
        uint256 id;
        uint256 opcion;
        bool votoRealizado;
        uint256 horaVoto; // = block.timestamp;
    }


    mapping(address => Voto) private registro;


    uint256 contarId;
    address[] votantes;


    uint256 tiempoRestante;
    uint256 duracionVotaciones = 10;
    uint256 tiempoInicioVotacion = block.timestamp;


    function votar(uint256 _opcion) public {
        tiempoRestante = tiempoRestanteDeVotacion();
        require(tiempoRestante > 0, "Fin de las votaciones");
        require(
            registro[msg.sender].votoRealizado == false,
            "Ya realizaste tu voto!"
        );
        contarId++;


        registro[msg.sender] = Voto({
            id: contarId,
            opcion: _opcion,
            votoRealizado: true,
            horaVoto: block.timestamp
        });


        votantes.push(msg.sender);
    }


    function getAllVotos() public view returns (uint256[] memory) {
        uint256[] memory resultados = new uint256[](contarId);
        for (uint256 i = 0; i < votantes.length; i++) {
            resultados[i] = (registro[votantes[i]]).opcion;
        }
        return resultados;
    }


    function getAllVotosContadosByOpcion(uint256 _opcion)
        public
        view
        returns (uint256)
    {
        uint256 conteo = 0;
        for (uint256 i = 0; i < contarId; i++) {
            if (registro[votantes[i]].opcion == _opcion) {
                conteo++;
            }
        }
        return conteo;
    }


    function getVotoByAddress(address _direccion)
        public
        view
        returns (Voto memory)
    {
        return registro[_direccion];
    }


    function getAllVotantes() public view returns (address[] memory) {
        return votantes;
    }


    function updateVoto(uint256 _opcion) public {
        tiempoRestante = tiempoRestanteDeVotacion();
        require(tiempoRestante > 0, "Fin de las votaciones");
        require(registro[msg.sender].votoRealizado == true);


        registro[msg.sender] = Voto({
            id: registro[msg.sender].id,
            opcion: _opcion,
            votoRealizado: registro[msg.sender].votoRealizado,
            horaVoto: block.timestamp
        });
    }


    function deleteVoto() public {
        tiempoRestante = tiempoRestanteDeVotacion();
        require(tiempoRestante > 0, "Fin de las votaciones");
        require(registro[msg.sender].votoRealizado == true);
        delete registro[msg.sender];


        for (uint256 i = 0; i < votantes.length; i++) {
            if (votantes[i] == msg.sender) {
                delete votantes[i];
            }
        }
    }


    function restaurarTiempo() public {
        tiempoInicioVotacion = (block.timestamp);
    }


    function tiempoRestanteDeVotacion() public view returns (uint256) {
        require(tiempoInicioVotacion <= (block.timestamp), "No es valido");


        uint256 restante = block.timestamp - tiempoInicioVotacion;
        if (restante > duracionVotaciones) {
            restante = 0;
        } else {
            restante = duracionVotaciones - restante;
        }


        return restante;
    }
} 
