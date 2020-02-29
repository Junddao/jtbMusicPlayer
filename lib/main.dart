import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jtbMusicPlayer/rootpage.dart';
import 'package:provider/provider.dart';
import 'data/userinfo.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:permission_handler/permission_handler.dart';



void main(){
  Admob.initialize("com.jtb.jtbMusicPlayer");
  runApp(
    new MaterialApp(
      home: MyApp(),
    ) 
  );
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {

    return new SplashScreen(
      seconds: 1,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text('/ J T B /',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Colors.white,
      ),), 
      //image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
      
      backgroundColor: Colors.grey[600],
      styleTextUnderTheLoader: new TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),
      photoSize: 100.0,
      onClick: ()=>print("Flutter Egypt"),
      loaderColor: Colors.white,
      //loadingText: Text('Now Loading'),
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    permission();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfomation>( builder : (context) => UserInfomation(),),
        // ChangeNotifierProvider<YoutubeInfo> (builder: (context) => YoutubeInfo(),),
      ] ,
      child: MaterialApp(
        home : RootPage(),

      )
    );
  }

  void permission() async {

    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    print('per1 : $permissions');
    
    
  }
}

  

