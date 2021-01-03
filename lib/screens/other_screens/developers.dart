import 'package:attendo/modals/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

//media query r2d
const kEmail = "okaysduo@gmail.com";

class DevelopersPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('About Us'),
      ),
      child: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text("Made with ♥ at",style: TextStyle(fontSize: (SizeConfig.one_W*13).roundToDouble()),)),
            Center(
              child: Container(
                  height: (SizeConfig.one_H*100).roundToDouble(),
                  width: (SizeConfig.one_W*100).roundToDouble(),
                  child: Image.asset('assets/images/aboutUs_logo_01.png'),
              ),
            ),
            SizedBox(height: (SizeConfig.one_H*50).roundToDouble(),),
                  Text("Contact us at :",style: TextStyle(fontSize:( SizeConfig.one_W*13).roundToDouble()),),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                      onPressed: _launchEmail,
                    child: Text(kEmail,style: TextStyle(fontSize: (SizeConfig.one_W*13).roundToDouble()),),),
            SizedBox(height: (SizeConfig.one_H*50).roundToDouble(),),
            Text("CREDITS:"),
            creditThing(webSiteName: "freepik",msg: "for free resources",url: "https://www.freepik.com/free-photos-vectors/study"),
            creditThing(webSiteName: "BeFonts ",msg: "for free Fonts", url: "https://befonts.com/lot-font.html"),
          ],
        ),
      ),
    );
  }

  //credit thing for Freepik
  creditThing({String webSiteName, String msg,String url}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("> Thanks ",style: TextStyle(fontSize: (SizeConfig.one_W*13).roundToDouble()),),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: (){
            launchFreepikURL(url);
          },
          child: Text(webSiteName,style: TextStyle(fontSize: (SizeConfig.one_W*13).roundToDouble()),),),
        Text(msg,style: TextStyle(fontSize: (SizeConfig.one_W*13).roundToDouble()),),
      ],
    );
  }

  launchFreepikURL(String web_url) async {
      final url = web_url;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }




  _launchEmail() async{
    final Uri _emailLaunchUri = Uri(

        scheme: 'mailto',
        path: kEmail,
        // queryParameters: {
        //   'subject': 'Example Subject & Symbols are allowed!'
        // }
    );
// mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21
    launch(_emailLaunchUri.toString());
  }
}
