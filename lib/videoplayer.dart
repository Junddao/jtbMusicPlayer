import 'package:flutter/material.dart';
import 'package:jtbMusicPlayer/data/youtube_api.dart';
import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
import 'package:youtube_player/youtube_player.dart';


class JtbVideoPlayer extends StatefulWidget {

final String url;

const JtbVideoPlayer({Key key, this.url}) : super(key:key);

  
@override
  _JtbVideoPlayerState createState() => _JtbVideoPlayerState();
}

class _JtbVideoPlayerState extends State<JtbVideoPlayer> {


  VideoPlayerController playerController;
  VoidCallback listener;


  @override
  void initState() {
    super.initState();
    listener= (){
      setState(() {});
    };
  }  

  void createVideo(){
    if(playerController == null){
      String videoId = widget.url;
      String _selectedQuality = qualityMapping(YoutubeQuality.LOW);


      playerController = VideoPlayerController.network(getIdFromUrl("${videoId}sarbagya${_selectedQuality}sarbagya${true}"))
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
          createVideo();
          playerController.play();
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  
  String getIdFromUrl(String url, [bool trimWhitespaces = true]) {
    if (url == null || url.length == 0) return null;

    if (trimWhitespaces) url = url.trim();

    for (var exp in _regexps) {
      Match match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  List<RegExp> _regexps = [
    new RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    new RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    new RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ];

  
  String qualityMapping(YoutubeQuality quality) {
    switch (quality) {
      case YoutubeQuality.LOWEST:
        return '144p';
      case YoutubeQuality.LOW:
        return '240p';
      case YoutubeQuality.MEDIUM:
        return '360p';
      case YoutubeQuality.HIGH:
        return '480p';
      case YoutubeQuality.HD:
        return '720p';
      case YoutubeQuality.FHD:
        return '1080p';
      default:
        return "Invalid Quality";
    }
  }
}
