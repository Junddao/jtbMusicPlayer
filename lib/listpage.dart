import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  static String key = "AIzaSyAJqd4pfu0fx3-JSLlj7s27IubvsOl4liA";// ** ENTER YOUTUBE API KEY HERE **
  YoutubeAPI ytApi = new YoutubeAPI(key);
  List<YT_API> ytResult = [];

  @override
  void initState() {
    super.initState();
    callAPI();
    print('hello');
  }

  callAPI() async {
    print('UI callled');
    String query = "2000년 가요";
    ytResult = await ytApi.search(query);
    setState(() {
      print('UI Updated');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child : ListView.builder(
        itemCount: ytResult.length,
        itemBuilder: (_, int index) => listItem(index)
      )
    );
  }

  Widget listItem(index){
    return new Card(
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child:new Row(
          children: <Widget>[
            new Image.network(ytResult[index].thumbnail['default']['url'],),
            new Padding(padding: EdgeInsets.only(right: 20.0)),
            new Expanded(child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  ytResult[index].title,
                  softWrap: true,
                  style: TextStyle(fontSize:18.0),
                ),
                new Padding(padding: EdgeInsets.only(bottom: 1.5)),
                new Text(
                  ytResult[index].channelTitle,
                  softWrap: true,
                ),
                new Padding(padding: EdgeInsets.only(bottom: 3.0)),
                new Text(
                  ytResult[index].url,
                  softWrap: true,
                ),
              ]
            ))
          ],
        ),
      ),
    );
  }
}