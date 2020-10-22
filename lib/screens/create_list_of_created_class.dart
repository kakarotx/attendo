
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendo/general_classes/list_of_card.dart';


//we have to provide list of Cards to it..
//and it builds the list of createdClasses using ListView.builder

class BuildListOfMyClasses extends StatefulWidget {


  @override
  _BuildListOfMyClassesState createState() => _BuildListOfMyClassesState();
}

class _BuildListOfMyClassesState extends State<BuildListOfMyClasses> {


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Provider.of<ListofCard>(context).finalListOfCreatedCourses[index];
      },
      itemCount: Provider.of<ListofCard>(context).finalListOfCreatedCourses.length,

    );
  }
}
