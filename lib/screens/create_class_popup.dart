import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math';

//to create your own new classes
const bottomDrawerStyle = TextStyle(
  color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold
);

class CreateNewClassScreen extends StatelessWidget {
  final _random = new Random();
  int randomClassCode(int min, int max) => min + _random.nextInt(max - min);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Course :',
                  style: bottomDrawerStyle.copyWith(fontSize: 20),
                ),
                Expanded(
                  child: TextField(
                    style: bottomDrawerStyle,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: 'Enter Course Name',
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Batch :',
                  style: bottomDrawerStyle,
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter Year',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text(
              'Class Code : ${randomClassCode(9999, 99999)}',
              style: bottomDrawerStyle,
            ),
            SizedBox(height: 20,),

            Center(
              child: RaisedButton(
                onPressed: (){
                  print('hello');
                },
                child: Text('Create Class', style: TextStyle(color: Colors.white),),
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
