import 'package:flutter/cupertino.dart';
import 'package:jtbMusicPlayer/data/carditem.dart';
import 'package:jtbMusicPlayer/services/dbhelper.dart';
import 'package:jtbMusicPlayer/youtubelistpage.dart';
import 'package:flutter/material.dart';
import 'data/listmodel.dart';
import 'services/myadshelper.dart';


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

  String name;
  int curUserId;
  
  Future<List<ListItem>> listItems;
  TextEditingController controller = TextEditingController();
  var dbHelper;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();  
    dbHelper = DBHelper();
    refreshList();
    Future.delayed(Duration(seconds: 5));
    listItems.then((data){
      if(data.isEmpty) {
        ListItem listItem1 = ListItem(null, '오버워치');
        dbHelper.save(listItem1);
        ListItem listItem2 = ListItem(null, '잇섭');
        dbHelper.save(listItem2);
        ListItem listItem3 = ListItem(null, '워크맨');
        dbHelper.save(listItem3);
        ListItem listItem4 = ListItem(null, '컬투쇼 레전드');
        dbHelper.save(listItem4);
        refreshList();
      }
    });
    Ads.showBannerAd();

    //_list = ListModel<int>(initialItems: <int>[]);


    // //admob init
    // String appId = "ca-app-pub-9695790043722201~8654840320";
    // FirebaseAdMob.instance.initialize(appId: appId);
    
    // myBanner
    //   // typically this happens well before the ad is shown
    //   ..load().then((loaded) {
    //     if(loaded && this.mounted) {
    //       myBanner..show(
    //         // Positions the banner ad 60 pixels from the bottom of the screen
    //         anchorOffset: 0.0,
    //         // Banner Position
    //         anchorType: AnchorType.bottom,
    //       );
    //     }
    //   });
  }


  @override
  void dispose()
  {
    super.dispose();
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
        title : Text('jtbPlayer'),
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
                validator: (val) => val.length == 0 ? 'Enter title' : null,
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
      child: DataTable(
        horizontalMargin : 0,
        columns: [
          DataColumn(
            label: Text('TITLE'),
          ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: listItems.map(
          (listItem) => DataRow(cells: [
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
            )),
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

  void search(String value) {
    
    Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeListPage( title: value,)));
    controller.clear();
  }
}

// //banner 생성
// MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//   keywords: <String>['game', 'overwatch'],
//   contentUrl: 'https://flutter.io',
//   childDirected: false,
//   testDevices: <String>[], // Android emulators are considered test devices
// );

// BannerAd myBanner = BannerAd(
//   // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//   // https://developers.google.com/admob/android/test-ads
//   // https://developers.google.com/admob/ios/test-ads
//   // adUnitId: BannerAd.testAdUnitId,
//   adUnitId: "ca-app-pub-9695790043722201/3765282201",
//   size: AdSize.smartBanner,
//   targetingInfo: targetingInfo,
//   listener: (MobileAdEvent event) {
//     print("BannerAd event is $event");
//   },
// );
