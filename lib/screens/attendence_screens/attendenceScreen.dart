import 'package:attendo/modals/course_class.dart';
import 'package:attendo/modals/size_config.dart';
import 'package:attendo/modals/student_for_attendance_scree.dart';
import 'package:attendo/screens/particular_course_pages/add_message_screen.dart';
import 'package:attendo/widgets/attendance_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Media Query r2d

final courseRef = FirebaseFirestore.instance.collection('coursesDetails');
final userRef = FirebaseFirestore.instance.collection('users');

class TakeAttendencePage extends StatefulWidget {
  final User user;
  final Course course;
  final List<StudentsForAttendanceCard> list;
  final int noOfStudents;

  TakeAttendencePage({this.user, this.course, this.list,this.noOfStudents});
  @override
  _TakeAttendencePageState createState() => _TakeAttendencePageState(newList: list);
}

class _TakeAttendencePageState extends State<TakeAttendencePage> {

  _TakeAttendencePageState({this.newList});

  final List<StudentsForAttendanceCard> newList;
  List<StudentsForAttendanceCard> dummyList = List<StudentsForAttendanceCard>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('sssssssssssssss ${newList.length}');
  }

  @override
  void dispose() {
    newList.clear();
    super.dispose();
  }

  //this will count no of card swiped
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        // backgroundColor: CupertinoColors.extraLightBackgroundGray,
        navigationBar: CupertinoNavigationBar(
          middle: Text('Attendance Page'),
          // trailing: CupertinoButton(
          //   padding: EdgeInsets.zero,
          //   child: Text("Upload"),
          //   onPressed: () {
          //     _onUpdateButtonPressed(widget.course, dummyList, context);
          //   },
          // ),
        ),
        child: buildStudentsCards(context));
  }

  updateSwipe(){
    return Expanded(
      child: ListView(
        children: [
          Dismissible(
            key: UniqueKey(),
            // child: Text('Dismiss Me'),
            onDismissed: (DismissDirection direction) {
              print('WWWWWWWWW::  dismissed');

              if (direction == DismissDirection.endToStart) {
                // print("left");
                Navigator.pop(context);
              } else {
                _onUpdateButtonPressed(widget.course, dummyList, context);
              }
            },
            // Show a red background as the item is swiped away.
            background: Container(
              padding: EdgeInsets.only(
                right: (SizeConfig.one_W * 150).roundToDouble(),
              ),
              color: CupertinoColors.activeGreen,
              child: Center(
                child: Text(
                  "UPDATE",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.black54),
                ),
              ),
            ),
            secondaryBackground: Container(
              padding: EdgeInsets.only(
                left: (SizeConfig.one_W * 150).roundToDouble(),
              ),
              color: CupertinoColors.destructiveRed,
              child: Center(
                child: Text(
                  "CANCEL",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.black54),
                ),/**/
              ),
            ),
            child: AttendanceCard(
              isThisUpdateCard: true,
              enrolled: "UPDATE ATTENDANCE",
            ),
          ),
        ],
      ),
    );
  }

  //what to return on Attendance screen
  Widget whatToReturn(){
    if(widget.noOfStudents==0){
      return Container(
        child: Center(
          child: Text("CURRENTLY THERE IS NO STUDENT, SWIPE-ABLE CARDS OF STUDENTS WILL BE SHOWN HERE."),
        ),
      );
    } else if((newList.length)==0){
     return updateSwipe();
    } else{
      return attendanceListOfSwipeableCards(context);
    }
  }

  Expanded attendanceListOfSwipeableCards(BuildContext context){
    return Expanded(
      child: ListView.builder(
        itemCount: newList.length,
        itemBuilder: (context, index) {
          final item = UniqueKey().toString();

          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(item),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (DismissDirection dir) {
              count++;
              print("COUNTTTTTTTT:: $count");
              if (dir == DismissDirection.endToStart) {
                print("left");
                widget.list[index].status = false;
                print(widget.list[index].status);
                //markabsent(widget.course, widget.list[index].sid);
              } else {
                print("right");
                widget.list[index].status = true;
                print(widget.list[index].status);
                //markpresent(widget.course, widget.list[index].sid);
              }
              //TODO: Then show a snackbar.
              dummyList.add(newList[index]);
              setState(() {
                newList.removeAt(index);
              });

            },
            // Show a red background as the item is swiped away.
            background: Container(
              padding: EdgeInsets.only(
                right: (SizeConfig.one_W *150).roundToDouble(),
              ),
              color: CupertinoColors.activeGreen,
              child: Center(
                child: Text(
                  "PRESENT",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.black54),
                ),
              ),
            ),
            secondaryBackground: Container(
              padding: EdgeInsets.only(
                left: (SizeConfig.one_W *150).roundToDouble(),
              ),
              color: CupertinoColors.destructiveRed,
              child: Center(
                child: Text(
                  "ABSENT",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.black54),
                ),
              ),
            ),
            child: AttendanceCard(
              enrolled: newList[index].name,
            ),
          );
        },
      ),
    );
  }

  buildStudentsCards(BuildContext context) {
    return SafeArea(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: CupertinoTheme.of(context).barBackgroundColor,
            child: Padding(
              padding: EdgeInsets.only(
                  left: (SizeConfig.one_W * 20).roundToDouble(),
                  top: (SizeConfig.one_H * 10).roundToDouble()),
              child: Column(
                children: [
                  // Text("Must click UPDATE ATTENDANCE BUTTON",style: TextStyle(color: CupertinoColors.destructiveRed),),
                  Row(
                    children: [
                      Icon(CupertinoIcons.right_chevron),
                      Text("Swipe right to mark present")
                    ],
                  ),
                  SizedBox(
                    height: (SizeConfig.one_H * 5).roundToDouble(),
                  ),
                  Row(
                    children: [
                      Icon(CupertinoIcons.left_chevron),
                      Text("Swipe left to mark absent")
                    ],
                  ),
                  // SizedBox(
                  //   height: (SizeConfig.one_H * 5).roundToDouble(),
                  // ),
                  // Row(
                  //   children: [
                  //     Icon(CupertinoIcons.plus),
                  //     Text("Make sure to click Update button at top right")
                  //   ],
                  // ),
                  SizedBox(
                    height: (SizeConfig.one_H * 10).roundToDouble(),
                  ),
                ],
              ),
            ),
          ),
          whatToReturn()
          // confirmUploadButton(widget.course, widget.list, context),
        ],
      ),
    );
  }

  _onUpdateButtonPressed(Course course, List list, BuildContext context) {
    print("WWWWWWWWW::  onUpdateBtn Pressed");
    print("WWWWWWWWW::  lengthOF List = ${dummyList.length}");

    if (newList.length == 0) {
      print("WWWWWWWWW::  entering IF condition");
      print("WWWWWWWWW::  lengthOF List = ${dummyList.length}");
      for (var indx = 0; indx < list.length; indx++) {

        print("WWWWWWWWW::  entering FOR LOOP FOR $indx time");

        increaseTotalClassForEachStudent(course, list[indx].sid);
        if (list[indx].status == true) {
          markpresent(course, list[indx].sid);
          // print("WWWWWWWWW::  ${list[indx].s}");
        } else {
          markabsent(course, list[indx].sid);
        }
      }

      //uploading to cloud
      try {
        courseRef
            .doc(course.courseCode)
            .update({"totalClasses": FieldValue.increment(1)});
        userRef
            .doc(user.uid)
            .collection('createdCoursesByUser')
            .doc(course.courseCode)
            .update({"totalClasses": FieldValue.increment(1)});
      } catch (e) {
        //TODO: show Toast of Unexpected Error
        Fluttertoast.showToast(
            msg: "Unexpected Error, try again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: CupertinoColors.activeBlue,
            textColor: CupertinoColors.white,
            fontSize: 16.0);
      }

      ///take back to previous screen
      Navigator.pop(context);
    } else {
      showDialog();
    }
  }

  markpresent(Course course, String id) {
    print('sourabhid---------------- $id');
    courseRef
        .doc(course.courseCode)
        .collection('studentsEnrolled')
        .doc(id)
        .update({"present": FieldValue.increment(1)});
    userRef
        .doc(id)
        .collection('joinedCoursesByUser')
        .doc(course.courseCode)
        .update({"present": FieldValue.increment(1)});
  }

  markabsent(Course course, String id) {
    print('sourabhid---------------- $id');
    courseRef
        .doc(course.courseCode)
        .collection('studentsEnrolled')
        .doc(id)
        .update({"absent": FieldValue.increment(1)});
    userRef
        .doc(id)
        .collection('joinedCoursesByUser')
        .doc(course.courseCode)
        .update({"absent": FieldValue.increment(1)});
  }

  increaseTotalClassForEachStudent(Course course, String id) {
    userRef
        .doc(id)
        .collection('joinedCoursesByUser')
        .doc(course.courseCode)
        .update({"totalClasses": FieldValue.increment(1)});

    courseRef
        .doc(course.courseCode)
        .collection('studentsEnrolled')
        .doc(id)
        .update({"totalClasses": FieldValue.increment(1)});
  }

  showDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Note"),
            content:
                Text("Swipe all Attendance cards before updating attendance."),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Okays")),
            ],
          );
        });
  }
}
