import 'package:attendo/home_page.dart';
import 'package:attendo/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  void initState() {
    super.initState();
    auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      print('user :${user?.uid}');
    });
  }


  @override
  Widget build(BuildContext context) {
    return LandingPageBody();
  }
}

class LandingPageBody extends StatefulWidget {
  @override
  _LandingPageBodyState createState() => _LandingPageBodyState();
}

class _LandingPageBodyState extends State<LandingPageBody> {

  CupertinoThemeData lightThemeData = CupertinoThemeData(
    brightness: Brightness.light,
  );
  CupertinoThemeData darkThemeData = CupertinoThemeData(
    brightness: Brightness.dark,
    // barBackgroundColor: CupertinoColors.black,
    // primaryColor: CupertinoColors.activeBlue,
    // primaryContrastingColor: CupertinoColors.white,
    // scaffoldBackgroundColor: CupertinoColors.systemGrey,
  );

  bool isThemeLight=true;

  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isThemeLight', isThemeLight);
  }

  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('isThemeLight');
    if(boolValue != null){
      isThemeLight = boolValue;
    } else{
      isThemeLight = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBoolValuesSF();
  }

  CupertinoThemeData themeDecider(){
    if(isThemeLight==null){
      return null;
    }
    if(isThemeLight==true){
      return CupertinoThemeData(brightness: Brightness.light);
    } else{
      return CupertinoThemeData(brightness: Brightness.dark);
    }
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      // theme: CupertinoThemeData(brightness: Brightness.light),
      theme: isThemeLight?CupertinoThemeData(brightness: Brightness.light):CupertinoThemeData(brightness: Brightness.dark),
      // theme: themeDecider(),
      debugShowCheckedModeBanner: false,

      home: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        child: StreamBuilder<auth.User>(
            initialData: auth.FirebaseAuth.instance.currentUser,
            ///this is the stream of type [User] and we listen to it
            ///when any new data comes
            ///the builder: property builds it self every time new
            ///data comes
            stream: auth.FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              ///this snapshot contains the Data from our Stream
              ///Stream can contain any data eg. [int, list, null]
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                if (user == null) {
                  print('qwerty ::${user?.uid}');
                  return SignInPage();
                } else{
                  print('qwerty ::${user?.uid}');
                  return HomePage(toggleTheme: () {
                    print('theme changed');
                    addBoolToSF();
                    setState(() {
                      isThemeLight = !isThemeLight;
                    });
                  },);
                }
              } else{
                return CupertinoPageScaffold(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }

            }),
      ),
    );
  }
}

