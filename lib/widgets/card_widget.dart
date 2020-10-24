import 'dart:math';

import 'package:flutter/material.dart';
import 'package:attendo/modals/course_class.dart';

const attendoTextStyle = TextStyle(color: Colors.white, fontSize: 18);

class CardWidget extends StatelessWidget {
  CardWidget({this.course,this.imagePath });

  final imagePath;
  final Course course;

  @override
  Widget build(BuildContext context) {



    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: EdgeInsets.only(top: 6, bottom: 6, left: 6,right: 6),
          padding: EdgeInsets.only(top: 15, left: 15, bottom: 15),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    imagePath,
                  )),
              color: Colors.red,
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.courseName,
                style: attendoTextStyle,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Batch  ${course.yearOfBatch}',
                style: attendoTextStyle.copyWith(fontSize: 12),
              ),
              Text(
                'Code:${course.courseCode.toString()}',
                style: attendoTextStyle,
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Teacher: UserName',
                style: attendoTextStyle.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
