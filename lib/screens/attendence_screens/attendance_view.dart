import 'package:attendo/modals/course_class.dart';
import 'package:attendo/modals/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//MediaQuery r2d

final courseRef = FirebaseFirestore.instance.collection('coursesDetails');

///AttendenceView
class AttendanceViewForTeacher extends StatefulWidget {
  AttendanceViewForTeacher({this.course});
  final Course course;

  @override
  _AttendanceViewForTeacherState createState() => _AttendanceViewForTeacherState();
}

class _AttendanceViewForTeacherState extends State<AttendanceViewForTeacher> {
  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: courseRef
          .doc(widget.course.courseCode)
          .snapshots(),
      builder: (context,snapshot) {
        if(!snapshot.hasData){
          final totalStudents = 0;
          final totalClasses = 0;
          return Container(
              child: Padding(
                padding: EdgeInsets.only(top: (SizeConfig.one_H*140).roundToDouble(),
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
                                  Text(
                                    totalClasses.toString(),
                                    style: TextStyle(
                                      fontSize: (SizeConfig.one_W*26).roundToDouble(),
                                      fontWeight: FontWeight.w600,
                                      color: CupertinoColors.black,
                                    ),
                                  ),
                                  SizedBox(height: (SizeConfig.one_H*5).roundToDouble()),
                                  Text(
                                    "Total Class",
                                    style: TextStyle(
                                      fontSize: (SizeConfig.one_W*18).roundToDouble(),
                                      fontWeight: FontWeight.w600,
                                      color: CupertinoColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    totalStudents.toString(),
                                    style: TextStyle(
                                      fontSize: (SizeConfig.one_W*26).roundToDouble(),
                                      fontWeight: FontWeight.w600,
                                      color: CupertinoColors.black,
                                    ),
                                  ),
                                  SizedBox(height: (SizeConfig.one_H*5).roundToDouble()),
                                  Text(
                                    "Total Students",
                                    style: TextStyle(
                                      fontSize: (SizeConfig.one_W*18).roundToDouble(),
                                      fontWeight: FontWeight.w600,
                                      color: CupertinoColors.black,
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
                        width: (SizeConfig.one_W*1).roundToDouble(),
                        color: CupertinoColors.extraLightBackgroundGray),
                    borderRadius: BorderRadius.circular((SizeConfig.one_W*6).roundToDouble()),
                    color: CupertinoColors.white,
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
        } else{
          final totalStudents = snapshot.data['totalStudents'];
          final totalClasses = snapshot.data['totalClasses'];
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
                                  Text(
                                    totalClasses.toString(),
                                    style: TextStyle(
                                      fontSize: (SizeConfig.one_W*26).roundToDouble(),
                                      // fontWeight: FontWeight.w600,
                                      // color: CupertinoColors.black,
                                    ),
                                  ),
                                  SizedBox(height: (SizeConfig.one_H*5).roundToDouble()),
                                  Text(
                                    "Total Class",
                                    style: TextStyle(
                                      fontSize: (SizeConfig.one_W*18).roundToDouble(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    totalStudents.toString(),
                                    style: TextStyle(
                                      fontSize: (SizeConfig.one_W*26).roundToDouble(),
                                    ),
                                  ),
                                  SizedBox(height: (SizeConfig.one_H*5).roundToDouble()),
                                  Text(
                                    "Total Students",
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
              ));
        }
      },
    );
  }
}