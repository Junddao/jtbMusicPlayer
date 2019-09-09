import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// class JtbVideoPlayer extends StatefulWidget {

//   final String url;
//   const JtbVideoPlayer({Key key, this.url}) : super(key:key);
    
//   @override
//   _JtbVideoPlayerState createState() => _JtbVideoPlayerState();
// }

// class _JtbVideoPlayerState extends State<JtbVideoPlayer> {



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Play'),),
//       body: FutureBuilder<List<YoutubePlayInfo>>(
//         future: fetchYoutubePlayInfo(http.Client(), widget.url),
//         builder: (context, snapshot){
//           if(snapshot.hasError) print (snapshot.error);
//           return snapshot.hasData ? PlayScreen(liPlayInfo: snapshot.data,) : Center(child: CircularProgressIndicator()); 
//         },
//       )
//     );
//   }
// }

class JtbPlayer extends StatelessWidget {


  final String url;
  const JtbPlayer({Key key, this.url}) : super(key:key);
    
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: Text('Play'),),
      body: FutureBuilder<List<YoutubePlayInfo>>(
        future: fetchYoutubePlayInfo(http.Client(), url),
        builder: (context, snapshot){
          if(snapshot.hasError) print (snapshot.error);
          return snapshot.hasData ? PlayScreen(liPlayInfo: snapshot.data,) : Center(child: CircularProgressIndicator()); 
        },
      )
    );
  }
}

class PlayScreen extends StatefulWidget {

  final List<YoutubePlayInfo> liPlayInfo;
  PlayScreen({Key key, this.liPlayInfo}) : super (key:key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {

  VideoPlayerController playerController;
  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener= (){
      setState(() {});
    };
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                child: (playerController != null
                    ? VideoPlayer(
                        playerController,
                      )
                    : Container()),
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createVideo(widget.liPlayInfo[0].url);
          playerController.play();
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  
  void createVideo(String _url){
    if(playerController == null){
      if(_url.contains("&=WEB")) _url = _url.replaceAll("&c=WEB", "");
      if(_url.contains("&=web")) _url = _url.replaceAll("&c=web", "");
      // playerController = VideoPlayerController.network())
      playerController = VideoPlayerController.network(_url)
      ..addListener(listener)
      ..setVolume(1.0)
      ..initialize()
      ..play();
    }
    else{
      if(playerController.value.isPlaying){
        playerController.pause();
      }
      else{
        playerController.initialize();
        playerController.play();
      }
    }

  }


  @override
  void deactivate() {
    playerController.setVolume(0.0);
    playerController.removeListener(listener);
    super.deactivate();
  }
}


enum YoutubeQuality {
  /// = 144p
  LOWEST,

  /// = 240p
  LOW,

  /// = 360p
  MEDIUM,

  /// = 480p
  HIGH,

  /// = 720p
  HD,

  /// = 1080p
  FHD,
}


// 서버로부터 데이터를 수신하여 그 결과를 List<YoutubePlayInfo> 형태의 Future 객체로 반환하는 async 함수
Future<List<YoutubePlayInfo>> fetchYoutubePlayInfo(http.Client client, String url) async {
  // 해당 URL로 데이터를 요청하고 수신함
  String _url = 'http://y2hunter.synology.me/index.php?url=' + "https://www.youtube.com/watch?v=YGCLs9Bt_KY";
  //String _url = 'https://jsonplaceholder.typicode.com/photos';
  final response =
      await client.get(_url);

  // parseYoutubePlayInfo 함수를 백그라운도 격리 처리
  return compute(parseYoutubePlayInfo, response.body);
}

// 수신한 데이터를 파싱하여 List<YoutubePlayInfo> 형태로 반환
List<YoutubePlayInfo> parseYoutubePlayInfo(String responseBody) {
  // 수신 데이터를 JSON 포맷(JSON Array)으로 디코딩
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  // JSON Array를 List<YoutubePlayInfo>로 변환하여 반환
  return parsed.map<YoutubePlayInfo>((json) => YoutubePlayInfo.fromJson(json)).toList();
}




class YoutubePlayInfo{
  final String type;
  final String url;
  final String mimeType;
  final String width;
  final String height;
  final String qualityLabel;
  final String itag;
  final String quality;
  

  YoutubePlayInfo({this.type, this.url, this.mimeType, this.width, this.height, this.qualityLabel, this.itag, this.quality});

  factory YoutubePlayInfo.fromJson(Map<String, dynamic> json){
    return YoutubePlayInfo(
      type: json['type'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
      qualityLabel: json['qualityLabel'] as String,
      itag: json['itag'] as String,
      quality: json['quality'] as String,
    );
  }
}



