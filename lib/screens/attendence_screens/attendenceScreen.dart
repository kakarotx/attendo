import 'package:attendo/modals/course_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//this is for text purpose only
final courseRef = FirebaseFirestore.instance.collection('coursesDetails');


class TakeAttendencePage extends StatefulWidget {
  TakeAttendencePage({this.course});
  final Course course;
  @override
  _TakeAttendencePageState createState() => _TakeAttendencePageState();
}

class _TakeAttendencePageState extends State<TakeAttendencePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Attendence Page'),
      ),
      child: Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: courseRef
              .doc(widget.course.courseCode)
              .collection('studentsEnrolled').orderBy('studentName')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CupertinoActivityIndicator());
            } else {
              final students = snapshot.data.docs;
              print(students);
              List<StudentAttendenceCard> studentAttendenceCards = [];
              for (var student in students) {
                final emailId = student['emailId'];
                print(emailId);
                final studentName = student['studentName'];
                final studentPhotoUrl = student['studentPhotoUrl'];
                final studentId= student['studentId'];

                studentAttendenceCards.add(StudentAttendenceCard(
                  studentPhotoUrl: studentPhotoUrl,
                  studentEmailId: emailId,
                  studentName: studentName,
                  studentId: studentId,
                  course: widget.course,
                ));
                print(studentAttendenceCards.length);
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: studentAttendenceCards.length,
                itemBuilder: (context, int) {
                  print('building');
                  return studentAttendenceCards[int];
                },
              );
            }
          },),
      ),
    );
  }
}

class StudentAttendenceCard extends StatelessWidget {

  StudentAttendenceCard({this.studentPhotoUrl, this.studentEmailId, this.studentName, this.studentId,this.course});

  //TODO: add RollNo. of Student
  final String studentName;
  final String studentPhotoUrl;
  final String studentEmailId;
  final String studentId;
  final Course course;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      color: CupertinoColors.lightBackgroundGray,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(studentPhotoUrl),
              ),
              SizedBox(width: 4,),
              Text(
                studentName,
                style: TextStyle(color: CupertinoColors.black),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  _markAbsent(studentId);
                },
                child: CircleAvatar(child: Text('A')),
              ),
              SizedBox(width: 3,),
              GestureDetector(
                onTap: (){
                  _markPresent(studentId);
                },
                child:  CircleAvatar(child: Text('P')),
              )
            ],
          )
        ],
      ),
    );
  }

  _markAbsent(String studentId) {

    courseRef.doc(course.courseCode).collection('studentsEnrolled').doc(studentId).update({
      'absent': FieldValue.increment(1)
    });
    print('absent');
  }
  _markPresent(String studentId) {

    courseRef.doc(course.courseCode).collection('studentsEnrolled').doc(studentId).update({
    'present': FieldValue.increment(1)
    });
    print('present');
  }

}

