
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';


// import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {

  final String title;
  const WebPage({Key key, this.title}) : super(key: key);
    

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  
  String youtubeUri = 'https://youtube.com/';
  String query = 'results?search_query=';
  // WebViewController _webViewController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        
        child : InAppWebView(
          initialUrl: youtubeUri + query + widget.title,
          initialHeaders: {},
          initialOptions: InAppWebViewWidgetOptions(
            inAppWebViewOptions: InAppWebViewOptions(
                debuggingEnabled: true,
            )
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
    );
  }

  
}

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(String url) async {
    print("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(String url) async {
    print("\n\nStopped $url\n\n");
  }

  @override
  void onLoadError(String url, int code, String message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(int progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }

  @override
  void shouldOverrideUrlLoading(String url) {
    print("\n\n override $url\n\n");
    this.webViewController.loadUrl(url: url);
  }

  @override
  void onLoadResource(LoadedResource response) {
    print("Started at: " +
        response.startTime.toString() +
        "ms ---> duration: " +
        response.duration.toString() +
        "ms " +
        response.url);
  }

  @override
  void onConsoleMessage(ConsoleMessage consoleMessage) {
    print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
  }
}