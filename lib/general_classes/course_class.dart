import 'package:flutter/material.dart';


//this is dedicated class for a Course contains everyInfo about that course
class Course extends ChangeNotifier{

  //constructor for COURSE class
  Course({this.courseCode, this.yearOfBatch, this.courseName});

  //required variables for any Course
  int courseCode;
  String courseName;
  // String courseTeacher;
  String yearOfBatch;
  // int semesterCount;
  String imagePath = 'assets/images/artWork/bookworm.jpg';

  // void setCourseNameTo(String newCourseName){
  //   courseName = newCourseName;
  //   notifyListeners();
  // }
  // void setYearTo(String newYear){
  //   yearOfBatch = newYear;
  //   notifyListeners();
  // }
  // void setCodeTo(int newCode){
  //   courseCode= newCode;
  //   notifyListeners();
  // }

}