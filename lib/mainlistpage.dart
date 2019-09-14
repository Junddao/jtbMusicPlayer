
import 'package:firebase_admob/firebase_admob.dart';
import 'package:jtbMusicPlayer/youtubelistpage.dart';
import 'package:flutter/material.dart';


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
      
      home: new ListPage(title: 'JTB'),
      // home: DetailPage(),
    );
  }
}


class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String title;

  @override
  Widget build(BuildContext context) {
    

    final titles = ['공부할 때 듣기 좋은 음악', '잠잘 때 듣기 좋은 음악', '운전할 때 듣기 좋은 음악', '운동할 때 듣기 좋은 음악',
      '카페에서 듣기 좋은 음악', '쉴때 듣기 좋은 음악', '컬투쇼 베스트'];

      final icons = [Icons.edit , Icons.hotel,
      Icons.drive_eta, Icons.directions_bike , Icons.local_cafe, Icons.refresh,
      Icons.radio];

      return Scaffold(
        appBar: AppBar(
          title : Text('JTB Music Player'),
          centerTitle: true,
        ),
        body : ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card( //                           <-- Card widget
            child: ListTile(
              leading: Icon(icons[index]),
              title: Text(titles[index]),
              onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => YoutubeListPage( title: titles[index],)));
                },
              ),
            );
          },
        )
      );
      
  }
}
