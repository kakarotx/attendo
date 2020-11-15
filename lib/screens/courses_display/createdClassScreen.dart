import 'package:attendo/modals/course_class.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'createNewClass_popup.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final courseRef = FirebaseFirestore.instance.collection('coursesDetails');


///this Screen displays all the created classes by user
class CreatedClassScreen extends StatefulWidget {
  CreatedClassScreen({this.user});
  final User user;
  @override
  _CreatedClassScreenState createState() => _CreatedClassScreenState();
}

class _CreatedClassScreenState extends State<CreatedClassScreen> {
  List<CardWidget> listOfCourses;
  Course newCourse;

  ///when there will be no classes, we will show [NO CLASSES, CREATE NEW];
  ///zeroCC = zero_created_classes
  ///this above variable will toggle that screen
  bool zeroCC = true;


  ///this function will toggle the ZeroCC screen
  void toggleZeroCCScreen() {
    //TODO: this is where we will toggle ZeroClass Screen
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        child: NestedScrollView(
            headerSliverBuilder: (context, bool innerBoxIsScrolled) {
              return [
                CupertinoSliverNavigationBar(
                  largeTitle: Text('Courses'),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.only(bottom: 2),
                    child: Icon(
                      CupertinoIcons.add,
                      // size: 20,
                    ),
                    onPressed: () async {
                      print('+ pressed');
                      newCourse = await showCupertinoModalBottomSheet<Course>(
                        context: context,
                        builder: (context) => CreateNewClassScreen(
                          toggleScreenCallBack: toggleZeroCCScreen,
                        ),
                      );
                    },
                  ),
                ),
              ];
            },
            body:buildCards()),
            ///TODO: ZeroClass Screen to be made
          ///and it will be controlled here with a bool

      ),
      // child:
    );
  }

  ///building List of CustomCards of Courses after  we add a course
  buildCards() {
    //courseRef.snapshots(),
    return StreamBuilder<QuerySnapshot>(
      stream:userRef.doc(widget.user.uid).collection('createdCoursesByUser').snapshots(),
        builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CupertinoActivityIndicator();
        } else {
          final courses = snapshot.data.docs;
          List<CardWidget> cardWidgets = [];
          for (var course in courses) {
            final courseData = course.data();
            final courseName = courseData['courseName'];
            final courseCode = courseData['courseCode'];
            final yearOfBatch = courseData['yearOfBatch'];
            final imagePath = courseData['imagePath'];
            cardWidgets.add(
              CardWidget(
                newCourse: Course(
                    courseName: courseName,
                    courseCode: courseCode,
                    imagePath: imagePath,
                    yearOfBatch: yearOfBatch.toString()),
                onTabActive: true,
              ),
            );
          }
          return ListView.builder(
              itemCount: cardWidgets.length,
              itemBuilder:(context, int){
                return cardWidgets[int];
              }
          );
        }
      },
    );
  }
}
