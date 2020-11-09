import 'package:flutter/material.dart';

///this is the zeroCCScreen or [NO CLASS CREATED SCREEN]
class ZeroClassScreen extends StatelessWidget{

  ZeroClassScreen({this.title});

  ///later in place of displaying title, we will display an Image
  final String title;
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Text(title,
        style: TextStyle(fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black54),
      ),
    );
  }
}
