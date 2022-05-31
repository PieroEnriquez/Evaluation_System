//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract evaluation{
    //Teacher's address so everyone are able to see it
    address public teacher;

    //Set the teacher's address as the one that deploy the contract
    constructor(){
        teacher = msg.sender;
    }

    //Mapping to relate student's ID's hash with their grades
    mapping(bytes32=>uint) grades;

    //Array de alumnos que piden revisiones de examen
    string[] revisiones;

    //Eventos
    event alumno_evaluado(bytes32);
    event evento_revision(string);

    //Modificador para que solo ejecute el profesor
    modifier soloProfesor(address _address){
        require(_address == teacher, "No tienes permiso para ejecutar esta funcion");
        _;
    }

    //Funcion en la que se publican las notas
    function publicarNotas(string memory _idAlumno, uint _nota) public soloProfesor(msg.sender){
        //Hash del ID del alumno
        bytes32 _hashIDAlumno = keccak256(abi.encodePacked(_idAlumno));

        //Relacionar el hash del ID del alumno con su nota
        grades[_hashIDAlumno] = _nota;

        //Emitir un evento
        emit alumno_evaluado(_hashIDAlumno);
    }

    //Funcion para ver las notas de un alumno
    function verNotas(string memory _idAlumno) public view returns(uint){
        //Hash del ID del alumno
        bytes32 _hashIDAlumno = keccak256(abi.encodePacked(_idAlumno));
        //Nota asociada al ID del alumno
        uint nota_alumno = grades[_hashIDAlumno];
        //Visualizar la nota
        return nota_alumno;
    }

    //Funcion que permita pedir una revision del examen
    function Revision(string memory _idAlumno) public{
        //Almacenamiento de la identidad de un alumno en un array
        revisiones.push(_idAlumno);
        //Emision del evento
        emit evento_revision(_idAlumno);
    }

    //Funcion que permita ver las revisiones
    function verRevisiones() public view soloProfesor(msg.sender) returns(string[]memory){
        return revisiones;
    }
}