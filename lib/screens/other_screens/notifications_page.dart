import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:attendo/screens/particular_course_pages/add_message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///notification page will be taken care later
///AS OF NOW I AM leaving it pending
///
///
class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}
///
///
///
class _NotificationPageState extends State<NotificationPage> {
  FlutterLocalNotificationsPlugin fltrNotification;

  final User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('ic_launcher');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future _showNotifications({String sender, String message}) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.Max);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iOSDetails);

    await fltrNotification.show(
        0, "pulkit", "You created a Task", generalNotificationDetails,
        payload: "Task");
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Notifications'),
      ),
      child: Container(
        child: Center(child: Text('NotificationPage',)),
      ),
    );
  }

  Future notificationSelected(String payload) async {}

  ///building Messages to Card
  buildNotificationsList(){
    return StreamBuilder<QuerySnapshot>(
      stream: courseRef.doc(user.uid).collection('joinedCoursesByUser').doc().collection('messagesByTeacher').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return CupertinoActivityIndicator();
        } else{
          return null;
        }
      },
    );
  }
}
///
///
///
class NotificationCard extends StatelessWidget {
  NotificationCard({this.textMessage, this.sender, this.teacherImageUrl});

  final String sender;
  final String teacherImageUrl;
  final String textMessage;

  List<String> monthsList = [
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 14, right: 14, top: 16),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: CupertinoColors.extraLightBackgroundGray,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(teacherImageUrl),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sender),
                  Text(
                      '${DateTime.now().day} ${monthsList[DateTime.now().month]}'),
                ],
              )
            ],
          ),
          SizedBox(height: 40),
          Container(
            child: Text(
              textMessage,
              style: TextStyle(color: CupertinoColors.black),
            ),
          ),
        ],
      ),
    );
  }
}

