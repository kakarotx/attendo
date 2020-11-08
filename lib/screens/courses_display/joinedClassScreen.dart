import 'package:attendo/screens/courses_display/create_list_of_joined_class.dart';
import 'package:attendo/screens/courses_display/joinNewClass_popup.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///this screen displays all the classes joined by you
final _fireStore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class JoinedClassScreen extends StatelessWidget {
  List<Text> coursesList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled:true,
              context: context,
              builder: (BuildContext context) => JoinNewClassScreen(),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ),
        // body: BuildListOfJoinedClasses()),
        body: BuildListOfJoinedClasses(),
      ),
    );
  }
}

///LongPressEndDetails
