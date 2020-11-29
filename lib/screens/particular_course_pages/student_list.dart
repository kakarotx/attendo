import 'package:attendo/modals/course_class.dart';
import 'package:attendo/screens/other_screens/createNewStudent_popup.dart';
import 'package:attendo/screens/particular_course_pages/add_message_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final courseRef = FirebaseFirestore.instance.collection('coursesDetails');

class StudentsList extends StatefulWidget {
  StudentsList({this.course});
  final Course course;
  @override
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {

  buildStudentList() {
    return StreamBuilder<QuerySnapshot>(
        stream: courseRef
            .doc(widget.course.courseCode)
            .collection('studentsEnrolled').orderBy('studentName',descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CupertinoActivityIndicator());
          } else {
            final students = snapshot.data.docs;
            print(students);
            List<StudentCard> studentCards = [];
            for (var student in students) {
              final emailId = student['emailId'];
              print(emailId);
              final studentName = student['studentName'];
              final studentPhotoUrl = student['studentPhotoUrl'];
              final studentId= student['studentId'];
              final int absent = student['absent'];
              final int present = student['present'];
              int presentPercentage;
              try{
                presentPercentage=(present*100)~/(present+absent);
              } catch(e){
                presentPercentage=0;
              }

              studentCards.add(StudentCard(
                studentPhotoUrl: studentPhotoUrl,
                studentEmailId: emailId,
                studentName: studentName,
                studentId: studentId,
                presentPercentage: presentPercentage,

              ));
              print(studentCards.length);
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              itemCount: studentCards.length,
              itemBuilder: (context, int) {
                print('building');
                return studentCards[int];
              },
            );
          }
        });

  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(left: 12, right: 12, bottom: 10),
          child: CupertinoButton.filled(
            // padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => CreateNewStudentPage(
                    currentUser: user,
                    course: widget.course,
                  ),
                  fullscreenDialog: true
                ),
              );
              print('Adding New Student');
            },
            child: Text('Add New Student'),
          ),
        ),
        Container(
          height: 550,
          child: buildStudentList()
        ),
      ],
    );
  }
}

class StudentCard extends StatelessWidget {
  StudentCard({this.studentPhotoUrl, this.studentEmailId, this.studentName, this.studentId,this.presentPercentage});
  //TODO: add RollNo. of Student
  final String studentName;
  final String studentPhotoUrl;
  final String studentEmailId;
  final String studentId;
  final int presentPercentage;

  ///this will be passed through the constructor
  ///final int presentPercent;
  @override
  Widget build(BuildContext context) {
    ///variables for Progress Bar
    final Color background = CupertinoColors.systemBlue;
    final Color fill = CupertinoTheme.of(context).barBackgroundColor;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    final List<double> stops = [0.0, presentPercentage / 100, presentPercentage / 100, 1.0];

    ///

    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            stops: stops,
            end: Alignment.centerRight,
            begin: Alignment.centerLeft,
          ),
          color: CupertinoThemeData().primaryColor,
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(studentPhotoUrl),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: TextStyle(color: presentPercentage>=40?CupertinoTheme.of(context).primaryContrastingColor:CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.color),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      studentEmailId,
                      style: TextStyle(color: presentPercentage>=40?CupertinoTheme.of(context).primaryContrastingColor:CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.color),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              '$presentPercentage%',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
