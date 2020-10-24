import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendo/modals/list_of_course_details.dart';

///this class builds the list of JoinedClasses

class BuildListOfJoinedClasses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {

          return Provider.of<ListOfCourseDetails>(context).finalListOfJoinedCourses[index];

      },
      itemCount: Provider.of<ListOfCourseDetails>(context).finalListOfJoinedCourses.length,

    );
  }
}
