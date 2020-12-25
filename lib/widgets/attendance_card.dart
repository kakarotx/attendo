import 'package:attendo/modals/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//Media Query r2d

final kAttendanceCardText = TextStyle(
  color: CupertinoColors.white,
  fontSize:(SizeConfig.one_W*40).roundToDouble(),
  fontWeight: FontWeight.w700,
);

class AttendanceCard extends StatelessWidget {
  AttendanceCard({this.enrolled});

  final String enrolled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (SizeConfig.one_H*150).roundToDouble(),
      decoration: BoxDecoration(
        color: CupertinoColors.activeBlue,
      ),
      child: Center(
        child: Text(
          enrolled.toUpperCase(),
          style: kAttendanceCardText,
        ),
      ),
    );
  }
}
