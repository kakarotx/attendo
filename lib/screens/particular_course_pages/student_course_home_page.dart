import 'package:attendo/home_page.dart';
import 'package:attendo/modals/course_class.dart';
import 'package:attendo/screens/attendence_screens/attendence_record.dart';
import 'package:attendo/screens/particular_course_pages/add_message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:share/share.dart';

final courseRef = FirebaseFirestore.instance.collection('coursesDetails');
final deletedCoursesRef = FirebaseFirestore.instance.collection('deletedCourses');


class CourseHomePageForStudent extends StatefulWidget {
  CourseHomePageForStudent({this.course, this.user});
  final Course course;
  final User user;

  @override
  _CourseHomePageForStudentState createState() =>
      _CourseHomePageForStudentState();
}

class _CourseHomePageForStudentState extends State<CourseHomePageForStudent> {
  int currentSegment = 0;
  bool isCourseDeletedByTeacher = false;
  String deletedClassMsg;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  getDeletedCourseCollection() async{
    final courseDoc = await deletedCoursesRef.doc(widget.course.courseCode).get();
    if(courseDoc.exists){
      setState(() {
        isCourseDeletedByTeacher=true;
        deletedClassMsg=courseDoc.data()['teacherName'];
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeletedCourseCollection();
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
              isCourseDeletedByTeacher?
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    'This course is deleted by $deletedClassMsg.',
                    style:
                    TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                ),
              ):Container(),
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
    );
  }


  _shareClass(BuildContext context){
    final RenderBox box = context.findRenderObject();
    final sharingText = 'This code is shared by ${widget.course.teacherName},'
        'Join ${widget.course.courseName} course with code: ${widget.course.courseCode} on this app [playstoreUrl]';
    Share.share(sharingText,subject: 'download App from',
        sharePositionOrigin: box.localToGlobal(Offset.zero)&box.size);
  }


  ///action sheet
  myActionSheet(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
              onPressed: () {
                print('sharing');
                _shareClass(context);
                // Navigator.pop(context);
              },
              child: Text('Share Class')),
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                confirmDeleteAlert(context);
              },
              child: Text('Leave Class',style: TextStyle(color: CupertinoColors.destructiveRed))),
        ],
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel')),
      ),
    );
  }
  deleteTheCourseFromCLoud(){
    userRef.doc(widget.user.uid).collection('joinedCoursesByUser').doc(widget.course.courseCode).delete();
    courseRef.doc(widget.course.courseCode).collection('studentsEnrolled').doc(widget.user.uid).delete();
  }

  ///this will show a Dailog after we press delete Course button
  ///which has 2 options, [cancel] and [delete]
  void confirmDeleteAlert(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Confirm"),
            content: Text("Do you want to leave the Course?"),
            actions: <Widget>[
              CupertinoDialogAction(
                // isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: CupertinoColors.destructiveRed),
                  // isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    deleteTheCourseFromCLoud();
                    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context)=>HomePage()), (route) => false);

                  },
                  child: Text("Leave")),
            ],
          );
        });
  }
}
