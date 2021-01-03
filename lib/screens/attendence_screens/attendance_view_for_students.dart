import 'package:attendo/modals/course_class.dart';
import 'package:attendo/modals/size_config.dart';
import 'package:attendo/screens/attendence_screens/attendenceScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//MediaQuery r2d
final courseRef = FirebaseFirestore.instance.collection('coursesDetails');

///AttendenceView
class AttendanceViewForStudents extends StatefulWidget {
  AttendanceViewForStudents({this.course, this.user});

  final Course course;
  final User user;

  @override
  _AttendanceViewForStudentsState createState() =>
      _AttendanceViewForStudentsState();
}

class _AttendanceViewForStudentsState extends State<AttendanceViewForStudents> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: EdgeInsets.only(
              top: (SizeConfig.one_H*140).roundToDouble(),
              left: (SizeConfig.one_W*16).roundToDouble(),
              right: (SizeConfig.one_W*16).roundToDouble()),
          child: Container(
            child: Padding(
              padding: EdgeInsets.all((SizeConfig.one_W*16.0).roundToDouble()),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            StreamBuilder(
                                stream: courseRef
                                    .doc(widget.course.courseCode)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if(!snapshot.hasData) {
                                    return Text(
                                      "0",
                                      style: TextStyle(
                                        fontSize: (SizeConfig.one_W*26).roundToDouble(),
                                        // fontWeight: FontWeight.w600,
                                        // color: CupertinoColors.black,
                                      ),
                                    );
                                  } else {
                                    final totalClasses = snapshot.data['totalClasses'];
                                    return Text(
                                      totalClasses.toString(),
                                      style: TextStyle(
                                        fontSize: (SizeConfig.one_W*26).roundToDouble(),
                                        // fontWeight: FontWeight.w600,
                                        // color: CupertinoColors.black,
                                      ),
                                    );
                                  }
                                }
                            ),
                            SizedBox(height: (SizeConfig.one_H*5).roundToDouble()),
                            Text(
                              "Total Classes",
                              style: TextStyle(
                                fontSize: (SizeConfig.one_W*18).roundToDouble(),
                                // fontWeight: FontWeight.w600,
                                // color: CupertinoColors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: userRef.doc(widget.user.uid).collection("joinedCoursesByUser").doc(widget.course.courseCode).snapshots(),
                              builder: (context,snapshot) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: (SizeConfig.one_W*26).roundToDouble(),
                                      // fontWeight: FontWeight.w600,
                                      // color: CupertinoColors.black,
                                    ),
                                  );
                                } else {
                                  final present = snapshot
                                      .data["present"];
                                  return Text(
                                    present.toString(),
                                    style: TextStyle(
                                      fontSize: (SizeConfig.one_W*26).roundToDouble(),
                                      // fontWeight: FontWeight.w600,
                                      // color: CupertinoColors.black,
                                    ),
                                  );
                                }
                              }),
                            SizedBox(height: (SizeConfig.one_H*5).roundToDouble()),
                            Text(
                              "Present",
                              style: TextStyle(
                                fontSize: (SizeConfig.one_W*18).roundToDouble(),
                                // fontWeight: FontWeight.w600,
                                // color: CupertinoColors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.7)),
              borderRadius: BorderRadius.circular((SizeConfig.one_W*6).roundToDouble()),
              color: CupertinoTheme.of(context).barBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            height: (SizeConfig.one_H*94).roundToDouble(),
            width: double.infinity,
          ),
        ),
    );
  }
}

