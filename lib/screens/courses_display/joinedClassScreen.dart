import 'package:attendo/modals/list_of_course_details.dart';
import 'package:attendo/screens/courses_display/create_list_of_joined_class.dart';
import 'package:attendo/screens/courses_display/joinNewClass_popup.dart';
import 'package:attendo/screens/courses_display/zero_class_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

///this screen displays all the classes joined by you
final _fireStore = FirebaseFirestore.instance;

class JoinedClassScreen extends StatefulWidget {
  @override
  _JoinedClassScreenState createState() => _JoinedClassScreenState();
}

class _JoinedClassScreenState extends State<JoinedClassScreen> {
  List<Text> coursesList = [];

  bool zeroJC = true;

  ///this function will toggle the ZeroCC screen
  void toggleZeroCCScreen(){
    if(Provider.of<ListOfCourseDetails>(context, listen: false).
    finalListOfJoinedCourses.length==0){
      setState(() {
        zeroJC = true;
      });
    } else{
      setState(() {
        zeroJC = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled:true,
              context: context,
              builder: (BuildContext context) => JoinNewClassScreen(toggleScreenCallBack: toggleZeroCCScreen,),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ),
        // body: BuildListOfJoinedClasses()),
        body: zeroJC ? ZeroClassScreen(title: 'NO CLASS JOINED',):BuildListOfJoinedClasses(),
      ),
    );
  }
}

///LongPressEndDetails
