// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:jtbMusicPlayer/data/tabstates.dart';
import 'package:jtbMusicPlayer/pages/intro_screen.dart';
import 'package:jtbMusicPlayer/pages/splash_screen.dart';
import 'package:jtbMusicPlayer/rootpage.dart';
import 'package:provider/provider.dart';
import 'package:jtbMusicPlayer/data/youtube_api.dart';
import 'data/userinfo.dart';


var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => RootPage(),
  //"/intro": (BuildContext context) => IntroScreen(),
};

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserInfomation>( builder : (context) => UserInfomation(),),
          ChangeNotifierProvider<TabStates> (builder : (context) => TabStates(),),
          ChangeNotifierProvider<YoutubeInfo> (builder: (context) => YoutubeInfo(),),
        ] ,
        child: MaterialApp(
          home : SplashScreen(),
          routes: routes,
        )
    );
  }
}