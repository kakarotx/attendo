
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

  buildStudentList(){
    return StreamBuilder<QuerySnapshot>(
      stream: courseRef.doc(widget.course.courseCode).collection('studentsEnrolled').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CupertinoActivityIndicator());
        } else{
          final students = snapshot.data.docs;
          print(students);
          List<StudentCard> studentCards = [];
          for (var student in students){
            final emailId = student['emailId'];
            print(emailId);
            final studentName = student['studentName'];
            final photoUrl = student['photoUrl'];

            studentCards.add(StudentCard(
              studentPhotoUrl: photoUrl,
              studentEmailId: emailId,
              studentName: studentName,
            )
            );
            print(studentCards.length);
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount:studentCards.length,
            itemBuilder: (context, int){
              print('building');
              return studentCards[int];
            },
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildStudentList();
  }
}





class StudentCard extends StatelessWidget {
  StudentCard({this.studentPhotoUrl, this.studentEmailId, this.studentName});
  //TODO: add RollNo. of Student
  final String studentName;
  final String studentPhotoUrl;
  final String studentEmailId;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12,),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: CupertinoThemeData().primaryColor,
          borderRadius: BorderRadius.circular(6)
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(studentPhotoUrl),),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(studentName,style: TextStyle(color: CupertinoColors.white),),
              SizedBox(height: 3,),
              Text(studentEmailId,style: TextStyle(color: CupertinoColors.white),),
            ],
          ),
        ],
      ),
    );
  }
}
