
import 'package:attendo/modals/course_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

final coursesRef = FirebaseFirestore.instance.collection('coursesDetails');
final userRef = FirebaseFirestore.instance.collection('users');

class CreateNewStudentPage extends StatefulWidget {
  CreateNewStudentPage({this.currentUser,this.course});

  final User currentUser;
  final Course course;

  @override
  _CreateNewStudentPageState createState() => _CreateNewStudentPageState();
}

class _CreateNewStudentPageState extends State<CreateNewStudentPage> {
  //variables to create a new Course
  // String studentPhotoUrl='https://www.thewodge.com/wp-content/uploads/2019/11/avatar-icon.png';
  String studentPhotoUrl = 'https://cdn.pixabay.com/photo/2016/03/31/14/47/avatar-1292817_1280.png';
  String studentUid;
  String studentName;

  ///this Uuid package helps us generate new and random user Id
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
  }

  ///this data has CourseDetails
  ///When user create new Course this data is uploaded
  uploadCourseDataToCloud({
    String studentPhotoUrl,
    String studentName,
    String emailId,
  }) async {
    ///this will upload to a Universal Collections of all Courses
    studentUid = uuid.v1();
    coursesRef.doc(widget.course.courseCode).collection('studentsEnrolled').doc(studentUid).set({
      'emailId':emailId,
      'studentName':studentName,
      'studentPhotoUrl':studentPhotoUrl,
      'present':0,
      'absent':0,
      'studentId': studentUid,
    });

    // userRef
    //     .doc(widget.currentUser.uid.toString())
    //     .collection('createdCoursesByUser')
    //     .doc(courseCode)
    //     .set({
    //   "courseName": nameOfCourse,
    //   'courseCode': codeOfCourse,
    //   'createdBy': widget.currentUser.displayName,
    //   'imagePath': imagePath,
    //   'yearOfBatch': year,
    //   'teacherImageUrl': widget.currentUser.photoURL
    // });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
          navigationBar: CupertinoNavigationBar(
            leading: CupertinoButton(
              onPressed: (){
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              child: Text('< Back')
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text('Add'),
              onPressed: () {

                print('creating new student...');


                if (studentName != null) {

                  Navigator.pop(context);

                  uploadCourseDataToCloud(
                  emailId: 'null@gmail.com',
                  studentName: studentName,
                  studentPhotoUrl: studentPhotoUrl
                  );
                } else{
                  showNoticeDialog();
                }
              },
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'StudentName  : ',
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        placeholder: 'Enter Student Name',
                        onChanged: (String newValue) {
                          return studentName = newValue;
                        },
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IMPORTANT',
                        style: TextStyle(color: CupertinoColors.destructiveRed),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                          '1. You can also add student manually.'),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "2. This helps to have you record of students who doesnot have phone"),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  ///TODO: later make a general class and transfer all these little functions to that class
  showNoticeDialog(){
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            // title: Text("Note"),
            content: Text("Please fill out student name."),
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

///DANGER AHEAD-
///
//TODO: create a non repeating random number function
//outside of class
//failed attempt to create a RandomGenerator
//TODO: make RANDOM_NUMBER_GENERATOR work
// int generatedRandomInt() {
//   int permanentRandomInt;
//   int tempRandomInt;
//
//
//   //this will run after we create our second card
//   if (randomIntList.length == 0) {
//     tempRandomInt = 0 + Random().nextInt(3 - 0);
//     permanentRandomInt = tempRandomInt;
//     print('randomInt: $permanentRandomInt');
//     randomIntList.add(permanentRandomInt);
//   }
//   else {
//     tempRandomInt = 0 + Random().nextInt(3 - 0);
//     permanentRandomInt = tempRandomInt;
//     print('randomInt: $permanentRandomInt');
//     randomIntList.add(permanentRandomInt);
//     while (randomIntList[randomIntList.last] == randomIntList[randomIntList.length - 2]) {
//       tempRandomInt = 0 + Random().nextInt(3 - 0);
//       permanentRandomInt = tempRandomInt;
//       print('randomInt: $permanentRandomInt');
//       randomIntList.add(permanentRandomInt);
//       // print(randomIntList.length);
//     }
//
//   }
//   return randomIntList.last;
//
// }
