import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:provide/provide.dart';
import 'package:project/provide/SocketProvide.dart';
import 'weChatRecoding.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';

/// 聊天界面
class ServiceChatPage extends StatefulWidget {
  final arguments;
  ServiceChatPage(this.arguments);
  @override
  ChatPageState createState() {
    return ChatPageState(this.arguments);
  }
}

class ChatPageState extends State<ServiceChatPage> {
  final arguments;
  ChatPageState(this.arguments);
  var base_url = 'https://flutter.ikuer.cn'; 
  var api = new Api();
  var userInfo;
  bool showSend = false;      // 是否显示发送
  bool soundRecording = false;      // 是否显示语音按钮
  double _height = 0;
  var gl_socket;
  var localImage, localVideo;
  var audioPath;
  var page = 1;
  var firstBol = false;
  var duration = Duration(milliseconds: 200);
  

  // 输入框
  TextEditingController _textEditingController;
  // 滚动控制器
  ScrollController _scrollController;
  FlutterPluginRecord recordPlugin;

  // ClientSocket socket;

  @override
  void initState() {
    super.initState();
    _setUserData();

    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    recordPlugin =  FlutterPluginRecord();
    _getHistoryChat();
    
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    recordPlugin.dispose();
    super.dispose();
  }

  // 获取用户数据
   _setUserData(){
    api.getData(context, 'userInfo').then((val){
      if(val == null){
        return;
      }
      var response = json.decode(val.toString());
      print('--------------获取服务器用户数据----------------');
      print(response);
      setState(() {
        userInfo = response;
      });
      PublicStorage.setHistoryList('UserInfo', response);
    }); 
  }

