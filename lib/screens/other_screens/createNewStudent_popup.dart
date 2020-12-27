
import 'package:attendo/modals/course_class.dart';
import 'package:attendo/modals/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

//MediaQuery r2d
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

  String studentPhotoUrl = 'https://i.ibb.co/bBrjWHm/avatar.jpg';
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

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
          navigationBar: CupertinoNavigationBar(
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text('Add'),
              onPressed: () {

                print('creating new student...');


                if (studentName != null) {

                  try{
                    Navigator.pop(context);
                    uploadCourseDataToCloud(
                        emailId: 'null@gmail.com',
                        studentName: studentName,
                        studentPhotoUrl: studentPhotoUrl
                    );
                    increaseStudentNumber();

                    //Showing toast
                    Fluttertoast.showToast(
                        msg: "New student added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: CupertinoColors.activeBlue,
                        textColor: CupertinoColors.white,
                        fontSize: 16.0
                    );

                  } catch(e){
                    Fluttertoast.showToast(
                        msg: "Unexpected Error, try again",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: CupertinoColors.activeBlue,
                        textColor: CupertinoColors.white,
                        fontSize: 16.0
                    );
                  }
                } else{
                  showNoticeDialog();
                }
              },
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: (1.96 * SizeConfig.heightMultiplier).roundToDouble(),
              bottom: (6.12 * SizeConfig.heightMultiplier).roundToDouble(),
              left: (6.37 * SizeConfig.widthMultiplier).roundToDouble(),
              right: (6.37 * SizeConfig.widthMultiplier).roundToDouble(),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    (SizeConfig.one_W*20).roundToDouble()
                ),//20
                topRight: Radius.circular(
                    (SizeConfig.one_W*20).roundToDouble()
                ),//20
              ),
            ),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New StudentName',
                ),
                SizedBox(
                  height: (0.61*SizeConfig.heightMultiplier).roundToDouble(),
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
                SizedBox(
                  height: (SizeConfig.one_H*16).roundToDouble()//16
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
                        height:(SizeConfig.one_H*4).roundToDouble(),
                      ),
                      Text(
                          '1. You can also add student manually.'),
                      SizedBox(
                        height:(SizeConfig.one_H*10).roundToDouble(),//10
                      ),
                      Text(
                          "2. This helps to have you record of students who don't have phone"),
                    ],
                  ),
                )
              ],
            ),
          )
    );
  }

  increaseStudentNumber() async{
    coursesRef.doc(widget.course.courseCode).update(
      {
        "totalStudents": FieldValue.increment(1)
      }
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
