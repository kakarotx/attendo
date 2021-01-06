import 'dart:io';
import 'package:attendo/modals/size_config.dart';
import 'package:attendo/screens/attendence_screens/attendance_view.dart';
import 'package:attendo/screens/other_screens/pdf_preview_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:attendo/home_page.dart';
import 'package:attendo/modals/course_class.dart';
import 'package:attendo/screens/attendence_screens/attendenceScreen.dart';
import 'package:attendo/screens/particular_course_pages/add_message_screen.dart';
import 'package:attendo/screens/particular_course_pages/student_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:attendo/modals/student_for_attendance_scree.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

//MediaQueryData r2d

///when Teacher tab on CourseCard, that will take us here
///This page will contain details like::
///[No of Students][Total Classes taken] [List of Students] and
///[Option to take attendence]
///
///
/// This Page will be shown to Teachers

final appInfoRef = FirebaseFirestore.instance.collection('appInfo');
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
  List<StudentsForAttendanceCard> studentlist = [];
  bool dataFetched ;
  String playStoreUrl = "after_app_launch";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataFetched = false;

  }


  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }
  int noOfStudents = 0;
  final pdf = pw.Document();

  //data for pdf
  List<List<String>> listOfData = [
    <String>['Student Name', 'Present Count', 'Absent Count', 'Present %'],
  ];

  ///old one
  writeOnPdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    final String savedPath = "$documentPath/${widget.course.courseCode}_${widget.course.courseName}_${DateTime.now().day}${monthsList[DateTime.now().month-1]}${DateTime.now().year}.pdf";
    ///
    ///
    final QuerySnapshot studentsData = await courseRef
        .doc(widget.course.courseCode)
        .collection('studentsEnrolled')
        .get();

    studentsData.docs.forEach(
      (studentData) {
        // print(doc.data());
        List<String> oneStudentData = [];
        final studentName = studentData.data()['studentName'];
        // print('student name');
        // print(studentName);
        final int absent = studentData.data()['absent'];
        // print('absent count');
        // print(absent);
        final int present = studentData.data()['present'];

        // print('add data to list');
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

    final time = DateTime.now();
    final date = "${time.day}/${time.month}/${time.year}";
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
                    'Attendence Sheet for ${widget.course.courseName}'),
            pw.Paragraph(text: 'As of : $date'),
            pw.Paragraph(text: 'Teacher: ${widget.course.teacherName}'),
            pw.Paragraph(text: 'Course Code: ${widget.course.courseCode}'),
            pw.Table.fromTextArray(context: context, data: listOfData),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Paragraph(text: 'This file is saved at: $savedPath'),
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

  ///old one
  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/${widget.course.courseCode}_${widget.course.courseName}_${DateTime.now().day}${monthsList[DateTime.now().month-1]}${DateTime.now().year}.pdf");

    file.writeAsBytesSync(pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final segmentedControlMaxWidth = ((SizeConfig.one_W*600.0).roundToDouble()).roundToDouble();

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
      2: Text('Messages'),
    };

    return dataFetched?
      CupertinoActivityIndicator():
      CupertinoPageScaffold(
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
            .copyWith(fontSize: (SizeConfig.one_W*13).roundToDouble()),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: (SizeConfig.one_H*16).roundToDouble()),
              SizedBox(
                // height: ,
                width: segmentedControlMaxWidth,
                child: CupertinoSegmentedControl<int>(
                  children: headingChildren,
                  onValueChanged: onValueChanged,
                  groupValue: currentSegment,
                ),
              ),
              SizedBox(
                height: (SizeConfig.one_H*20).roundToDouble(),
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


  ///particularCourseDetailsScreen
  ///by sourabh
  Widget particularCourseDetailsScreen() {
    return Container(
      child: ListView(
        shrinkWrap: true,
physics: NeverScrollableScrollPhysics(),
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
                        height: 5,
                      ),
                      Text('TEACHER : ${widget.course.teacherName}'.toUpperCase(),
                          style: TextStyle(
                            fontSize: (SizeConfig.one_W*14).roundToDouble(),
                            // fontWeight: FontWeight.w500,
                            color: CupertinoColors.white,
                          )),
                      SizedBox(
                        height: SizeConfig.one_H*5,
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
                  AttendanceViewForTeacher(
                    course: widget.course,
                  ),
                  SizedBox(height: (SizeConfig.one_H*18).roundToDouble(),),
                  takeAttendenceButton(),
                  learnMoreAboutAttendenceBtn(),
                ],
              ),

            ],
          ),
          Container()
        ],
      ),
    );
  }

  CupertinoButton learnMoreAboutAttendenceBtn(){
    return CupertinoButton(
      child: Text("Learn More about Attendance Mechanism"),
      onPressed: learnMoreAboutAttendenceDialog,
    );
  }

  ///called at: Show app demo
  ///and will take user to a youtube video
  _launchURL() async {
    const url = 'https://youtu.be/txSncSHJyG4';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void learnMoreAboutAttendenceDialog(){
    final attendanceMsg = "Total Classes increase by 1 every-time you take Attendance and update it. Swipe-able cards with student name on it will be displayed after you click TakeAttendance button. For more info watch demo.";
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Attendance Mechanism"),
            content: Text(attendanceMsg),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Okays"),
              ),
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _launchURL();
                  },
                  child: Text("Watch demo"),
              ),
            ],
          );
        });
  }


  ///this will navigate to the Attendence page where we can take attendence
  Widget takeAttendenceButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: (SizeConfig.one_W*16).roundToDouble()),
      child: CupertinoButton.filled(
          child: Text('Take Attendence'),
          onPressed: () async{
            await fetchData();
            // print("QQQQQQQQQ::::::   ${studentlist.length}");
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return TakeAttendencePage(
                noOfStudents: noOfStudents,
                user: widget.user,
                course: widget.course,list: studentlist,
              );
            }),
            ).then((value) {
              setState(() {
                dataFetched = false;
              },
              );
            },
            );
          },
      ),
    );
  }


  fetchData() async {
      setState(() {
        dataFetched = true;
      });

      final QuerySnapshot studentData = await courseRef
          .doc(widget.course.courseCode)
          .collection('studentsEnrolled')
          .get();

      // print('QQQQQQQQQQQQ::::: ${studentData.docs.length}');
      // print("QQQQQQQQQQQ:::  entering for loop");
      studentData.docs.forEach((student) {
        // print('QQQQQQQQQQ:::  entered for loop');
        final studentName = student.data()['studentName'];
        final studentId = student.data()['studentId'];
        noOfStudents = student.data()['totalStudents'];
        studentlist.add(
          StudentsForAttendanceCard(
              name: studentName, sid: studentId, status: false),
        );
        // print('QQQQQQQQ:::  $studentName');
        // print('QQQQQQQQ:::  ${studentlist.length}');
      }
      );
      // print(studentlist);

      //getting AppUrl
    final appInfoDoc = await appInfoRef.doc("info").get();

    playStoreUrl = appInfoDoc.data()['playStoreUrl'];

  }

  ///when we click on 3dots ICONS at top right
  ///this sheet appears from bottom and has 3-4 options
  myActionSheet(BuildContext context) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
              margin: EdgeInsets.symmetric(horizontal: (SizeConfig.one_W*14).roundToDouble()),
              child: CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () async {
                        ///
                        ///
                        ///
                        await writeOnPdf();
                        await savePdf();

                        Directory documentDirectory =
                            await getApplicationDocumentsDirectory();

                        String documentPath = documentDirectory.path;

                        String fullPath = "$documentPath/${widget.course.courseCode}_${widget.course.courseName}_${DateTime.now().day}${monthsList[DateTime.now().month-1]}${DateTime.now().year}.pdf";

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
                      child: Text('View AttendenceSheet')),
                  CupertinoActionSheetAction(
                      onPressed: () {
                        // print('sharing');
                        _shareClass(context);
                        Navigator.pop(context);
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
            ));
  }

  _shareClass(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final sharingText = 'This code is for class: ${widget.course.courseName},'
        'Join ${widget.course.courseName} course with code: ${widget.course.courseCode} by signing on this app $playStoreUrl';
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

                    try{
                      deleteTheCourseFromCloud(course);

                      Fluttertoast.showToast(
                          msg: "Course deleted",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: CupertinoTheme.of(context).primaryColor,
                          textColor: CupertinoColors.white,
                          fontSize: 16.0
                      );

                    } catch(e){

                      Fluttertoast.showToast(
                          msg: "Unexpected Error, try again",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: CupertinoTheme.of(context).primaryColor,
                          textColor: CupertinoColors.white,
                          fontSize: 16.0
                      );
                    }

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
  void deleteTheCourseFromCloud(Course course) async {

    final studentsEnrolled = await userRef
        .doc(widget.user.uid)
        .collection('createdCoursesByUser')
        .doc(course.courseCode)
        .collection('studentsEnrolled')
        .get();

    //when we delete the createdCoursesByUser collection ..
    // the [studentsEnrolled] and [messages] collection remains
    studentsEnrolled.docs.forEach((element) {
      if (element.exists) {
        element.reference.delete();
      }
    });

    final messages = await userRef
        .doc(widget.user.uid)
        .collection('createdCoursesByUser')
        .doc(course.courseCode)
        .collection('messagesByTeacher')
        .get();

    //when we delete the createdCoursesByUser collection ..
    // the [studentsEnrolled] and [messages] collection remains
    messages.docs.forEach((element) {
      if (element.exists) {
        element.reference.delete();
      }
    });

    courseRef.doc(course.courseCode).delete();

    userRef
        .doc(widget.user.uid)
        .collection('createdCoursesByUser')
        .doc(course.courseCode)
        .delete();
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


