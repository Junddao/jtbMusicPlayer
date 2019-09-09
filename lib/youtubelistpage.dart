import 'package:flutter/material.dart';
import 'package:jtbMusicPlayer/data/youtube_api.dart';
import 'package:jtbMusicPlayer/youtubeplayder.dart';
// import 'package:jtbMusicPlayer/videoplayer.dart';

import 'package:provider/provider.dart';


class YoutubeListPage extends StatefulWidget {

  final String title;
  const YoutubeListPage({Key key, this.title}) : super(key:key);

    @override
  _YoutubeListPageState createState() => _YoutubeListPageState();
}

class _YoutubeListPageState extends State<YoutubeListPage> with ChangeNotifier {

  static String key = "AIzaSyAJqd4pfu0fx3-JSLlj7s27IubvsOl4liA";// ** ENTER YOUTUBE API KEY HERE **
  YoutubeAPI ytApi = new YoutubeAPI(key);
  List<YT_API> liYT = [];

  @override
  void initState() {
    super.initState();
    callAPI();
    print('hello');
  }

  callAPI() async {
    print('UI callled');
    String query = widget.title;
    liYT = await ytApi.search(query);
     Provider.of<YoutubeInfo>(context).liYoutubeInfo = liYT;
    setState(() {
      print('UI Updated');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body : ListView.builder(
        itemCount: Provider.of<YoutubeInfo>(context).liYoutubeInfo.length,
        itemBuilder: (_, int index) {
          return ListTile(
            title: listItem(index),
            onTap: (){
              _onItemTapped(index);
            },
          );
        }
      )
    );
  }

  Widget listItem(index){
    return Consumer<YoutubeInfo>(
      builder: (context, value, child) => 
      new Card(
        child: new Container(
          margin: EdgeInsets.symmetric(vertical: 7.0),
          padding: EdgeInsets.all(12.0),
          child:new Row(
            children: <Widget>[
            
              new Image.network(value.liYoutubeInfo[index].thumbnail['default']['url'],),
              new Padding(padding: EdgeInsets.only(right: 20.0)),
              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      value.liYoutubeInfo[index].title,
                      softWrap: true,
                      style: TextStyle(fontSize:18.0),
                    ),
                    new Padding(padding: EdgeInsets.only(bottom: 1.5)),
                    new Text(
                      value.liYoutubeInfo[index].channelTitle,
                      softWrap: true,
                    ),
                    new Padding(padding: EdgeInsets.only(bottom: 3.0)),
                    new Text(
                      value.liYoutubeInfo[index].url,
                      softWrap: true,
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index)
  {
    String _url = Provider.of<YoutubeInfo>(context).liYoutubeInfo[index].url.replaceAll(" ", "");
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyYoutubePlayer( url: _url,)));
    // Navigator.push(context, MaterialPageRoute(builder: (context) => JtbVideoPlayer( url: _url,)));
    // Navigator.push(context, MaterialPageRoute(builder: (context) => JtbPlayer( url: _url,)));
  }
}