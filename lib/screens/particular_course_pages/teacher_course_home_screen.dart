import 'dart:io';
import 'package:attendo/screens/other_screens/pdf_preview_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:attendo/home_page.dart';
import 'package:attendo/modals/course_class.dart';
import 'package:attendo/screens/attendence_screens/attendenceScreen.dart';
import 'package:attendo/screens/particular_course_pages/add_message_screen.dart';
import 'package:attendo/screens/particular_course_pages/student_list.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

///when Teacher tab on CourseCard, that will take us here
///This page will contain details like::
///[No of Students][Total Classes taken] [List of Students] and
///[Option to take attendence]
///
///
/// This Page will be shown to Teachers

final courseRef = FirebaseFirestore.instance.collection('coursesDetails');
final userRef = FirebaseFirestore.instance.collection('users');
final deletedCoursesRef =
    FirebaseFirestore.instance.collection('deletedCourses');

class CourseHomePageForTeacher extends StatefulWidget {
  CourseHomePageForTeacher({this.course, this.user});
  final Course course;
  final User user;

  @override
  _CourseHomePageForTeacherState createState() =>
      _CourseHomePageForTeacherState();
}

class _CourseHomePageForTeacherState extends State<CourseHomePageForTeacher> {
  int currentSegment = 0;
  String teacherName;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  final pdf = pw.Document();

  //data for pdf
  List<List<String>> listOfData = [
    <String>[
      'Student Name',
      'Present Count',
      'Absent Count',
      'Present %'
    ],
  ];


  ///new one
  // writeOnPdf() async {
  //   ///
  //   ///
  //   final QuerySnapshot studentsData = await courseRef
  //       .doc(widget.course.courseCode)
  //       .collection('studentsEnrolled')
  //       .get();
  //
  //   studentsData.docs.forEach((studentData) {
  //     // print(doc.data());
  //     List<String> oneStudentData = [];
  //     final studentName = studentData.data()['studentName'];
  //     print('student name');
  //     print(studentName);
  //     final int absent = studentData.data()['absent'];
  //     print('absent count');
  //     print(absent);
  //     final int present = studentData.data()['present'];
  //
  //     print('add data to list');
  //     oneStudentData.add(studentName);
  //     oneStudentData.add(present.toString());
  //     oneStudentData.add(absent.toString());
  //
  //     int presentPercentage;
  //     try {
  //       presentPercentage = (present * 100) ~/ (present + absent);
  //     } catch (e) {
  //       presentPercentage = 0;
  //     }
  //     oneStudentData.add('$presentPercentage%');
  //
  //     listOfData.add(oneStudentData);
  //
  //     },
  //   );
  //   print(listOfData);
  //
  //   ///
  //   ///
  //   pdf.addPage(
  //     pw.MultiPage(
  //       pageFormat: PdfPageFormat.a5,
  //       margin: pw.EdgeInsets.all(32),
  //       build: (pw.Context context) {
  //         return <pw.Widget>[
  //           pw.Header(
  //               level: 1,
  //               text:
  //                   'Attendence Sheet for Course: ${widget.course.courseName}'),
  //           pw.Paragraph(text: 'Teacher: ${widget.course.teacherName}'),
  //           pw.Table.fromTextArray(context: context, data: listOfData),
  //           pw.Padding(padding: const pw.EdgeInsets.all(10)),
  //         ];
  //       },
  //     ),
  //   );
  // }

