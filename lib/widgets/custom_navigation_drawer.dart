import 'package:flutter/material.dart';


const attendoTextStyle = TextStyle(color: Colors.black);

//custom drawer class
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(

                      color: Colors.grey,
                    )),
              ),
              padding: const EdgeInsets.all(15.0),
              child: Text(
                '//Attendo',
                style: attendoTextStyle.copyWith(
                    fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text('Created By You:', style: attendoTextStyle.copyWith(fontWeight: FontWeight.w500),),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children:[
                            //TODO: add RealCourses to this list
                            Text('Course 1'),
                            Text('Course 2'),
                            Text('Course 3')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}