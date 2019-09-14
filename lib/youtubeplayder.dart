import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player/youtube_player.dart';


class MyYoutubePlayer extends StatefulWidget {

  final String url;

  const MyYoutubePlayer({Key key, this.url}) : super(key: key);

  @override
  _MyYoutubePlayerState createState() => _MyYoutubePlayerState();
}

class _MyYoutubePlayerState extends State<MyYoutubePlayer> {

  static const platform = const MethodChannel("np.com.sarbagyastha.example");
  double _volume = 1.0;
  VideoPlayerController _videoController;
  String position = "Get Current Position";
  String status = "Get Player Status";
  String videoDuration = "Get Video Duration";
  bool isMute = false;

  @override
  void initState() {
    // getSharedVideoUrl();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      appBar: AppBar(
        title : Text('JTB Music Player'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            YoutubePlayer(
              context: context,
              source:  widget.url,
              quality: YoutubeQuality.LOWEST,
              aspectRatio: 16 / 9,
              autoPlay: true,
              loop: false,
              reactToOrientationChange: true,
              startFullScreen: false,
              controlsActiveBackgroundOverlay: true,
              controlsTimeOut: Duration(seconds: 4),
              playerMode: YoutubePlayerMode.DEFAULT,
              callbackController: (controller) {
                _videoController = controller;
              },
              onError: (error) {
                print(error);
              },

            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  
                  Row(
                    children: <Widget>[
                      Icon(Icons.volume_up),
                      Expanded(
                        child: Slider(
                          inactiveColor: Colors.transparent,
                          value: _volume,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: '${(_volume * 10).round()}',
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                            });
                            _videoController.setVolume(_volume);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}