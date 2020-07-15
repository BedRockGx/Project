// import 'package:video_player/video_player.dart';
// import 'package:flutter/material.dart';

// class VideoTest extends StatefulWidget {
//   @override
//   _VideoTestState createState() => _VideoTestState();
// }

// class _VideoTestState extends State<VideoTest> {
//   VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _initVideo();
//     _controller..addListener((){
//       print('视频大小：${_controller.value.duration}');
//       print('输出视频详情秒：');
//       print(_controller.value.position.inMilliseconds);
//         // print(_controller.value.position.inSeconds);
      
//     });
//   }

//    @override
//   void dispose() {
//     super.dispose();
//     _controller.pause();
//     _controller.dispose();
//   }

//   Future _initVideo() async {
//     _controller = VideoPlayerController.network(
//         // 'http://flutter.ikuer.cn/uploads/2020-03-13/5e6afbff61374.mp4'
//         'http://flutter.ikuer.cn/uploads/2020-03-13/5e6afc1f0e7eb.mp4'
//         )..initialize().then((_) {
//           print('视频加载完毕~！！！');
//           setState(() {
            
//           });
//       });
    
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ListView(
//           children: <Widget>[
//             Center(
//               child: _controller.value.initialized
//                   ? AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     )
//                   : CircularProgressIndicator()
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _controller.value.isPlaying
//                   ? _controller.pause()
//                   : _controller.play();
//             });
//           },
//           child: Icon(
//             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//           ),
//         ),
//       );
//   }

 
// }