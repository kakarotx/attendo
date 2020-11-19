import 'package:flutter/cupertino.dart';

class TakeAttendencePage extends StatefulWidget {
  @override
  _TakeAttendencePageState createState() => _TakeAttendencePageState();
}

class _TakeAttendencePageState extends State<TakeAttendencePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Attendence Page'),
      ),
      child: Container(
        child: Text('Attendence Page'),
      ),
    );
  }
}
