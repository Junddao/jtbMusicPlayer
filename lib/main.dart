import 'package:flutter/material.dart';
import 'package:ourpromise/data/tabstates.dart';
import 'package:ourpromise/rootpage.dart';
import 'package:provider/provider.dart';
import 'data/userinfo.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserInfomation>( builder : (context) => UserInfomation(),),
          ChangeNotifierProvider<TabStates> (builder : (context) => TabStates(),),
        ] ,
        child: MaterialApp(
          home : new RootPage(),
        )
    );
  }
}