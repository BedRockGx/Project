import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:project/config/api_url.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:flutter/material.dart';


class VideoApp extends StatefulWidget {
  var arguments;
  VideoApp(this.arguments);
  @override
  _VideoAppState createState() => _VideoAppState(this.arguments);
}

class _VideoAppState extends State<VideoApp> {
  var arguments;
  _VideoAppState(this.arguments);

  // // var aspet = 16/9;
  // VideoPlayerController _videoPlayerController;
  // ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    print('传进来的url：${arguments['message']}');
    _initVideo();
  }

   @override
    void dispose() async {
      // 停止
    // 这里要说明,ijkplayer的stop会释放资源,导致play不能使用,需要重新准备资源,所以这里其实采用的是回到进度条开始,并暂停
    await controller.stop();
    controller.dispose();
    super.dispose();
    }
  
  _initVideo() async {
    if(arguments['isMe']){
      await controller.setNetworkDataSource(
        arguments['message'],
        autoPlay: true
      );
    }else{
      await controller.setNetworkDataSource(
        '$base_url${arguments['message']}',
        autoPlay: true
      );
    }
  }


  IjkMediaController controller = IjkMediaController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        leading: IconButton(
          icon: // Icon(IconData(0xe622, fontFamily: 'myIcon'),
                Icon(Icons.clear, color: Colors.white, size: ScreenAdapter.size(40),),
                onPressed: ()=>Navigator.pop(context),
                ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // padding: EdgeInsets.all(0),
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      child: IjkPlayer(
                        mediaController: controller,
                      ),
                    )
                  ]
                ),
              ),
      ),
    );
    
   
  }

  

}