  // 发送消息
  void _sendMsg(String msg) {
    setState(() {
      showSend = false;
      Provide.value<SocketProvider>(context).setServiceRecords(msg,'text', true);
    });
    _scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.linear);
    // socket.sendMessage({'message':msg});
  }

  startRecord(){
    print("111开始录制");
  }

  stopRecord(String path,double audioTimeLength ) async {
    print("结束束录制");
    print("音频文件位置"+path);
    print("音频录制时长"+audioTimeLength.toString());
    setState(() {
      this.audioPath = path;
    });
    
    api.postData(context, 'uploadFile', formData: await FormData1(path)).then((data){
      var audiourl = json.decode(data.toString())['file_path'];
      Map contentArguments = {
        'type':'private_chat',
        'content_type':'audio',
        'content':audiourl,
        'time_length':audioTimeLength.toString(),
        'recv_id':arguments['recv_id']
      };
      print('消息上传成功了！！！!!!!!!!!!!!!!!!!!!!!!!!!！');
      print(contentArguments);
      // socket发送消息
      gl_socket.write(json.encode(contentArguments));
      Provide.value<SocketProvider>(context).setServiceRecords(path,'audio', true, time_length:audioTimeLength.toString());

    });
  
  }

  _getHistoryChat() async {
    var formData = {
      'page':page++,
      'pageSize':8,
      'time':Plugins.stampTime(DateTime.now()),
      'user_id':arguments['recv_id'],
    };
    print('传入的参数：$formData');
    
    api.getData(context, 'history_message',formData: formData).then((val){
      if(val.toString() == '[]'){
        // Fluttertoast.showToast(msg: '已是最新聊天数据~');
        return;
      }
      // 避免历史记录和新来的消息冲突，首先清空一遍数据，再赋值
      if(!firstBol){
        Provide.value<SocketProvider>(context).clearRecords();
        setState(() {
          firstBol = true;
        });
      }
      var response = json.decode(val.toString());
      // print(response);

      for(var item in response){
        // print(item['is_me']);
        if(item['is_me'] == 1){
          chatHistory(json.decode(item['content'].toString()), context, true);
        }else{
          chatHistory(json.decode(item['content'].toString()), context, false);
        }
      }
    }
  );
  }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40),), onPressed: ()=>Navigator.pop(context),),
          title: Container(
            child:  Text('${arguments['nickname']}', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
          ),
        centerTitle: true,
        // backgroundColor: Colors.grey[200],
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey[200],
      body: Provide<SocketProvider>(
        builder: (context, child, val){
          return Container(
            color: Colors.white,
            child:  Column(
                  children: <Widget>[
                    Divider(
                      height: 0.5,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        child: EasyRefresh.custom(
                        scrollController: _scrollController,
                        reverse: true,
                        footer: CustomFooter(
                            enableInfiniteLoad: false,
                            extent: 40.0,
                            triggerDistance: 50.0,
                            footerBuilder: (context,
                                loadState,
                                pulledExtent,
                                loadTriggerPullDistance,
                                loadIndicatorExtent,
                                axisDirection,
                                float,
                                completeDuration,
                                enableInfiniteLoad,
                                success,
                                noMore) {
                              return Stack(
                                children: <Widget>[
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      child: SpinKitCircle(
                                        color: Colors.green,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _buildMsg(val.servicerecords[index]);
                              },
                              childCount: val.servicerecords.length,
                            ),
                          ),
                        ],
                        onLoad: () async {
                            _getHistoryChat();
                            return;
                        },
                      ),
                      onTap: (){
                        setState(() {
                          _height = 0;
                        });
                      },
                      )
                    ),
                    
                    SafeArea(
                      child: Container(
                        color: Colors.grey[100],
                        padding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 8.0,
                          bottom: 8.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            // InkWell(
                            //   child: Container(
                            //     margin: EdgeInsets.only(right: ScreenAdapter.setWidth(10)),
                            //       decoration: BoxDecoration(
                            //         // color: Colors.grey,
                            //         borderRadius: BorderRadius.circular(50),
                            //         // border: Border.all(width: ScreenAdapter.setWidth(0.5), color: Colors.grey)
                            //       ),
                            //       child: Icon(Icons.keyboard_voice, color: Colors.grey,),
                            //     ),
                            //   onTap: (){
                            //     print('点击录音');
                            //     setState(() {
                            //       this._height = 0;
                            //       this.gl_socket = val.socket;
                            //       this.soundRecording = !this.soundRecording;
                            //     });
                            //   },
                            // ),
                            // soundRecording ?
                            // Expanded(
                            //   flex: 1,
                            //   child: VoiceWidget(startRecord: startRecord,stopRecord: stopRecord),
                            // )
                            // :
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 5.0,
                                  right: 5.0,
                                  top: 5.0,
                                  bottom: 5.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(
                                  20,
                                  )),
                                ),
                                child: TextField(
                                  controller: _textEditingController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      top: 2.0,
                                      bottom: 2.0,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (val){
                                    print(val);
                                    if(val.isNotEmpty){
                                      setState(() {
                                        showSend = true;
                                      });
                                    }else{
                                      setState(() {
                                        showSend = false;
                                      });
                                    }
                                  },
                                  onSubmitted: (value) {
                                    if (_textEditingController.text.isNotEmpty) {
                                      _sendMsg(_textEditingController.text);
                                      _textEditingController.text = '';
                                    }
                                  },
                                  onTap: (){
                                    setState(() {
                                      _height = 0;
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            // !showSend ?
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(15)),
                                decoration: BoxDecoration(
                                  // color: Colors.grey,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(width: ScreenAdapter.setWidth(0.5), color: Colors.grey)
                                ),
                                child: Icon(Icons.add, color: Colors.grey,),
                              ),
                              onTap: (){
                                // 收起键盘
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  this.soundRecording = false;
                                  _height = 100;
                                });
                              },
                            ),
                            // :
                            InkWell(
                              onTap: () {
                                if(_textEditingController.text.isEmpty){
                                  return;
                                }
                                Map contentArguments = {
                                  'type':'private_chat',
                                  'content_type':'text',
                                  'content':_textEditingController.text,
                                  'recv_id':arguments['recv_id']
                                };
                                print(contentArguments);
                                if (_textEditingController.text.isNotEmpty) {
                                  _sendMsg(_textEditingController.text);
                                  _textEditingController.text = '';
                                }
                                // socket发送消息
                                val.socket.write(json.encode(contentArguments));
                              },
                              child: Container(
                                height: 30.0,
                                width: 60.0,
                                alignment: Alignment.center,
                                // margin: EdgeInsets.only(
                                //   left: ScreenAdapter.setWidth(10),
                                // ),
                                decoration: BoxDecoration(
                                  // color: _textEditingController.text.isEmpty
                                  //     ? Colors.grey
                                  //     : Colors.green,
                                  color: Color(0xff4ADDFE),
                                  borderRadius: BorderRadius.all(Radius.circular(
                                   20,
                                  )),
                                ),
                                child: Text(
                                  '发送',
                                  // S.of(context).send,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: duration,
                      height: _height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Container(
                        child: GridView(
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 120.0,
                              childAspectRatio: 1.0 //宽高比为2
                          ),
                          children: <Widget>[
                           IconButton(
                             icon: Icon(Icons.camera_alt),
                             onPressed: () async {
                               var img_url = await Plugins.takePhoto();
                               if(img_url!=null){
                                setState(() {
                                  localImage = img_url;
                                });
                                api.postData(context, 'uploadFile', formData: await FormData1(img_url.path)).then((data){
                                  var imgurl = json.decode(data.toString())['file_path'];
                                  Map contentArguments = {
                                    'type':'private_chat',
                                    'content_type':'img',
                                    'content':imgurl,
                                    'recv_id':arguments['recv_id']
                                  };
                                  print(contentArguments);
                                  Provide.value<SocketProvider>(context).setServiceRecords(localImage,'img', true);
                                  // socket发送消息
                                  val.socket.write(json.encode(contentArguments));
                                });
                              }
                             },
                           ),
                           IconButton(
                             icon: Icon(Icons.photo),
                             onPressed: () async {
                               print('---------------------选择图片---------------------');
                               var img_url = await Plugins.openGallery();
                               if(img_url!=null){
                                setState(() {
                                  localImage = img_url;
                                });
                                print(localImage);
                                api.postData(context, 'uploadFile', formData: await FormData1(img_url.path)).then((data){
                                  var imgurl = json.decode(data.toString())['file_path'];
                                  print('路径');
                                  print(imgurl);
                                  Map contentArguments = {
                                    'type':'private_chat',
                                    'content_type':'img',
                                    'content':imgurl,
                                    'recv_id':arguments['recv_id']
                                  };
                                  print(json.encode(contentArguments));
                                  Provide.value<SocketProvider>(context).setServiceRecords(localImage,'img', true);
                                  // // socket发送消息
                                  val.socket.write(json.encode(contentArguments));
                                });
                              }
                             },
                           ),

                          //  IconButton(
                          //    icon: Icon(Icons.videocam),
                          //    onPressed: () async {
                          //      print('录像');
                          //      var video_url = await Plugins.takeVideo();
                          //      if(video_url!=null){
                          //       setState(() {
                          //         localVideo = video_url;
                          //       });
                          //       api.postData(context, 'uploadFile', formData: await FormData1(video_url.path)).then((data){
                          //         var videourl = json.decode(data.toString())['file_path'];
                          //         Map contentArguments = {
                          //           'type':'private_chat',
                          //           'content_type':'video',
                          //           'content':videourl,
                          //           'recv_id':arguments['recv_id']
                          //         };
                          //         print(contentArguments);
                          //         Provide.value<SocketProvider>(context).setServiceRecords(localVideo.path,'video', true);
                          //         // socket发送消息
                          //         val.socket.write(json.encode(contentArguments));
                          //       });
                          //     }
                          //    },
                          //  ),
                          //  IconButton(
                          //    icon: Icon(Icons.movie),
                          //    onPressed: () async {
                          //      print('发送视频');
                          //      var video_url = await Plugins.getVideo();
                          //     //  print(video_url);
                          //      if(video_url!=null){
                          //       setState(() {
                          //         localVideo = video_url;
                          //       });
                                
                          //       api.postData(context, 'uploadFile', formData: await FormData1(video_url.path)).then((data){
                          //         var videourl = json.decode(data.toString())['file_path'];
                          //         Map contentArguments = {
                          //           'type':'private_chat',
                          //           'content_type':'video',
                          //           'content':videourl,
                          //           'recv_id':arguments['recv_id']
                          //         };
                          //         print(contentArguments);
                          //         Provide.value<SocketProvider>(context).setServiceRecords(localVideo.path,'video', true);
                          //         // socket发送消息
                          //         val.socket.write(json.encode(contentArguments));
                          //       });
                          //     }
                          //    },
                          //  ),
                          
                          ],
                        )
                      )
                    ),
                  ],
                )
       ,
          );
         
        },
      )
    );
  }

  // 构建消息视图
  Widget _buildMsg(ServiceChatRecord entity) {
    if (entity == null || entity.newIsMe == null || userInfo == null) {
      return Container();
    }
    if (entity.newIsMe) {
      return Container(
        margin: EdgeInsets.all(
          10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                // Text(
                //   // S.of(context).me,
                //   '我',
                //   style: TextStyle(
                //     color: Colors.grey,
                //     fontSize: 13.0,
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                  ),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: entity.type == 'text' || entity.type == 'audio' ? Color(0xff4ADDFE) : null,
                    borderRadius: BorderRadius.all(Radius.circular(
                      4.0,
                    )),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: 300.0,
                    maxHeight: 300.0
                  ),
                  child: MessageWidget(entity)
                )
              ],
            ),
            Card(
              margin: EdgeInsets.only(
                left: 10.0,
              ),
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 0.0,
              child: Container(
                height: 40.0,
                width: 40.0,
                child: Image.network('$base_url${userInfo['head_pic']}', fit: BoxFit.cover,),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(
          10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(
                right: 10.0,
              ),
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 0.0,
              child: Container(
                height: 40.0,
                width: 40.0,
                child: Image.asset('assets/images/Kefu.jpg', fit: BoxFit.cover,),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   '${arguments['nickname']}',
                //   style: TextStyle(
                //     color: Colors.grey,
                //     fontSize: 13.0,
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                  ),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: entity.type == 'text' || entity.type == 'audio' ? Colors.black12 : null,
                    borderRadius: BorderRadius.all(Radius.circular(
                      4.0,
                    )),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: 300.0,
                  ),
                  child: MessageWidget(entity)
                )
              ],
            ),
          ],
        ),
      );
    }
  }

  // 判断显示什么类型的消息
  Widget MessageWidget(entity){
    switch (entity.type) {
      case 'text':
        return Text(
                entity.message ?? '',
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: entity.newIsMe ? Colors.white : Colors.black,
                  fontSize: 16.0,
                ),
              );
        break;
      case 'img':
      print(entity.isNetWork);
        return entity.newIsMe && !entity.isNetWork ? 
          InkWell(
            child: Image.file(entity.message),
            onTap: (){
              print('点了图片');
              Map arguments = {
                'imageProvider':FileImage(entity.message),
                'heroTag':'simple'
              };
              Navigator.pushNamed(context, '/image', arguments: arguments);
            },
          )
         : 
         InkWell(
           child: Image.network('$base_url${entity.message}'),
           onTap: (){
             Map arguments = {
                'imageProvider':NetworkImage('$base_url${entity.message}'),
                'heroTag':'simple'
              };
              Navigator.pushNamed(context, '/image', arguments: arguments);
           },
         );
        break;
      case 'video':
        return  InkWell(
          child: Container(
            width: ScreenAdapter.setWidth(300),
            height: ScreenAdapter.setHeight(150),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10)
            ),
            alignment: Alignment.center,
            child: Icon(Icons.play_arrow, color: Colors.white,),
          ),
          onTap: (){
            Map arguments = {
              'isMe':entity.newIsMe,
              'message':entity.message
            };
            // print(entity.isNetWork);
            if(entity.isNetWork){
              arguments['message'] = '$base_url'+arguments['message'];
            }
            print(arguments);
            Navigator.pushNamed(context, '/video', arguments: arguments);
          },
        );
        break;
      case 'audio':
        return Container(
            width: ScreenAdapter.setWidth(160),
            child: entity.newIsMe ?
            InkWell(
              onTap: (){
                print('本地发送语音');
                print(entity.message);
                 !entity.isNetWork ? 
                playByPath(entity.message):
                playByPath('$base_url${entity.message}');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${entity.time_length}'),
                  Container(
                    margin: EdgeInsets.only(left: ScreenAdapter.setWidth(10)),
                    width: ScreenAdapter.setWidth(50),
                    height: ScreenAdapter.setHeight(30),
                    // color: Colors.red,
                    child: Image.asset('assets/images/recording_right.png', fit: BoxFit.cover,),
                  )
                ],
              ),
            )
            :
             InkWell(
               onTap: (){
                  print('socket发送来的消息');
                  print('$base_url${entity.message}');
                  playByPath('$base_url${entity.message}');
               },
               child: Row(
                  children: <Widget>[
                    Text('${entity.time_length}'),
                    Container(
                      margin: EdgeInsets.only(left: ScreenAdapter.setWidth(10)),
                      width: ScreenAdapter.setWidth(50),
                      height: ScreenAdapter.setHeight(30),
                      // color: Colors.red,
                      child: Image.asset('assets/images/recording_left.png', fit: BoxFit.cover,),
                    )
                  ],
                ),
             )
            
          );
        break;
      default:
    }
  }


    ///播放指定路径录音文件
  void playByPath(String path) {
    recordPlugin.playByPath(path);
  }

   // dio上传文件FormData格式
  Future<FormData> FormData1(fileUrl) async {
    return FormData.fromMap({
      "file": await MultipartFile.fromFile(fileUrl)
    });
  }

  // 判断历史记录的类型存储到数组中
  chatHistory(response, gl_context, isMe){
    switch (response['content_type']) {
      case 'text':
          Provide.value<SocketProvider>(gl_context).setServiceRecords(response['content'], 'text',  isMe, isNetWork: true, history: true);
        break;
      case 'img':
          Provide.value<SocketProvider>(gl_context).setServiceRecords(response['content'],'img', isMe, isNetWork: true, history: true);
        break;
      case 'video':
          Provide.value<SocketProvider>(gl_context).setServiceRecords(response['content'],'video',  isMe, isNetWork: true, history: true);      
        break;
      case 'audio':
          Provide.value<SocketProvider>(gl_context).setServiceRecords(response['content'],'audio', isMe, time_length:response['time_length'], isNetWork: true, history: true);
        break;
      default:
    }
  }
}
