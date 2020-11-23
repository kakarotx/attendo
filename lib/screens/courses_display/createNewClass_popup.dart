import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

final coursesRef = FirebaseFirestore.instance.collection('coursesDetails');
final userRef = FirebaseFirestore.instance.collection('users');

class CreateNewClass extends StatefulWidget {
  CreateNewClass({this.currentUser, this.toggleScreenCallBack});

  final User currentUser;

  ///this is a callback, which is called when we press createNewClass,
  ///this chances the [NO CREATED CLASS screen] to LIST_OF_CREATED_CLASSES SCREEN
  final Function toggleScreenCallBack;

  @override
  _CreateNewClassState createState() => _CreateNewClassState();
}

class _CreateNewClassState extends State<CreateNewClass> {
  //variables to create a new Course
  String courseName;
  String yearOfBatch;
  String courseCode;
  String teacherImageUrl;

  String imagePath;
  // FToast fToast;

  ///list of ImagePaths which are used for creating new CardWidgets
  List<String> imagePaths = [
    'assets/images/artWork/art01.jpg',
    'assets/images/artWork/art02.jpg',
    'assets/images/artWork/art03.jpg',
  ];

  //TODO: generateNonRepeatativeRandomNumber

  String getRandomImg(List<String> imageList, int randomInt) {
    return imageList[randomInt];
  }

  @override
  void initState() {
    super.initState();
    // fToast = FToast();
    // fToast.init(context);
  }

  _showToast({String toastMsg, IconData toastIcon}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: CupertinoColors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            toastIcon,
            color: CupertinoColors.white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            toastMsg,
            style: TextStyle(color: CupertinoColors.white),
          ),
        ],
      ),
    );
    // fToast.showToast(
    //   child: toast,
    //   gravity: ToastGravity.BOTTOM,
    //   toastDuration: Duration(seconds: 2),
    // );
  }

  ///this data has CourseDetails
  ///When user create new Course this data is uploaded
  uploadCourseDataToCloud({
    String nameOfCourse,
    String codeOfCourse,
    String year,
    String imagePath,
  }) async {
    ///this will upload to a Universal Collections of all Courses
    coursesRef.doc(courseCode).set({
      'courseName': nameOfCourse,
      'courseCode': codeOfCourse,
      'createdBy': widget.currentUser.displayName,
      'yearOfBatch': year,
      'imagePath': imagePath,
      'teacherImageUrl': widget.currentUser.photoURL,
      'isCourseDeletedByTeacher': false,
    });

    ///this will upload to User Collection > CoursesCreated >
    ///means Only courses created by that particular user
    userRef
        .doc(widget.currentUser.uid.toString())
        .collection('createdCoursesByUser')
        .doc(courseCode)
        .set({
      "courseName": nameOfCourse,
      'courseCode': codeOfCourse,
      'createdBy': widget.currentUser.displayName,
      'imagePath': imagePath,
      'yearOfBatch': year,
      'teacherImageUrl': widget.currentUser.photoURL
    });
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
              child: Text('Create'),
              onPressed: () {

                print('creating new class...');

                ///here many things are happening
                ///1. gerating a random int to select a Image for card
                ///and random code for the course.
                ///2.Uploading data to firebase, after check if anything is not null
                ///TODO: random number can generate repetative random numbers so we
                ///have to make another function to takle that

                //generate Random courseCode
                int classCode = 9999 + Random().nextInt(99999 - 9999);
                courseCode = classCode.toString();

                //generated a random int which is passed through ImageList index
                //TODO: make a function so that images don't ListOfCourseCard
                //min + Random().nextInt(max-min);
                //this is for card image selection
                int randomInt = 0 + Random().nextInt(3 - 0);

                if (yearOfBatch != null && courseName != null) {
                  ///adding the courseCode to the ListOfCourseCodes
                  ///later when we will join class, we will check in this list
                  ///whether the enteredCode exists or not
                  ///Later we will check enteredCode in database

                  // widget.toggleScreenCallBack();
                  _showToast(
                      toastMsg: 'Class Created',
                      toastIcon: CupertinoIcons.check_mark);

                  Navigator.pop(context);

                  ///toast msg when any field is left and create class is pressed
                  _showToast(
                      toastMsg: 'Enter Valid Details',
                      toastIcon: CupertinoIcons.drop_triangle_fill);

                  ///this part is uploading course details as a Document to fireStore
                  ///whose ID is set as CourseCode.
                  uploadCourseDataToCloud(
                      codeOfCourse: courseCode,
                      nameOfCourse: courseName,
                      year: yearOfBatch,
                      imagePath: imagePaths[randomInt]);
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
                      'Course  : ',
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        placeholder: 'Enter Course Name',
                        onChanged: (String newValue) {
                          return courseName = newValue;
                        },
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Batch  :    ',
                    ),
                    Expanded(
                      child: CupertinoTextField(
                        placeholder: 'Enter Batch Year or Class',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (String newValue) {
                            return yearOfBatch = (newValue);
                          }),
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
                          '1. Enter a CourseName for the course you want to create'
                          ' as well as the year of the batch.'),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "2. A Code for your class will be provided to you which you can share"
                          " with your class so they can join in."),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "3. Student List with their data will be available to you."),
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
            content: Text("Please fill out CourseName as well as Batch before creating new class."),
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
