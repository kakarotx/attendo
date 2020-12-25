
import 'package:attendo/modals/course_class.dart';
import 'package:attendo/modals/size_config.dart';
import 'package:attendo/screens/attendence_screens/attendance_view_for_students.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'attendenceScreen.dart';

//MediaQuery r2d
///this page will be shown to students
class AttendenceRecordPage extends StatefulWidget {
  AttendenceRecordPage({this.course,this.user});
  final Course course;
  final User user;
  @override
  _AttendenceRecordPageState createState() => _AttendenceRecordPageState();
}

class _AttendenceRecordPageState extends State<AttendenceRecordPage> {
  @override
  Widget build(BuildContext context) {
    return particularCourseDetailsScreen();
  }

  Widget particularCourseDetailsScreen() {
    return Container(
      height: (SizeConfig.one_H*560).roundToDouble(),
      child: ListView(
        // scrollDirection: Axis.horizontal,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: (SizeConfig.one_H*190).roundToDouble(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(widget.course.imagePath),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: EdgeInsets.all((SizeConfig.one_W*20).roundToDouble()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.course.courseName.toUpperCase(),
                          style: TextStyle(
                            fontSize: (SizeConfig.one_W*14).roundToDouble(),
                            // fontWeight: FontWeight.w500,
                            color: CupertinoColors.white,
                          )),
                      SizedBox(
                        height: (SizeConfig.one_H*5).roundToDouble(),
                      ),
                      Text('TEACHER : ${widget.course.teacherName}'
                          .toUpperCase(),
                          style: TextStyle(
                            fontSize: (SizeConfig.one_W*14).roundToDouble(),
                            // fontWeight: FontWeight.w500,
                            color: CupertinoColors.white,
                          )),
                      SizedBox(
                        height: (SizeConfig.one_H*5).roundToDouble(),
                      ),
                      Text('CODE : ${widget.course.courseCode}'.toUpperCase(),
                          style: TextStyle(
                            fontSize: (SizeConfig.one_W*14).roundToDouble(),
                            // fontWeight: FontWeight.w500,
                            color: CupertinoColors.white,
                          ))
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  AttendanceViewForStudents(
                    user: widget.user,
                    course: widget.course,
                  ),

                ],
              ),
            ],
          ),
          SizedBox(height: (SizeConfig.one_H*20).roundToDouble(),),
          aPI(),
        ],
      ),
    );
  }

  ///attendance progress indicator
  aPI() {
    return StreamBuilder(
        stream: userRef.doc(widget.user.uid).collection("joinedCoursesByUser").doc(widget.course.courseCode).snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData) {
            return aPI_widget(1, 1);
          } else {
            final present = snapshot.data["present"];
            final absent = snapshot.data["absent"];
            final totalClasses = snapshot.data["totalClasses"];
            print("QQQQQQQQQQQQQQQQQQQ::   $present");
            print('QQQQQQQQQQQQQQQQQQQ::   $absent');

            if(totalClasses==0&& present==0) {
              return aPI_widget(1, 1);
            }
            else{
              return aPI_widget(present,totalClasses);
            }
          }
        });
  }

  ///attendance progress indicator_widget
  aPI_widget(int present, int totalClasses){

    final percentage = ((present/totalClasses)*100).toInt();

    return CircularPercentIndicator(
      radius: (SizeConfig.one_W*150.0).roundToDouble(),
      lineWidth: (SizeConfig.one_W*25.0).roundToDouble(),
      animation: true,

      percent: ((present/totalClasses)),
      center: Text(
        '$percentage %',
        style:
        TextStyle(fontWeight: FontWeight.bold,
            fontSize: (SizeConfig.one_W*20.0).roundToDouble(),
            color: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.color),
      ),
      footer: Text(
        "Present Percentage",
        style:
        TextStyle(fontWeight: FontWeight.bold,
            fontSize: (SizeConfig.one_W*17.0).roundToDouble(),
            color: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.color),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: CupertinoTheme.of(context).primaryColor,
    );
  }

}