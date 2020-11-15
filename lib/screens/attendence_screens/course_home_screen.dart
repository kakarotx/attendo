import 'package:attendo/modals/course_class.dart';
import 'package:attendo/widgets/card_widget.dart';
import 'package:attendo/widgets/student_list.dart';
import 'package:flutter/cupertino.dart';

///when Teacher tab on CourseCard, that will take us here
///This page will contain details like::
///[No of Students][Total Classes taken] [List of Students] and
///[Option to take attendence]
///
///
/// This Page will be shown to Teachers

import 'package:flutter/material.dart';

class CupertinoSegmentedControlDemo extends StatefulWidget {
  CupertinoSegmentedControlDemo({this.course});
  final Course course;

  @override
  _CupertinoSegmentedControlDemoState createState() =>
      _CupertinoSegmentedControlDemoState();
}

class _CupertinoSegmentedControlDemoState
    extends State<CupertinoSegmentedControlDemo> {
  int currentSegment = 0;

  void onValueChanged(int newValue) {
    setState(() {
      currentSegment = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final segmentedControlMaxWidth = 600.0;

    //this list contains the Body of the segments
    final children = <int, Widget>{
      0: particularCourseDetailsScreen(),
      ///this 1: will take LIST OF STUDENTS
      ///as of now it is ok
      1: StudentsList(course: widget.course,),
      2: Text('QWERTY'),
    };

    //Headlines of CupertinoSegmentedControl
    final headingChildren = <int, Widget>{
      0: Text('Course'),
      1: Text('Students'),
      2: Text('Qwerty'),
    };

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.course.courseName.toUpperCase()
        ),
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
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: children[currentSegment],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget particularCourseDetailsScreen() {
    return CardWidget(newCourse: widget.course,onTabActive: false,);
  }
}

///Old Style SegmentedControl
///
///
// SizedBox(
// width: segmentedControlMaxWidth,
// child: Padding(
// padding: const EdgeInsets.all(16),
// child: CupertinoSlidingSegmentedControl<int>(
// children: children,
// onValueChanged: onValueChanged,
// groupValue: currentSegment,
// ),
// ),
// ),
