import 'package:attendo/home_page.dart';
import 'package:attendo/modals/course_class.dart';
import 'package:attendo/screens/attendence_screens/attendenceScreen.dart';
import 'package:attendo/screens/particular_course_pages/add_message_screen.dart';
import 'package:attendo/screens/particular_course_pages/student_list.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///when Teacher tab on CourseCard, that will take us here
///This page will contain details like::
///[No of Students][Total Classes taken] [List of Students] and
///[Option to take attendence]
///
///
/// This Page will be shown to Teachers

final courseRef = FirebaseFirestore.instance.collection('coursesDetails');

class CourseHomePageForTeacher extends StatefulWidget {
  CourseHomePageForTeacher({this.course, this.user});
  final Course course;
  final User user;

  @override
  _CourseHomePageForTeacherState createState() =>
      _CourseHomePageForTeacherState();
}

class _CourseHomePageForTeacherState extends State<CourseHomePageForTeacher> {
  int currentSegment = 0;
  String teacherName;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final segmentedControlMaxWidth = 600.0;

    //this list contains the Body of the segments
    final children = <int, Widget>{
      0: particularCourseDetailsScreen(),

      ///this 1: will take LIST OF STUDENTS
      ///as of now it is ok
      1: StudentsList(
        course: widget.course,
      ),
      2: AddAssignmentScreen(
        course: widget.course,
        canSendMessages: true,
      ),
    };

    //Headlines of CupertinoSegmentedControl
    final headingChildren = <int, Widget>{
      0: Text('Course'),
      1: Text('Students'),
      2: Text('Remainders'),
    };

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.course.courseName.toUpperCase()),
        trailing: CupertinoButton(
            padding: EdgeInsets.only(bottom: 4),
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return myActionSheet(context);
                },
              );
            },
            child: Icon(CupertinoIcons.ellipsis)),
      ),
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context)
            .textTheme
            .textStyle
            .copyWith(fontSize: 13),
        child: SafeArea(
          child: ListView(
            children: [
              const SizedBox(height: 16),
              SizedBox(
                width: segmentedControlMaxWidth,
                child: CupertinoSegmentedControl<int>(
                  children: headingChildren,
                  onValueChanged: onValueChanged,
                  groupValue: currentSegment,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: children[currentSegment],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // getDataOfThatParticularCourse({String courseCode}) async{
  //   final courseData = await courseRef.doc(courseCode).get();
  //   final String createdBy = await courseData.data()['createdBy'];
  //   teacherName = createdBy;
  // }

  Widget particularCourseDetailsScreen() {
    //TODO: fetch data of a particular from Cloud and Fill in the constructor
    // getDataOfThatParticularCourse(courseCode: widget.course.courseCode);
    return StreamBuilder<DocumentSnapshot>(
      stream: courseRef.doc(widget.course.courseCode).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CupertinoActivityIndicator();
        } else {
          final courseData = snapshot.data;
          final courseName = courseData.data()['courseName'];
          final courseCode = courseData.data()['courseCode'];
          final yearOfBatch = courseData.data()['yearOfBatch'];
          final imagePath = courseData.data()['imagePath'];
          final teacherName = courseData.data()['createdBy'];
          final teacherImageUrl = courseData.data()['teacherImageUrl'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              takeAttendenceButton(),
              CardWidget(
                onTab: null,
                newCourse: Course(
                  teacherImageUrl: teacherImageUrl,
                  courseCode: courseCode,
                  imagePath: imagePath,
                  yearOfBatch: yearOfBatch,
                  courseName: courseName,
                  teacherName: teacherName,
                ),
              ),
              classRecordContainer(),
            ],
          );
        }
      },
    );
  }

  Widget takeAttendenceButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 20, right: 20, bottom: 8),
      child: CupertinoButton.filled(
          child: Text('Take Attendence'),
          onPressed: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return TakeAttendencePage();
            }));
          }),
    );
  }

  ///TODO: later we merge the ClassRecord into CardWidget
  ///Remove teacherName from CardWidget and Add 2 things
  ///1.TOTOAL CLASS TAKEN  2.TOTAL STUDENTS
  Widget classRecordContainer() {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: CupertinoColors.activeBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Total Class taken: 10',
            style: TextStyle(color: CupertinoColors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Total Students: 16',
            style: TextStyle(color: CupertinoColors.white),
          )
        ],
      ),
    );
  }

  myActionSheet(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TakeAttendencePage(),
                  ),
                );
              },
              child: Text('Take Attendence')),
          CupertinoActionSheetAction(
              onPressed: () {
                print('downLoading Sheet');
                Navigator.pop(context);
              },
              child: Text('Download AttendenceSheet')),
          CupertinoActionSheetAction(
              onPressed: () {
                // Navigator.pop(context);
                confirmDeleteAlert(context);
              },
              child: Text(
                'Delete Class',
                style: TextStyle(color: CupertinoColors.destructiveRed),
              )),
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
      ),
    );
  }

  void confirmDeleteAlert(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Confirm delete"),
            content: Text("Do you want to delete the Course?"),
            actions: <Widget>[
              CupertinoDialogAction(
                  // isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.red),
                  // isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    deleteTheCourseFromCloud();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  void deleteTheCourseFromCloud() {}
}
