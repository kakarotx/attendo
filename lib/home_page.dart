
import 'package:attendo/screens/courses_display/createdClassScreen.dart';
import 'package:attendo/screens/courses_display/joinedClassScreen.dart';
import 'package:attendo/screens/other_screens/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

///this is HomeScreen, which is shown after user logs in;
///contained 3TABS at bottom
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  String profileImageUrl;
  String userName;
  String userEmail;
  String userId;

  ///these are KEYS which are assigned to every Tab,
  ///the problem of navigation is solved by these KEYS
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();

  CupertinoTabController tabController;
  ///this isAuth controls the which screen to show
  bool isAuth = false;
  GoogleSignInAccount userAccount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = CupertinoTabController(initialIndex: 0);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///welcome Page will be shown after user sign in with google
  ///basically Welcome Home page
  CupertinoApp welcomePage(BuildContext context) {

    final listOfKeys = [
      firstTabNavKey,
      secondTabNavKey,
      thirdTabNavKey
    ];

    List homeScreenList = [
      CreatedClassScreen(user: user,),
      UserProfile(user: user,),
      // NotificationPage(),
      JoinedClassScreen(user: user,),
    ];
    return CupertinoApp(
      // theme: CupertinoThemeData(brightness: Brightness.light,),

      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          return !await listOfKeys[tabController.index].currentState.maybePop();
        },
        child: CupertinoTabScaffold(
          controller: tabController,
              tabBar: CupertinoTabBar(

                items: [
                  ///this is where we are setting aur bottom ICONS
                  BottomNavigationBarItem(
                    label: 'AddClass',
                      icon: Icon(CupertinoIcons.add_circled_solid)),
                  BottomNavigationBarItem(
                    label: 'Profile',
                      icon: Icon(CupertinoIcons.person_solid)),
                  // BottomNavigationBarItem(
                  //     label: 'Alerts',
                  //     icon: Icon(CupertinoIcons.bell_solid)),
                  BottomNavigationBarItem(
                    label: 'Joined',
                      icon: Icon(CupertinoIcons.xmark_circle_fill)),
                ],
                // currentIndex: pageIndex,
              ),
              tabBuilder: (context, index, ) {

                return CupertinoTabView(
                  navigatorKey: listOfKeys[index],
                  builder: (context) {
                    return homeScreenList[index];
                  },
                );
              },
        ),
      ),
    );}

  @override
  Widget build(BuildContext context) {
    profileImageUrl = user.photoURL;
    userName = user.displayName;
    userEmail = user.email;
    userId = user.uid;

    return welcomePage(context);
  }
}
