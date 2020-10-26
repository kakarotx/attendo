import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Screens/createdClassScreen.dart';
import 'Screens/joinedClassScreen.dart';
import 'package:attendo/widgets/custom_navigation_drawer.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  ///this isAuth controls the which screen to show
  bool isAuth = false;
  GoogleSignInAccount userAccount;

  login(){
    googleSignIn.signIn();
  }

  logOut(){
    googleSignIn.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    ///getting and storing the UserAccount info
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    },
    onError: (err){
      print('error signing in- $err');
    });

    ///when we open our app second time, then it auto sign in
    googleSignIn.signInSilently(suppressErrors: false).then((account){
      handleSignIn(account);
    }
    ).catchError((err){
      print('error on silently sign in $err');
    });
  }

  handleSignIn(GoogleSignInAccount account){
    if(account!=null){
      userAccount = account;
      print('User $account');
      setState(() {
        isAuth = true;
      });
    } else{
      setState(() {
        isAuth = false;
      });

    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  ///welcome Page will be shown after user sign in with google
  MaterialApp welcomePage(){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(

          drawer: CustomDrawer(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello ${userAccount.displayName}',
                  style: attendoTextStyle,
                ),
                GestureDetector(
                  onTap: (){
                    logOut();
                  },
                  child: Icon(
                    Icons.exit_to_app,color: Colors.black,
                  ),
                )
              ],
            ),
            backgroundColor: Colors.white,
            bottom: TabBar(
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              labelPadding: EdgeInsets.all(8),
              controller: tabController,
              tabs: [
                Text(
                  'CreatedClass',
                  style: attendoTextStyle,
                ),
                Text(
                  'JoinedClass',
                  style: attendoTextStyle,
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              CreatedClassScreen(),
              JoinedClassScreen(),
            ],
          ),
        ),
      ),
    );
  }

  ///sign in screen
  MaterialApp signInScreen(){
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Center(
            child: GestureDetector(
                onTap: () {
                login();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Image(
                    image: AssetImage('assets/images/others/signInGoogle.png'),
                  ),
                ),
              ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///this is where we are deciding which Screen to show: by isAuth bool
    return isAuth ? welcomePage() : signInScreen();
  }
}





