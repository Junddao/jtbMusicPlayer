import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:jtbMusicPlayer/services/dbhelper.dart';
import 'package:jtbMusicPlayer/web_page.dart';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'data/listmodel.dart';
// import 'services/myadshelper.dart';



const languages = const [
  
  const Language('English', 'en_US'),
  
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class ListMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
      title: 'Flutter Demo',
      
      home: new ListPage(),
      // home: DetailPage(),
    );
  }
}


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  //ListModel<int> _list;

  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();

  // SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool _isMicPushed = false;

  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;
  String name;
  int curUserId;

  bool hasAds = false;
  
  
  
  Future<List<ListItem>> listItems;
  TextEditingController controller = TextEditingController();
  var dbHelper;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();  
    initSpeechState();

    dbHelper = DBHelper();
    refreshList();
    Future.delayed(Duration(seconds: 5));
    listItems.then((data){
      if(data.isEmpty) {
        ListItem listItem1 = ListItem(null, '뽀로로');
        dbHelper.save(listItem1);
        ListItem listItem2 = ListItem(null, '타요');
        dbHelper.save(listItem2);
        ListItem listItem3 = ListItem(null, '코코몽');
        dbHelper.save(listItem3);
        ListItem listItem4 = ListItem(null, '컬투쇼 레전드');
        dbHelper.save(listItem4);
        ListItem listItem5 = ListItem(null, '2000년 발라드');
        dbHelper.save(listItem5);
        refreshList();
      }
    });
  }



  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(onError: errorListener, onStatus: statusListener );

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  refreshList() {
    setState(() {
      listItems = dbHelper.getListItem();
    });
  }

  clearName() {
    controller.text = '';
  }



  @override
  Widget build(BuildContext context) { 
    
    return Scaffold(
      appBar: AppBar(
        title : Text('JTB Player'),
        centerTitle: true,
      ),
      body : new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(), 
            voiceButton(),
            showBanner(),
            // Padding( padding: new EdgeInsets.only(bottom: 50.0, ),),
          ],
        ),
      ),
      
    );
  }

  form() {
    return Form(
      key: formKey,
      child : Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: new TextFormField(
                controller: controller,
                //validator: (val) => val.length == 0 ? 'Enter title' : null,
                onSaved: (val) => name = val,
                //onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                    hintText: "Type in here!"
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon : Icon(Icons.search),
                  onPressed: () => search(controller.text)
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon : Icon(Icons.add),
                  onPressed: validate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  showBanner(){
    return AdmobBanner(
      adUnitId: "ca-app-pub-9695790043722201/3765282201",
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args){
        if(event == AdmobAdEvent.clicked){

        }
      },
    );
  }

  // AnimatedList dataList(List<ListItem> listItems){
  //   return AnimatedList(
  //     initialItemCount: 5,
  //     itemBuilder: _buildItem,
              
            
  //   );
  // }

  // Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
  //     return CardItem(item: index,)
  // }

  SingleChildScrollView dataList(List<ListItem> listItems){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      
      child:  DataTable(
        horizontalMargin : 0,
        sortAscending: true,
        columns: [
          DataColumn(
            label: Text('제목'),
            //numeric: true,
          ),
          
          DataColumn(
            label: Text('삭제'),
            //numeric: true,
          )
        ],
        rows: listItems.map(
          (listItem) => 
          DataRow(
            cells: [
              DataCell(
                Text(listItem.title),
                
                onTap: () {
                  setState(() {
                    search(listItem.title);
                  });
                },
              ),
            
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  dbHelper.delete(listItem.id);
                  refreshList();
                },
              )
            ),
          ]),
        )
        .toList(),
      ),
      
    );
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
  
      ListItem listItem = ListItem(null, name);
      dbHelper.save(listItem);
      
      clearName();
      refreshList();
    }
  }


  list() {
    return Expanded(
      child: FutureBuilder(
        future: listItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataList(snapshot.data);
          }
  
          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }
  
          return CircularProgressIndicator();
        },
      ),
    );
  }

  
  // voiceButton(){
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       FlatButton(
  //         child: Text('Start'),
  //         onPressed: startListening,
  //       ),
  //       FlatButton(
  //         child: Text('Stop'),
  //         onPressed: stopListening,
  //       ),
  //       FlatButton(
  //         child: Text('Cancel'),
  //         onPressed:cancelListening,
  //       ),
  //     ],
  //   );
  // }

  voiceButton(){
    return Expanded(
      child : _buildButton(
        onPressed: speech.isListening
        ? () => stopListening
        : startListening,
      ),
    );
  }

  
  void startListening() {
    _isMicPushed = true;
    lastWords = "";
    lastError = "";
    speech.listen(onResult: resultListener );
    setState(() {
      
    });
  }
  
  void stopListening() {
    _isMicPushed = false;
    speech.stop( );
    setState(() {
      
    });
  }

  void cancelListening() {
    speech.cancel( );
    setState(() {
      
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      // lastWords = "${result.recognizedWords} - ${result.finalResult}";
      controller.text = "${result.recognizedWords}";
    });
  }

  void errorListener(SpeechRecognitionError error ) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }
  void statusListener(String status ) {
    setState(() {
      lastStatus = "$status";
    });
  }


  // voiceButton(){
  //   return Expanded(
  //     child : _buildButton(
  //       onPressed: _speechRecognitionAvailable && !_isListening 
  //       ? () => start() 
  //       : null,
  //     ),
  //   );
  // }

 

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
      padding: new EdgeInsets.all(12.0),
      child: new FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.mic),
        backgroundColor: speech.isListening ? Colors.red[300] : Colors.blue[300],
      ),
    );

  void search(String value) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WebPage( title: value,)));
    controller.clear();
  }


// void activateSpeechRecognizer() {
//     print('_MyAppState.activateSpeechRecognizer... ');
//     _speech = new SpeechRecognition();
//     _speech.setAvailabilityHandler(onSpeechAvailability);
//     _speech.setCurrentLocaleHandler(onCurrentLocale);
//     _speech.setRecognitionStartedHandler(onRecognitionStarted);
//     _speech.setRecognitionResultHandler(onRecognitionResult);
//     _speech.setRecognitionCompleteHandler(onRecognitionComplete);
//     _speech
//         .activate()
//         .then((res) => setState(() => _speechRecognitionAvailable = res));
//   }



//   Future<void> start() {
//     _isMicPushed = true;
//     return _speech
//       .listen(locale: "en_US")
//       .then((result) => print('_MyAppState.start => result $result'));
//   }

//   void cancel() =>
//       _speech.cancel().then((result) => setState(() => _isListening = result));

//   void stop() => _speech.stop().then((result) {
//         setState(() => _isListening = result);
//       });

//   void onSpeechAvailability(bool result) =>
//       setState(() => _speechRecognitionAvailable = result);

//   void onCurrentLocale(String locale) {
//     print('_MyAppState.onCurrentLocale... $locale');
//     setState(
//         () => selectedLang = languages.firstWhere((l) => l.code == locale));
//   }

//   void onRecognitionStarted() {
   
//     return setState(() => _isListening = true);
//   } 

//   void onRecognitionResult(String text) => setState(() => controller.text = text);

//   void onRecognitionComplete(){
//     _isMicPushed = false;
//     return setState(() => _isListening = false);
//   } 

//   void errorHandler() => activateSpeechRecognizer();

  
}
