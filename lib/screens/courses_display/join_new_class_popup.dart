import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final courseRef = FirebaseFirestore.instance.collection('coursesDetails');
///to join already created classes by others
class JoinNew extends StatefulWidget {

  JoinNew({this.user,this.toggleScreenCallBack});

  final Function toggleScreenCallBack;
  final User user;

  @override
  _JoinNewState createState() => _JoinNewState();
}

class _JoinNewState extends State<JoinNew> {
  String enteredClassCode;
  CollectionReference courseRef;
  String courseName;
  String yearOfBatch;
  String courseCode;
  String imagePath;
  String teacherName;
  String teacherImageUrl;

  getCourseDataFor({String enteredClassCode}) async {
    final DocumentSnapshot courseData =
    await courseRef.doc(enteredClassCode).get();
    if(courseData.exists){
      try {
        courseName = courseData.data()['courseName'];
        courseCode = courseData.data()['courseCode'];
        yearOfBatch = courseData.data()['yearOfBatch'];
        imagePath = courseData.data()['imagePath'];
        teacherName = courseData.data()['createdBy'];
        teacherImageUrl = courseData.data()['teacherImageUrl'];
        print('this is $courseName');
      } catch (e) {
        print('qwerty error::::$e');
      }
    }

  }

  ///user>ClassJoinedByUser>
  uploadJoinedClassDataToCloud({String courseName,String courseCode,String imagePath,String yearOfBatch}) async{
    final DocumentSnapshot doc =
    await courseRef.doc(enteredClassCode).get();

    if(doc.exists)
    {
      userRef
          .doc(widget.user.uid)
          .collection('joinedCoursesByUser')
          .doc(courseCode)
          .set({
        "courseName": courseName,
        'courseCode': courseCode,
        'createdBy': teacherName,
        'imagePath': imagePath,
        'yearOfBatch': yearOfBatch,
      });
    }
  }

  addStudentToTheCloud({String courseCode}) async{
    final doc = await courseRef.doc(courseCode).get();
    if(doc.exists)
    {
      courseRef.doc(courseCode)
          .collection('studentsEnrolled')
          .doc(widget.user.uid)
          .set({
        "emailId": widget.user.email,
        "studentName": widget.user.displayName,
        "studentPhotoUrl": widget.user.photoURL,
        "studentId": widget.user.uid,
        "absent": 0,
        "present":0
      });

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courseRef = FirebaseFirestore.instance.collection('coursesDetails');
  }



  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text('<Back'),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text('Join'),
            onPressed: _onJoinButtonPressed,
          ),
        ),
        resizeToAvoidBottomInset: false,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    'ClassCode :  ',
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      keyboardType: TextInputType.number,
                      placeholder: 'Enter Class Code',
                      textAlign: TextAlign.center,
                      onChanged: (String newValue) {
                        enteredClassCode = newValue;
                      },
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(
                      'NOTE',
                      style: TextStyle(color: CupertinoColors.destructiveRed),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                        '1. Ask your teacher for Class Code and enter it to join the class.'),
                  ],
                ),
              )
            ],
          ),
        ),

    );
  }

  _onJoinButtonPressed() async {
    if(enteredClassCode!=null){

      ///getting the data of the particular course through ENTERED CODE
      await getCourseDataFor(enteredClassCode: enteredClassCode);

      ///uploading the same data to Cloud
      uploadJoinedClassDataToCloud(
          courseName: courseName,
          courseCode: courseCode,
          yearOfBatch: yearOfBatch,
          imagePath: imagePath
      );

      ///adding Student to the Particular Course
      addStudentToTheCloud(courseCode: courseCode);
      print('joining new course');

      ///the provider part that was here is commented below, OUTSIDE THE CLASS

      ///now we are using Data on Cloud

      widget.toggleScreenCallBack();
      Navigator.pop(context);

    }
    else{

      showNoticeDialog();

    }

  }

  showNoticeDialog(){
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            // title: Text("Note"),
            content: Text("Enter Valid Course Code."),
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