import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class JtbVideoPlayer extends StatefulWidget {

  final String url;
  const JtbVideoPlayer({Key key, this.url}) : super(key:key);
    
  @override
  _JtbVideoPlayerState createState() => _JtbVideoPlayerState();
}

class _JtbVideoPlayerState extends State<JtbVideoPlayer> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Play'),),
      body: FutureBuilder<List<YoutubePlayInfo>>(
        future: fetchYoutubePlayInfo(http.Client(), widget.url),
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
      // playerController = VideoPlayerController.network("https://r6---sn-oguesnzz.googlevideo.co;m/videoplayback?expire=1566724098&ei=ovthXcWIA6yMmLAPi9adIA&ip=185.27.134.50&id=o-AKT12Kvd_Yk5-k9yJa3MSOL5J2W8UWgu11ypS-XOHgsP&itag=22&source=youtube&requiressl=yes&pcm2=yes&mime=video%2Fmp4&ratebypass=yes&dur=812.257&lmt=1545030648975252&fvip=4&beids=9466588&txp=5432432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cpcm2%2Cmime%2Cratebypass%2Cdur%2Clmt&sig=ALgxI2wwRAIgfCiSmGbctxp2WgO48_XvHDKZR-mMkBkmRG9eY9i5gz8CIFb8tJKc94kadE7a3RHPWS5dtH9XyphGY0-5EEh4h75X&rm=sn-aigeek7d&fexp=9466588&req_id=df7b3e0a0e24a3ee&ipbypass=yes&redirect_counter=2&cm2rm=sn-n3cgv5qc5oq-bh2sz7d&cms_redirect=yes&mip=175.121.49.113&mm=30&mn=sn-oguesnzz&ms=nxu&mt=1566703948&mv=m&mvi=5&pl=13&lsparams=ipbypass,mip,mm,mn,ms,mv,mvi,pl&lsig=AHylml4wRQIhAPTHTJ2YctEmwFmvW1fa3REhD8XOKn7NaXw5mhO_LMghAiA_jqQmwKnmIuTcfO2s8F3b5nYJ9Q96jXOYt4plGkamqQ==")
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


// 서버로부터 데이터를 수신하여 그 결과를 List<Photo> 형태의 Future 객체로 반환하는 async 함수
Future<List<YoutubePlayInfo>> fetchYoutubePlayInfo(http.Client client, String url) async {
  // 해당 URL로 데이터를 요청하고 수신함
  final response =
      await client.get('http://youlink.epizy.com/?url=' + url);

  // parseYoutubePlayInfo 함수를 백그라운도 격리 처리
  return compute(parseYoutubePlayInfo, response.body);
}

// 수신한 데이터를 파싱하여 List<Photo> 형태로 반환
List<YoutubePlayInfo> parseYoutubePlayInfo(String responseBody) {
  // 수신 데이터를 JSON 포맷(JSON Array)으로 디코딩
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  // JSON Array를 List<Photo>로 변환하여 반환
  return parsed.map<YoutubePlayInfo>((json) => YoutubePlayInfo.fromJson(json)).toList();
}


class YoutubePlayInfo{
  final String type;
  final String url;
  final String mimeType;
  final String qualityLabel;
  final String quality;
  final int width;
  final int height;
  final int itag;

  YoutubePlayInfo({this.type, this.url, this.mimeType, this.qualityLabel, this.quality, this.width, this.height, this.itag});

  factory YoutubePlayInfo.fromJson(Map<String, dynamic> json){
    return YoutubePlayInfo(
      type: json['type'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      qualityLabel: json['qualityLabel'] as String,
      quality: json['quality'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      itag: json['itag'] as int,
    );
  }
}



