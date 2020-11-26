import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final userRef = FirebaseFirestore.instance.collection('users');

// ignore: must_be_immutable
class SetRollNoPage extends StatelessWidget {
  SetRollNoPage({this.user});

  final User user;
  String enteredRollNumber;

  updateRollNo(){
    userRef.doc(user.uid).update({
      'rollNo': enteredRollNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Set Rollno.'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Set'),
          onPressed: (){
            updateRollNo();
            Navigator.pop(context);
          },
        ),
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'StudentName  : ',
            ),
            Expanded(
              child: CupertinoTextField(
                placeholder: 'Enter Student Name',
                onChanged: (String newValue) {
                  enteredRollNumber=newValue;
                },
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IMPORTANT',
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                  '1. You can also add student manually.'),
              SizedBox(
                height: 10,
              ),
              Text(
                  "2. This helps to have you record of students who doesnot have phone"),
            ],
          ),
        )
      ],
    ),
    );
  }
}