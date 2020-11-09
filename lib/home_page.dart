import 'package:attendo/screens/courses_display/createdClassScreen.dart';
import 'package:attendo/screens/courses_display/joinedClassScreen.dart';
import 'package:attendo/screens/other_screens/notifications_page.dart';
import 'package:attendo/screens/other_screens/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

const kHeaderStyle = TextStyle(
    fontFamily: 'inter',
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: Colors.black);

// final GoogleSignIn googleSignIn = GoogleSignIn();
// final userRef = FirebaseFirestore.instance.collection('users');

class HomePage extends StatefulWidget {

  HomePage({@required this.updateUser});
  VoidCallback updateUser;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController tabController;

  //variables for PageView
  PageController pageController;
  int pageIndex = 0;
  onTab(int pageIndex) {
    pageController.jumpToPage(pageIndex);

  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  ///this isAuth controls the which screen to show
  bool isAuth = false;
  GoogleSignInAccount userAccount;

  // login() {
  //   googleSignIn.signIn();
  // }
  //
  // logOut() {
  //   googleSignIn.signOut();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    pageController = PageController();

    ///getting and storing the UserAccount info
    // googleSignIn.onCurrentUserChanged.listen((account) {
    //   handleSignIn(account);
    // }, onError: (err) {
    //   print('error signing in- $err');
    // });
    //
    // ///when we open our app second time, then it auto sign in
    // googleSignIn.signInSilently(suppressErrors: false).then((account) {
    //   // CircularProgressIndicator();
    //   handleSignIn(account);
    // }).catchError((err) {
    //   print('error on silently sign in $err');
    // });
  }

  // handleSignIn(GoogleSignInAccount account) {
  //   if (account != null) {
  //     checkUserInFireStore();
  //     userAccount = account;
  //     print('User $account');
  //     setState(() {
  //       isAuth = true;
  //     });
  //   } else {
  //     setState(() {
  //       isAuth = false;
  //     });
  //   }
  // }

  // checkUserInFireStore() async{
  //   //check if user already exist in database according to their ID
  //   final GoogleSignInAccount user = googleSignIn.currentUser;
  //   final DocumentSnapshot doc = await userRef.doc(user.id).get();
  //   //
  //   userRef.doc(user.id).set({
  //     "id": user.id,
  //     "userName": user.displayName,
  //     "photoUrl": user.photoUrl,
  //     "userEmail": user.email
  //
  //   });
  //
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }


  ///sign in screen
  // MaterialApp signInScreen() {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: Scaffold(
  //       body: Container(
  //         child: Center(
  //           child: GestureDetector(
  //             onTap: () {
  //               print('TODO');
  //             },
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 100),
  //               child: Image(
  //                 image: AssetImage('assets/images/others/signInGoogle.png'),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  ///welcome Page will be shown after user sign in with google
  ///basically Welcome Home page
  MaterialApp welcomePage() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 100,
            elevation: 0.0,
            title: Padding(
              padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
              child: Title(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hey,', style: kHeaderStyle),
                        Text('USER',
                            style: kHeaderStyle),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, right: 20, bottom: 10),
                      child: CircleAvatar(
                        //TODO: attachPhotoURL
                        //backgroundImage: NetworkImage(userAccount.photoUrl),
                        radius: 30,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: onPageChanged,
            children: <Widget>[
              CreatedClassScreen(),
              //TODO: attachPhotoURLwithACCOUNT
              UserProfile(onSignOut: ()=>widget.updateUser(),),
              NotificationPage(),
              JoinedClassScreen(),
            ],
          ),
          bottomNavigationBar: CupertinoTabBar(
            currentIndex: pageIndex,
            onTap: onTab,
            activeColor: Colors.blueAccent,
            items: [
              ///this is where we are setting aur bottom ICONS
              BottomNavigationBarItem(icon: Icon(Icons.add)),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined)),
              BottomNavigationBarItem(icon: Icon(Icons.alternate_email_rounded)),
              BottomNavigationBarItem(icon: Icon(Icons.settings)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///this is where we are deciding which Screen to show: by isAuth bool
    return welcomePage();
  }
}

///welcome Page will be shown after user sign in with google [FAILED]
//  MaterialApp welcomePage(){
//   return MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: SafeArea(
//       child: Scaffold(
//         drawer: CustomDrawer(),
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: Colors.black),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Hello ${userAccount.displayName}',
//                 style: attendoTextStyle,
//               ),
//               GestureDetector(
//                 onTap: (){
//                   logOut();
//                 },
//                 child: Icon(
//                   Icons.exit_to_app,color: Colors.black,
//                 ),
//               )
//             ],
//           ),
//           backgroundColor: Colors.white,
//           bottom: TabBar(
//             labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             labelPadding: EdgeInsets.all(8),
//             controller: tabController,
//             tabs: [
//               Text(
//                 'CreatedClass',
//                 style: attendoTextStyle,
//               ),
//               Text(
//                 'JoinedClass',
//                 style: attendoTextStyle,
//               )
//             ],
//           ),
//         ),
//         body: TabBarView(
//           controller: tabController,
//           children: [
//             CreatedClassScreen(),
//             JoinedClassScreen(),
//           ],
//         ),
//       ),
//     ),
//   );
// }