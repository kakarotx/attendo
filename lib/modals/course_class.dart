import 'dart:math';

import 'package:flutter/material.dart';


//this is dedicated class for a Course contains everyInfo about that course
class Course extends ChangeNotifier{

  //constructor for COURSE class
  Course({this.courseCode, this.yearOfBatch, this.courseName});

  //required variables for any Course
  int courseCode;
  String courseName;
  String yearOfBatch;

  //we will set it to the UserName
  // String courseTeacher;
  // int semesterCount;

  setCourseCodeTo(int code){
    courseCode=code;
  }
  setCourseNameTo(String name){
    courseName=name;
  }
  setYearOfBatchTo(String year){
    yearOfBatch = year;
  }

}