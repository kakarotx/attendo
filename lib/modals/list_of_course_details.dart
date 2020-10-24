import 'package:attendo/modals/course_class.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


///this class extends from ChangeNotifies, so this class is used in Provider Package
///most of the Variables which need to update on UI are initialized here

class ListOfCourseDetails extends ChangeNotifier{

  List<CardWidget> finalListOfCreatedCourses=[];

  List<CardWidget> finalListOfJoinedCourses=[];

  List<String> listOfAllCourseCodes=[];

  void addItemToCourseList(CardWidget newCard){
    finalListOfCreatedCourses.add(newCard);
    notifyListeners();
  }

  void addItemToCourseCodeList(String code){
    listOfAllCourseCodes.add(code);
    notifyListeners();
  }

  void addItemToJoinedCoursesList(CardWidget joinCourseCard){
    finalListOfJoinedCourses.add(joinCourseCard);
    notifyListeners();
  }



}