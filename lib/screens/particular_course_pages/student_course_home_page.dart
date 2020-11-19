import 'package:attendo/modals/course_class.dart';
import 'package:attendo/screens/attendence_screens/attendence_record.dart';
import 'package:attendo/screens/particular_course_pages/add_message_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CourseHomePageForStudent extends StatefulWidget {
  CourseHomePageForStudent({this.course, this.user});
  final Course course;
  final User user;

  @override
  _CourseHomePageForStudentState createState() => _CourseHomePageForStudentState();
}

class _CourseHomePageForStudentState extends State<CourseHomePageForStudent> {

  int currentSegment = 0;

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
      0: AttendenceRecordPage(),
      ///this 1: will take LIST OF STUDENTS
      ///as of now it is ok
      1: AddAssignmentScreen(course: widget.course, canSendMessages: false),
    };

    //Headlines of CupertinoSegmentedControl
    final headingChildren = <int, Widget>{
      0: Text('AttendenceRecord'),
      1: Text('Remainders'),
    };

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset:false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
            widget.course.courseName.toUpperCase()
        ),
        trailing: CupertinoButton(
            padding: EdgeInsets.only(bottom: 4),
            onPressed: (){
              showCupertinoModalPopup(context: context,
                builder: (context){
                  return myActionSheet(context);
                },);
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
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: children[currentSegment],
              ),
            ],
          ),
        ),
      ),
    );;
  }

  ///action sheet
  myActionSheet(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: (){
                print('leaving class');
                Navigator.pop(context);
              },
              child: Text('Leave Class'))
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Cancel')),
      ),
    );
  }

}
