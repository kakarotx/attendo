import 'package:attendo/home_page.dart';
import 'package:attendo/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendo/main.dart';

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
  // getBoolValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return bool
  //   bool boolValue = prefs.getBool('isThemeLight');
  //   isThemeLight = boolValue;
  //   print('isThemeLight saved as $boolValue locally');
  // }

  // addBoolToSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isThemeLight', isThemeLight);
  // }



  @override
  Widget build(BuildContext context) {

    // setThemeToNull();
    return
      LandingPageBody();
  }
}

// ignore: must_be_immutable
class LandingPageBody extends StatefulWidget {
  // LandingPageBody({this.isThemeLight});
  // bool isThemeLight;
  @override
  _LandingPageBodyState createState() => _LandingPageBodyState();
}

class _LandingPageBodyState extends State<LandingPageBody> {

  ///this is not used anywhere but this is how we set the dark and light theme
  ///specifing the The MAIN COLORS USED in the app
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

  bool isThemeLight;

  ///when the user starts the app for the first time, the BOOL which decides the theme is null,
  ///so we are checking if the User is null => set Theme to LightTheme: and save it to the SharedPreferences
  setThemeToNull() async{
    if(auth.FirebaseAuth.instance.currentUser==null && isThemeLight==null)
    {
      isThemeLight=true;
    }
    await addBoolToSF();
  }

  ///gets the data from local storage
  getBoolValuesSF() async {
    //Return bool
    bool boolValue = sharedPref.getBool('isThemeLight');
    isThemeLight = boolValue;
    print('getting isThemeLight as $boolValue from local');
  }

  ///this function saves the bool [isThemeLight] on local storage
  addBoolToSF() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    sharedPref.setBool('isThemeLight', isThemeLight);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBoolValuesSF();
  }


  @override
  Widget build(BuildContext context) {

    getBoolValuesSF();
    setThemeToNull();

    return CupertinoApp(
      theme:
      isThemeLight?
      CupertinoThemeData(brightness: Brightness.light):
      CupertinoThemeData(brightness: Brightness.dark),

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
              ///
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                if (user == null) {
                  print('qwerty ::${user?.uid}');
                  return SignInPage(
                    isThemeLight: isThemeLight,
                  );
                } else{
                  print('qwerty ::${user?.uid}');
                  return
                    HomePage(toggleTheme: () {
                    print('theme changed');

                    print('theme saved to phone locally as ${!isThemeLight}');
                    setState(() {
                      isThemeLight = !isThemeLight;
                    });
                    addBoolToSF();
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

