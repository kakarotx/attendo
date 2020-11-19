
import 'package:flutter/material.dart';


//this is dedicated class for a Course contains everyInfo about that course
class Course extends ChangeNotifier{

  //constructor for COURSE class
  Course({this.courseCode, this.yearOfBatch, this.courseName, this.imagePath,
    this.teacherName, @required this.teacherImageUrl});

  //required variables for any Course
  String courseCode;
  String courseName;
  String yearOfBatch;
  String imagePath;
  String teacherName;
  String teacherImageUrl;

  //we will set it to the UserName
  // String courseTeacher;
  // int semesterCount;

}