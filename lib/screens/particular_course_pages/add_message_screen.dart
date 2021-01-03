import 'package:attendo/modals/course_class.dart';
import 'package:attendo/modals/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//MediaQuery r2d

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
    // var androidInitilize = new AndroidInitializationSettings('ic_launcher');
    // var iOSinitilize = new IOSInitializationSettings();
    // var initilizationsSettings =
    //     new InitializationSettings(androidInitilize, iOSinitilize);
    // fltrNotification = new FlutterLocalNotificationsPlugin();
    // fltrNotification.initialize(initilizationsSettings,
    //     onSelectNotification: notificationSelected);
  }

  // Future notificationSelected(String payload) async {}
  //
  // Future _showNotifications({String sender, String message}) async {
  //   var androidDetails = new AndroidNotificationDetails(
  //       "Channel ID", "Desi programmer", "This is my channel",
  //       importance: Importance.Max);
  //   var iOSDetails = new IOSNotificationDetails();
  //   var generalNotificationDetails =
  //       new NotificationDetails(androidDetails, iOSDetails);
  //
  //   await fltrNotification.show(
  //       0, "$sender", "$message", generalNotificationDetails,
  //       payload: "Task");
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.canSendMessages
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: (3.57*SizeConfig.widthMultiplier).roundToDouble()),
                child: CupertinoTextField(
                  placeholder: "Type message for Students",
                  controller: textEditingController,
                  onChanged: (message) {
                    textMessage = message;
                  },
                  suffix: CupertinoButton(
                    onPressed: () {
                      textEditingController.clear();
                      // print('uploading');
                      if (textMessage != null) {
                        uploadDataToCloud(
                            course: widget.course, textMessage: textMessage);
                        // print('uploaded');
                      } else{
                        // print('QWERTY:: null message cant upload');
                      }
                    },
                    child: Text('Send'),
                  ),
                ),
              )
            : Container(),
        Container(
          // height: (SizeConfig.one_H*400).roundToDouble(),
          child: SingleChildScrollView(

        child: buildMessageList(course: widget.course,context: context)
        )

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
      'teacherName': course.teacherName,
    });
  }

  ///building Messages to Card
  buildMessageList({Course course,BuildContext context}) {
    return StreamBuilder<QuerySnapshot>(
      stream: courseRef
          .doc(course.courseCode)
          .collection('messagesByTeacher').orderBy('sendTime',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              margin: EdgeInsets.only(top: (SizeConfig.one_H*35).roundToDouble()),
              child: CupertinoActivityIndicator());
        } else {
          final messages = snapshot.data.docs;
          List<MessageCard> messagesWidgets = [];
          for (var message in messages) {
            final messageData = message.data();
            final idOfMsgDoc = message.id;
            final textMessage = messageData['textMessage'];
            final teacherImageUrl = messageData['teacherImageUrl'];
            final teacherName = messageData['teacherName'];
            //building a function to delete this message
             void deleteMessage() {
               courseRef
                   .doc(course.courseCode)
                   .collection('messagesByTeacher').doc(idOfMsgDoc).delete();
            }
            messagesWidgets.add(
              MessageCard(
                canSendMsg: widget.canSendMessages,
                textMessage: textMessage,
                teacherName: teacherName,
                teacherImageUrl: teacherImageUrl,
                deleteMsg: deleteMessage,
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // physics: AlwaysScrollableScrollPhysics(),
            itemCount: messagesWidgets.length,
            itemBuilder: (context, int) {
              ///for displaying OnScreen Notification
              ///notification functionality
              // _showNotifications(
              //     sender: messagesWidgets.first.teacherName,
              //     message: messagesWidgets.first.textMessage);
              return messagesWidgets[int];
            },
          );
        }
      },
    );
  }
}


class MessageCard extends StatelessWidget {
  MessageCard({this.textMessage, this.teacherName, this.teacherImageUrl, this.deleteMsg,@required this.canSendMsg});

  final String teacherName;
  final String teacherImageUrl;
  final String textMessage;
  final Function deleteMsg;
  final bool canSendMsg;

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
      margin: EdgeInsets.only(
          left: (3.57*SizeConfig.widthMultiplier).roundToDouble(),
          right: (3.57*SizeConfig.widthMultiplier).roundToDouble(),
          top: (1.96*SizeConfig.heightMultiplier).roundToDouble()),
      padding: EdgeInsets.symmetric(
          horizontal: (3.57*SizeConfig.widthMultiplier).roundToDouble(),
          vertical: (1.96*SizeConfig.heightMultiplier).roundToDouble()),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((1.53*SizeConfig.widthMultiplier).roundToDouble()),
        color: CupertinoTheme.of(context).barBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(teacherImageUrl),
                  ),
                  SizedBox(width: (2.55*SizeConfig.widthMultiplier).roundToDouble()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(teacherName),
                      Text(
                          '${DateTime.now().day} ${monthsList[(DateTime.now().month)-1]}'),
                    ],
                  )
                ],
              ),
              !canSendMsg?
                  Container():
              CupertinoButton(
                onPressed: deleteMsg,
                child: Icon(CupertinoIcons.delete, color: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.color,),
              )
            ],
          ),
          SizedBox(height: (4.9*SizeConfig.heightMultiplier).roundToDouble()),
          Container(
            child: Text(
              textMessage,
            ),
          ),
        ],
      ),
    );
  }
}
