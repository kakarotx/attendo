import 'package:attendo/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:attendo/Screens/createNewClass_popup.dart';
import 'package:attendo/screens/create_list_of_created_class.dart';


///this Screen displays all the created classes by you

// ignore: must_be_immutable
class CreatedClassScreen extends StatefulWidget {
  @override
  _CreatedClassScreenState createState() => _CreatedClassScreenState();
}

class _CreatedClassScreenState extends State<CreatedClassScreen> {
  // String kcourseName;
  //
  // String kyearOfBatch;
  //
  // int kcourseCode;

  List<CardWidget> listOfCourses;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => CreateNewClassScreen(

                ),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.black,
          ),
          body: BuildListOfMyClasses()),
    );
  }
}
