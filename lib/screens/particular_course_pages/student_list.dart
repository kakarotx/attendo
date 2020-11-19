import 'package:attendo/modals/course_class.dart';
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
            .collection('studentsEnrolled')
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
              final photoUrl = student['studentPhotoUrl'];

              studentCards.add(StudentCard(
                studentPhotoUrl: photoUrl,
                studentEmailId: emailId,
                studentName: studentName,
              ));
              print(studentCards.length);
            }
            return ListView.builder(
              shrinkWrap: true,
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
          margin: EdgeInsets.only(left: 12,right: 12, bottom: 10),
          child: CupertinoButton.filled(
            // padding: EdgeInsets.zero,
            onPressed: () {
              print('Adding New Student');
            },
            child: Text('Add New Student'),
          ),
        ),
        Container(
          child: buildStudentList(),
        ),
      ],
    );
  }
}

class StudentCard extends StatelessWidget {
  StudentCard({this.studentPhotoUrl, this.studentEmailId, this.studentName});
  //TODO: add RollNo. of Student
  final String studentName;
  final String studentPhotoUrl;
  final String studentEmailId;
  ///this will be passed through the constructor
  ///final int presentPercent;
  @override
  Widget build(BuildContext context) {
    ///variables for Progress Bar
    final Color background = CupertinoColors.activeBlue;
    final Color fill = CupertinoColors.extraLightBackgroundGray;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    ///
    final double fillPercent = 75;
    // fills 56.23% for container from bottom
    final List<double> stops = [0.0, fillPercent / 100, fillPercent / 100, 1.0];
    ///

    return Container(
      margin: EdgeInsets.only(left: 12, right: 12,bottom: 10
      ),
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
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      studentEmailId,
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Text('${fillPercent.toInt().toString()}%', style: TextStyle(fontSize: 20),),
          )
        ],
      ),
    );
  }
}


