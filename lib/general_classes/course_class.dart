import 'package:flutter/material.dart';
import 'package:attendo/widgets/card_widget.dart';


//this is dedicated class for a Course contains everyInfo about that course

class Course {

  //constructor for COURSE class
  Course({this.classCode, this.courseCard});

  //required variables for any Course
  final int classCode;
  int _courseCode;
  String _courseName;
  String _courseTeacher;
  int _yearOfBatch;
  int _semesterCount;

  //the card in which all detailed  are displayed
  final CardWidget courseCard;

  void setCourseCode(){
    _courseCode = classCode;
  }

  //ignore all these unnecessary error...which are telling that they are unused

  int get semesterCount => _semesterCount;

  set semesterCount(int value) {
    _semesterCount = value;
  }

  int get yearOfBatch => _yearOfBatch;

  set yearOfBatch(int value) {
    _yearOfBatch = value;
  }

  String get courseTeacher => _courseTeacher;

  set courseTeacher(String value) {
    _courseTeacher = value;
  }

  String get courseName => _courseName;

  set courseName(String value) {
    _courseName = value;
  }

  int get courseCode => _courseCode;

  set courseCode(int value) {
    _courseCode = value;
  }
}