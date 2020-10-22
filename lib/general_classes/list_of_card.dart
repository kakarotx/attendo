import 'package:attendo/general_classes/course_class.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListofCard extends ChangeNotifier{

  List<CardWidget> finalListOfCreatedCourses=[
    CardWidget(course: Course(
      courseCode: 123,yearOfBatch: '2019',courseName: 'abc'
    ),)
  ];

  void addItemToCourseList(CardWidget newCard){
    finalListOfCreatedCourses.add(newCard);
    notifyListeners();
  }

}