import 'package:attendo/modals/size_config.dart';
import 'package:flutter/cupertino.dart';

//Media Query r2d

final kAttendanceCardText = TextStyle(
  color: CupertinoColors.white,
  fontSize:(SizeConfig.one_W*40).roundToDouble(),
  fontWeight: FontWeight.w700,
);

class AttendanceCard extends StatelessWidget {
  AttendanceCard({this.enrolled, this.isThisUpdateCard=false});

  final String enrolled;
  final bool isThisUpdateCard ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (SizeConfig.one_H*200).roundToDouble(),
      margin: EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        color: CupertinoColors.activeBlue,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              enrolled.toUpperCase(),
              textAlign: TextAlign.center,
              style: kAttendanceCardText,
            ),
            isThisUpdateCard?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '> Swipe right to Update Attendance'
                  ,
                  style: TextStyle(color: CupertinoColors.white),
                ),
                Text(
                  '< Swipe left to cancel',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ],
            ):
                Container(),
          ],
        ),
      ),
    );
  }
}