  ///old one
  writeOnPdf() async {
    ///
    ///
    final QuerySnapshot studentsData = await courseRef
        .doc(widget.course.courseCode)
        .collection('studentsEnrolled')
        .get();

    studentsData.docs.forEach((studentData) {
      // print(doc.data());
      List<String> oneStudentData = [];
      final studentName = studentData.data()['studentName'];
      print('student name');
      print(studentName);
      final int absent = studentData.data()['absent'];
      print('absent count');
      print(absent);
      final int present = studentData.data()['present'];

      print('add data to list');
      oneStudentData.add(studentName);
      oneStudentData.add(present.toString());
      oneStudentData.add(absent.toString());

      int presentPercentage;
      try {
        presentPercentage = (present * 100) ~/ (present + absent);
      } catch (e) {
        presentPercentage = 0;
      }
      oneStudentData.add('$presentPercentage%');

      listOfData.add(oneStudentData);

    },
    );
    print(listOfData);

    ///
    ///
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
                level: 1,
                text:
                'Attendence Sheet for Course: ${widget.course.courseName}'),
            pw.Paragraph(text: 'Teacher: ${widget.course.teacherName}'),
            pw.Table.fromTextArray(context: context, data: listOfData),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
          ];
        },
      ),
    );
  }

  final List<String> monthsList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];

  ///new one
  // Future savePdf() async {
  //
  //
  //   final dir = await getExternalStorageDirectory();
  //
  //   print("Directoryyyyyyyyy:${dir.path}");
  //
  //   final String path = "${dir.path}/${widget.course.courseCode}_${widget.course.courseName}_${DateTime.now().day}${monthsList[DateTime.now().month]}${DateTime.now().year}.pdf";
  //
  //   final file = File(path);
  //
  //   await file.writeAsBytes(pdf.save());
  //
  // }

  ///old one
  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/example.pdf");

    file.writeAsBytesSync(pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final segmentedControlMaxWidth = 600.0;

    //this list contains the Body of the segments
    final children = <int, Widget>{
      0: particularCourseDetailsScreen(),

      ///this 1: will take LIST OF STUDENTS
      ///as of now it is ok
      1: StudentsList(
        course: widget.course,
      ),
      2: AddAssignmentScreen(
        course: widget.course,
        canSendMessages: true,
      ),
    };

    //Headlines of CupertinoSegmentedControl
    final headingChildren = <int, Widget>{
      0: Text('Course'),
      1: Text('Students'),
      2: Text('Remainders'),
    };

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.course.courseName.toUpperCase()),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
                  myActionSheet(context);
            },
            child: Icon(CupertinoIcons.ellipsis)),
      ),
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context)
            .textTheme
            .textStyle
            .copyWith(fontSize: 13),
        child: SafeArea(
          child: ListView(
            children: [
              const SizedBox(height: 16),
              SizedBox(
                width: segmentedControlMaxWidth,
                child: CupertinoSegmentedControl<int>(
                  children: headingChildren,
                  onValueChanged: onValueChanged,
                  groupValue: currentSegment,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: children[currentSegment],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///this contains [TOTAL STUDENTS] and [TOTAL CLASS TAKEN] details
  Widget particularCourseDetailsScreen() {
    //TODO: fetch data of a particular from Cloud and Fill in the constructor
    // getDataOfThatParticularCourse(courseCode: widget.course.courseCode);
    return StreamBuilder<DocumentSnapshot>(
      stream: courseRef.doc(widget.course.courseCode).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CupertinoActivityIndicator();
        } else {
          final courseData = snapshot.data;
          final courseName = courseData.data()['courseName'];
          final courseCode = courseData.data()['courseCode'];
          final yearOfBatch = courseData.data()['yearOfBatch'];
          final imagePath = courseData.data()['imagePath'];
          final teacherName = courseData.data()['createdBy'];
          final teacherImageUrl = courseData.data()['teacherImageUrl'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              takeAttendenceButton(),
              Hero(
                tag: courseCode,
                child: CardWidget(
                  onCardTab: null,
                  newCourse: Course(
                    teacherImageUrl: teacherImageUrl,
                    courseCode: courseCode,
                    imagePath: imagePath,
                    yearOfBatch: yearOfBatch,
                    courseName: courseName,
                    teacherName: teacherName,
                  ),
                ),
              ),
              classRecordContainer(),
              // CustomCalendar(),
            ],
          );
        }
      },
    );
  }

  ///this will navigate to the Attendence page where we can take attendence
  Widget takeAttendenceButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 20, right: 20, bottom: 8),
      child: CupertinoButton.filled(
          child: Text('Take Attendence'),
          onPressed: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return TakeAttendencePage(
                course: widget.course,
              );
            }));
          }),
    );
  }

  ///TODO: later we merge the ClassRecord into CardWidget
  ///Remove teacherName from CardWidget and Add 2 things
  ///1.TOTOAL CLASS TAKEN  2.TOTAL STUDENTS
  Widget classRecordContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: CupertinoColors.activeBlue,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Text(
                'Classes taken',
                style: TextStyle(color: CupertinoColors.white, fontSize: 16),
              ),
              Text(
                '18',
                style: TextStyle(color: CupertinoColors.white, fontSize: 42),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: CupertinoColors.activeBlue,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Text(
                'Total Students',
                style: TextStyle(color: CupertinoColors.white, fontSize: 16),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: courseRef.doc(widget.course.courseCode).collection('studentsEnrolled').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Text(
                      "0",
                      style: TextStyle(color: CupertinoColors.white, fontSize: 42),
                    );
                  }
                  final noOfStudents = snapshot.data.docs.length;
                  return Text(
                    noOfStudents.toString(),
                    style: TextStyle(color: CupertinoColors.white, fontSize: 42),
                  );
                }
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///when we click on 3dots ICONS at top right
  ///this sheet appears from bottom and has 3-4 options
  myActionSheet(BuildContext context) {
    return showCupertinoModalPopup(
      context: context,
      builder:(context)=> Container(
        margin: EdgeInsets.symmetric(horizontal: 14),
        child: CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TakeAttendencePage(
                        course: widget.course,
                      ),
                    ),
                  );
                },
                child: Text('Take Attendence')),
            CupertinoActionSheetAction(
                onPressed: () async{
                  ///
                  ///
                  // await writeOnPdf();
                  // await savePdf();
                  //
                  // Directory documentDirectory =
                  // await getExternalStorageDirectory();
                  //
                  // String documentPath = documentDirectory.path;
                  //
                  // String fullPath = "$documentPath/${widget.course.courseCode}_${widget.course.courseName}_${DateTime.now().day}${monthsList[DateTime.now().month]}${DateTime.now().year}.pdf";
                  // print(fullPath);
                  // Navigator.pop(context);
                  ///
                  ///
                  await writeOnPdf();
                  await savePdf();

                  Directory documentDirectory =
                  await getApplicationDocumentsDirectory();

                  String documentPath = documentDirectory.path;

                  String fullPath = "$documentPath/example.pdf";

                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => PdfPreviewScreen(
                            path: fullPath,
                          ),
                      ),
                  );
                },
                child: Text('Download AttendenceSheet')),
            CupertinoActionSheetAction(
                onPressed: () {
                  print('sharing');
                  _shareClass(context);
                  // Navigator.pop(context);
                },
                child: Text('Share Class')),
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  showDeleteDialogAlert(context, widget.course);
                },
                child: Text(
                  'Delete Class',
                  style: TextStyle(color: CupertinoColors.destructiveRed),
                )),
          ],
          cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel')),
        ),
      )
    );
  }

  _shareClass(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final sharingText = 'This code is shared by ${widget.course.teacherName},'
        'Join ${widget.course.courseName} course with code: ${widget.course.courseCode} on this app [playstoreUrl]';
    Share.share(sharingText,
        subject: 'download App from',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  showDeleteDialogAlert(BuildContext context, Course course) {
    confirmDeleteAlert(context, course);
  }

  ///this will show a Dailog after we press delete Course button
  ///which has 2 options, [cancel] and [delete]
  void confirmDeleteAlert(BuildContext context, Course course) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Confirm delete"),
            content: Text("Do you want to delete the Course?"),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: CupertinoColors.destructiveRed),
                  // isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    addCourseDataToDeletedCourseCollection(course);
                    deleteTheCourseFromCloud(course);
                    Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(builder: (context) => HomePage()),
                        (route) => false);
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  ///we are the deleting the Course from [CoursesDetails] collection
  void deleteTheCourseFromCloud(Course course) async{
    courseRef.doc(course.courseCode).delete();

    userRef
        .doc(widget.user.uid)
        .collection('createdCoursesByUser')
        .doc(course.courseCode)
        .delete();

    final studentsEnrolled = await userRef
        .doc(widget.user.uid)
        .collection('createdCoursesByUser')
        .doc(course.courseCode)
        .collection('studentsEnrolled').get();

    //when we delete the createdCoursesByUser collection ..
    // the [studentsEnrolled] and [messages] collection remains
    studentsEnrolled.docs.forEach((element) {
      if(element.exists){
       element.reference.delete();
      }
    });

    final messages = await userRef
        .doc(widget.user.uid)
        .collection('createdCoursesByUser')
        .doc(course.courseCode)
        .collection('messagesByTeacher').get();

    //when we delete the createdCoursesByUser collection ..
    // the [studentsEnrolled] and [messages] collection remains
    messages.docs.forEach((element) {
      if(element.exists){
        element.reference.delete();
      }
    });

  }

  ///I made a Collection on firebase: [DeletedCourses],
  ///because Student have to be notified that the class is deleted
  ///ON Student PAGE, I have implemented a logic which checks if
  ///the Document with the COURSE CODE exists on [DeletedCourses]
  addCourseDataToDeletedCourseCollection(Course course) {
    deletedCoursesRef.doc(course.courseCode).set(
        {'courseName': course.courseName, 'teacherName': course.teacherName});
  }

}
