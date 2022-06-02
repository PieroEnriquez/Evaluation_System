//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract evaluation{
    //Teacher's address so everyone are able to see it
    address public teacher;

    //Set the teacher's address as the one that deploy the contract
    constructor(){
        teacher = msg.sender;
    }

    //Mapping to relate students' ID's hash with their grades
    mapping(bytes32=>uint) grades;

    //Array for students who ask for a revision on their evaluation
    string[] revisions;

    //Events
    event evaluated_student(bytes32);
    event revision_event(string);

    //Modifier for only the teacher can run a command
    modifier onlyTeacher(address _address){
        require(_address == teacher, "You have no permission to run this command");
        _;
    }

    //Function to publish students' grades
    function publishGrades(string memory _idStudent, uint _grade) public onlyTeacher(msg.sender){
        //Calculating the hash of the students' ID
        bytes32 _hashIDStudent = keccak256(abi.encodePacked(_idStudent));

        //Relating students' ID's hash with their grades
        grades[_hashIDStudent] = _grade;

        //Emiting the event
        emit evaluated_student(_hashIDStudent);
    }

    //Function to see an students' grades
    function myGrades(string memory _idStudent) public view returns(uint){
        //Calculating the hash of the students' ID
        bytes32 _hashIDAlumno = keccak256(abi.encodePacked(_idStudent));
        //Grade relate to students' ID's hash
        uint student_grade = grades[_hashIDAlumno];
        //Returning the students' grade
        return student_grade;
    }

    //Function that allows an student to ask for a revision
    function Revision(string memory _idStudent) public{
        //Saving students' ID in the revisions array
        revisions.push(_idStudent);
        //Emiting the event
        emit revision_event(_idStudent);
    }

    //Function for the teahcer in order to see which students want a revision
    function seeRevisions() public view onlyTeacher(msg.sender) returns(string[]memory){
        return revisions;
    }
}