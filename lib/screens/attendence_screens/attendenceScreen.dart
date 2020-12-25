import 'package:attendo/modals/course_class.dart';
import 'package:attendo/modals/size_config.dart';
import 'package:attendo/modals/student_for_attendance_scree.dart';
import 'package:attendo/screens/particular_course_pages/add_message_screen.dart';
import 'package:attendo/widgets/attendance_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Media Query r2d

final courseRef = FirebaseFirestore.instance.collection('coursesDetails');
final userRef = FirebaseFirestore.instance.collection('users');

class TakeAttendencePage extends StatefulWidget {
  final User user;
  final Course course;
  final List<StudentsForAttendanceCard> list;

  TakeAttendencePage({this.user, this.course, this.list});
  @override
  _TakeAttendencePageState createState() => _TakeAttendencePageState();
}

class _TakeAttendencePageState extends State<TakeAttendencePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('sssssssssssssss ${widget.list.length}');
  }
  @override
  void dispose() {
    widget.list.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        // backgroundColor: CupertinoColors.extraLightBackgroundGray,
        navigationBar: CupertinoNavigationBar(
          middle: Text('Attendance Page'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text("Upload"),
            onPressed: (){
              _onUpdateButtonPressed(widget.course,widget.list,context);
            },
          ),
        ),
        child: buildStudentsCards());
  }

  buildStudentsCards() {
    return SafeArea(
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: CupertinoTheme.of(context).barBackgroundColor,
            child: Padding(
              padding: EdgeInsets.only(
                  left: (SizeConfig.one_W*20).roundToDouble(),
                  top: (SizeConfig.one_H*10).roundToDouble()),
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
                    height: (SizeConfig.one_H*5).roundToDouble(),
                  ),
                  Row(
                    children: [
                      Icon(CupertinoIcons.left_chevron),
                      Text("Swipe left to mark absent")
                    ],
                  ),
                  SizedBox(
                    height: (SizeConfig.one_H*10).roundToDouble(),
                  ),
                ],
              ),
            ),
          ),
          Container(height: (SizeConfig.one_H*574).roundToDouble(),
            child: ListView.builder(

                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  final item = UniqueKey().toString();

                  return Dismissible(
                    // Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify widgets.
                      key: Key(item),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (DismissDirection dir) {
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
                      },
                      // Show a red background as the item is swiped away.
                      background: Container(
                        padding: EdgeInsets.only(
                          right: (SizeConfig.one_W*300).roundToDouble(),
                        ),
                        color: CupertinoColors.activeGreen,
                        child: Center(
                          child: Text(
                            "PRESENT",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        padding: EdgeInsets.only(
                          left: (SizeConfig.one_W*300).roundToDouble(),
                        ),
                        color: CupertinoColors.destructiveRed,
                        child: Center(
                          child: Text(
                            "ABSENT",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black54),
                          ),
                        ),
                      ),
                      child: AttendanceCard(
                        enrolled: widget.list[index].name,
                      ));
                }),
          ),
          // confirmUploadButton(widget.course, widget.list, context),
        ],
      ),
    );
  }
}

confirmUploadButton(Course course, List list, BuildContext context) {
  return CupertinoButton(
    borderRadius: BorderRadius.zero,
    color: CupertinoTheme.of(context).barBackgroundColor,
    padding: EdgeInsets.zero,
      child: Text('Upload Attendance', style: TextStyle(color: CupertinoTheme.of(context).primaryColor),),
      onPressed: () {
        _onUpdateButtonPressed(course,list,context);
      });
}

_onUpdateButtonPressed(Course course,List list,BuildContext context){
  print("button pressed");
  for (var indx = 0; indx < list.length; indx++) {
    increaseTotalClassForEachStudent(course,list[indx].sid);
    if (list[indx].status == true) {
      markpresent(course, list[indx].sid);
    } else {
      markabsent(course, list[indx].sid);
    }
  }
  courseRef
      .doc(course.courseCode)
      .update({"totalClasses": FieldValue.increment(1)});
  userRef
      .doc(user.uid)
      .collection('createdCoursesByUser')
      .doc(course.courseCode)
      .update({"totalClasses": FieldValue.increment(1)});

  ///take back to previous screen
  Navigator.pop(context);
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

increaseTotalClassForEachStudent(Course course,String id){
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


