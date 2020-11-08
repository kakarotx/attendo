
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendo/modals/list_of_course_details.dart';


///we have to provide LIST of CARD_WIDGET to it..
///and it builds the list using ListView.builder
///we are not providing LIST through constructor, instead we are
///using Provider_Package

class BuildListOfMyClasses extends StatefulWidget {


  @override
  _BuildListOfMyClassesState createState() => _BuildListOfMyClassesState();
}

class _BuildListOfMyClassesState extends State<BuildListOfMyClasses> {


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {

        if(Provider.of<ListOfCourseDetails>(context).finalListOfCreatedCourses!=null){
          return Provider.of<ListOfCourseDetails>(context).finalListOfCreatedCourses[index];
        }
        else{
          return null;
        }
      },
      itemCount: Provider.of<ListOfCourseDetails>(context).finalListOfCreatedCourses.length,

    );
  }
}
