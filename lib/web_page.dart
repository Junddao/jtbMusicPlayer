
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
// import 'package:flutter_inappwebview/src/in_app_webview.dart';
// import 'package:flutter_inappwebview/src/webview_options.dart';
// import 'package:flutter_inappwebview/src/types.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';




import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
// import 'package:jtbMusicPlayer/services/myadshelper.dart';
import 'package:flutter/services.dart';


// import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {

  final String title;
  const WebPage({Key key, this.title}) : super(key: key);
    

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> with WidgetsBindingObserver{
  
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;
  StreamSubscription<HardwareButtons.LockButtonEvent> _lockButtonSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _homeButtonSubscription = HardwareButtons.homeButtonEvents.listen((event) {
      setState(() {
        webView.android.pause();
      });
    });

    _lockButtonSubscription = HardwareButtons.lockButtonEvents.listen((event) {
      setState(() {
        webView.android.pause();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _homeButtonSubscription?.cancel();
    _lockButtonSubscription?.cancel();
    super.dispose();
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _notification = state;
     if(state == AppLifecycleState.resumed){
      // user returned to our app
      webView.android.resume();
      
    }else if(state == AppLifecycleState.inactive){
      // app is inactive
    }else if(state == AppLifecycleState.paused){
 
    }
  }

  
  String youtubeUri = 'https://youtube.com/';
  String query = 'results?search_query=';
  // WebViewController _webViewController;

handleAppLifecycleState() {
    AppLifecycleState _lastLifecyleState;
    SystemChannels.lifecycle.setMessageHandler((msg) {

     print('SystemChannels> $msg');

        switch (msg) {
          case "AppLifecycleState.paused":
            _lastLifecyleState = AppLifecycleState.paused;
            break;
          case "AppLifecycleState.inactive":
            _lastLifecyleState = AppLifecycleState.inactive;
            break;
          case "AppLifecycleState.resumed":
            _lastLifecyleState = AppLifecycleState.resumed;
            break;
          
          default:
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child : Scaffold(
        body: SafeArea(
          
          child : InAppWebView(
            initialUrl: youtubeUri + query + widget.title,
            initialHeaders: {},
            initialOptions: InAppWebViewWidgetOptions(
             
              crossPlatform: InAppWebViewOptions(
                
                debuggingEnabled: true,

              ),
              
            ),
         
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              setState(() {
                this.url = url;
              });
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              setState(() {
                this.url = url;
              });
            },
            onProgressChanged: (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            
          ),
        ),
      //   child: WebView(
      //     key: Key('webview'),
      //     initialUrl: youtubeUri + query + widget.title,
      //     javascriptMode: JavascriptMode.unrestricted,
      //     onWebViewCreated: (WebViewController webViewController) {
      //       _webViewController = webViewController;
      //     },
      //   ),
      //   bottom: true,
      //   left: true,
      //   right: true,
      //   top: true,
      // ),
      ),
    );
  }

  
}
