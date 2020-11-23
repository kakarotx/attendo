import 'package:attendo/modals/course_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final courseRef = FirebaseFirestore.instance.collection('coursesDetails');
final userRef = FirebaseFirestore.instance.collection('users');

//TODO: later pass the user through constructor
final User user = FirebaseAuth.instance.currentUser;

class AddAssignmentScreen extends StatefulWidget {
  AddAssignmentScreen({this.course, @required this.canSendMessages});
  final Course course;
  final bool canSendMessages;
  // final User user;

  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final courseRef = FirebaseFirestore.instance.collection('coursesDetails');
  String textMessage;
  TextEditingController textEditingController;
  String teacherImageUrl;
  FlutterLocalNotificationsPlugin fltrNotification;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    var androidInitilize = new AndroidInitializationSettings('ic_launcher');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitilize, iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future notificationSelected(String payload) async {}

  Future _showNotifications({String sender, String message}) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.Max);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iOSDetails);

    await fltrNotification.show(
        0, "$sender", "$message", generalNotificationDetails,
        payload: "Task");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.canSendMessages
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: CupertinoTextField(
                  controller: textEditingController,
                  onChanged: (message) {
                    textMessage = message;
                  },
                  suffix: CupertinoButton(
                    onPressed: () {
                      textEditingController.clear();
                      print('uploading');
                      if (textMessage != null) {
                        uploadDataToCloud(
                            course: widget.course, textMessage: textMessage);
                        print('uploaded');
                      } else{
                        print('QWERTY:: null message cant upload');
                      }
                    },
                    child: Text('Send'),
                  ),
                ),
              )
            : Container(),
        Container(
          child: buildMessageList(course: widget.course),
        ),
      ],
    );
  }

  ///this uploading Message data to a Particular Collection
  ///Later we listen for the changes in this Stream and Create MessageCard
  uploadDataToCloud({Course course, String textMessage}) {
    courseRef.doc(course.courseCode).collection('messagesByTeacher').doc().set({
      'sendTime': DateTime.now(),
      'senderEmail': course.teacherName,
      'textMessage': textMessage,
      'teacherImageUrl': course.teacherImageUrl,
      'teacherName': user.displayName,
    });

    userRef
        .doc(user.uid)
        .collection('joinedCoursesByUser')
        .doc()
        .collection('messagesByTeacher')
        .doc()
        .set({
      'sendTime': DateTime.now(),
      'senderEmail': course.teacherName,
      'textMessage': textMessage,
      'teacherImageUrl': course.teacherImageUrl,
      'teacherName': user.displayName,
    });
  }

  ///building Messages to Card
  buildMessageList({Course course}) {
    return StreamBuilder<QuerySnapshot>(
      stream: courseRef
          .doc(course.courseCode)
          .collection('messagesByTeacher')
          .orderBy('sendTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CupertinoActivityIndicator();
        } else {
          final messages = snapshot.data.docs;
          List<MessageCard> messagesWidgets = [];
          for (var message in messages) {
            final messageData = message.data();
            final textMessage = messageData['textMessage'];
            final teacherImageUrl = messageData['teacherImageUrl'];
            final teacherName = messageData['teacherName'];
            messagesWidgets.add(
              MessageCard(
                textMessage: textMessage,
                teacherName: teacherName,
                teacherImageUrl: teacherImageUrl,
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: messagesWidgets.length,
            itemBuilder: (context, int) {
              //for displaying OnScreen Notification
              _showNotifications(
                  sender: messagesWidgets.first.teacherName,
                  message: messagesWidgets.first.textMessage);
              return messagesWidgets[int];
            },
          );
        }
      },
    );
  }
}

class MessageCard extends StatelessWidget {
  MessageCard({this.textMessage, this.teacherName, this.teacherImageUrl});

  final String teacherName;
  final String teacherImageUrl;
  final String textMessage;

  final List<String> monthsList = [
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
                  Text(teacherName),
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
