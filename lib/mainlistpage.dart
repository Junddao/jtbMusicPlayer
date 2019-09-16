
import 'package:firebase_admob/firebase_admob.dart';
import 'package:jtbMusicPlayer/services/dbhelper.dart';
import 'package:jtbMusicPlayer/youtubelistpage.dart';
import 'package:flutter/material.dart';

import 'data/carditem.dart';
import 'data/listmodel.dart';


class ListMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    //admob init
    String appId = "ca-app-pub-9695790043722201~8654840320";
    FirebaseAdMob.instance.initialize(appId: appId);

    //banner 생성
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['game', 'overwatch'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[], // Android emulators are considered test devices
    );

    BannerAd myBanner = BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      // adUnitId: BannerAd.testAdUnitId,
      adUnitId: "ca-app-pub-9695790043722201/3765282201",
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

    myBanner
      // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        anchorOffset: 0.0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );


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

  final String title = '공부할 때 듣기 좋은 음악';

  ListModel<ListItem> _list;

  @override
  void initState() {
    super.initState();  

    ListItem listItem1 = new ListItem(); listItem1.id = 0; listItem1.title = "오버워치";
    ListItem listItem2 = new ListItem(); listItem2.id = 1; listItem2.title = "LOL";

    
    _list = ListModel<ListItem>(
      initialItems: <ListItem>[listItem1, listItem2]
    );

  }



  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // for (var i = 0; i < listModel.length; i++) {
      
    // }
    // listModel.insert(listModel.indexOf(item),item);
    return Scaffold(
      appBar: AppBar(
        title : Text('JTB Music Player'),
        centerTitle: true,
      ),
      body : FutureBuilder(
        future: DBHelper().getAllListItems(), 
        builder: (context, snapshot) { 
          return snapshot.hasData ?
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: new TextField(
                          controller: _textController,
                          //onSubmitted: _handleSubmitted,
                          decoration: new InputDecoration.collapsed(
                              hintText: "Type in here!"
                          ),
                        )
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: new IconButton(
                            icon : Icon(Icons.search),
                            onPressed: () => search(_textController.text)
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: new IconButton(
                            icon : Icon(Icons.add),
                            onPressed: () => addList(_textController.text)
                        ),
                      ),
                    ],
                  ),
                ),
                
                new Expanded(
                  child:  AnimatedList(
                    initialItemCount: _list.length,
                    itemBuilder: _buildItem,
                  ),
                ),
              ],
            )
            : Center( child: CircularProgressIndicator(), 
            );
        },
      ),
        
    );
  }

  void search(String value) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => YoutubeListPage( title: value,)));
    _textController.clear();
  }

  void addList(String value){
    if(value.isNotEmpty){
      ListItem newListItem = ListItem(id: _list.length, title: value);
      _list.insert(_list.length, newListItem);
      DBHelper().createData(newListItem);
      setState(() {});
    }
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return CardItem(item: _list[index]);
  }
}
