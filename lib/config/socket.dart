import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/pages/EventBus/bus.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:provide/provide.dart';
import 'package:project/provide/SocketProvide.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:provide/provide.dart';
import 'package:project/provide/userinformation.dart';

import 'api.dart';

class ClientSocket {
   var gl_sock;

   var response;

   var gl_context;

   var token;

   int commandTime = 15;
  
   Timer timer;

   bool netWorkStatus = true;

   bool socketStatus = false;

  // 初始化一个流
  // static StreamController controller = StreamController();
  // static Stream stream;
  
   void Connect(context) async {
    
    // 获取本地存储Token
    token = await PublicStorage.getHistoryList('token');
    if(token.isEmpty || !netWorkStatus){
      timer = null;
      return;
    }

    

    //创建一个Socket连接到指定地址与端口
    await Socket.connect('49.232.44.100', 9501).then((socket){ 
      // print('连接成功111111');
      
      socketStatus = true;
      
      gl_sock = socket;
      gl_context = context;
      // print(gl_sock);
      // print('-------------------------------准备触发状态管理----------------------------------');
      // 存储全局socket对象
      Provide.value<SocketProvider>(context).setSocket(gl_sock);
      // 全局的socket设置为在线状态
      Provide.value<SocketProvider>(context).setOnlineSocket(true);

      // 握手操作
      // Map arguments = {
      //   "type":"shake_hand"
      // };
      // print(arguments);
      // gl_sock.write(json.encode(arguments));

      // 发送token验证
      Map arguments = {
        "type":"verify_token",
        "token":token[0]
      };
      // print(arguments);
      gl_sock.write(json.encode(arguments));
      

      gl_sock.listen(dataHandler,
            // onError: errorHandler,
            onDone: doneHandler,
            cancelOnError: false);
      // gl_sock.close();
    }).catchError((e) {
      print("socket无法连接: $e");

      // reconnectSocket();
    });

  }

  //接收报文
   dataHandler(data) async {
    print('Socket发送来的消息');
    var cnData = await utf8.decode(data);
    response = json.decode(cnData.toString());
    // print(response['type']);
    print('!!!!!!!!!!!!!!!!!!!!!!!Socket返回的数据！！！！！！！！！！！！！！！！！！！！！');
    print(response);

    if(response['type'] == 'verify_success'){
      print('可以进行socket通信');
      Fluttertoast.showToast(msg: '欢迎登录~');
      Provide.value<UserInfomation>(gl_context).setSocket(true);
      // 给后台发送心跳
      heartbeatSocket();
      return;
    }
    if(response['recv_id'] != null){

      if(response['send_id'] == 'admin'){
        switch (response['content_type']) {
          case 'text':
              Provide.value<SocketProvider>(gl_context).setServiceRecords(response['content'], 'text',  false);
            break;
          case 'img':
              Provide.value<SocketProvider>(gl_context).setServiceRecords(response['content'],'img', false);
            break;
          default:
        }
        return;
      }

      if(response['recv_id'] != int.parse(response['send_id'])){
        var api = new Api();
        var getUserInfo;
        api.getData(gl_context,'userImage', formData:{'user_id':response['send_id']}).then((val){
          if(val == null){
            return;
          }
          getUserInfo = json.decode(val.toString());
          print('获取用户信息：$getUserInfo');
            List<Map> arguments = [
              {
                'user_id': response['send_id'],
                'content_type': response['content_type'],
                'content': {
                  'type': response['type'],
                  'content_type': response['content_type'],
                  'content': response['content'],
                  'recv_id': response['recv_id'],
                  'send_id': response['send_id']
                },
                'chat_time': Plugins.stampTime(DateTime.now()),
                'nickname': getUserInfo['nickname'],
                'head_pic': getUserInfo['head_pic'],
                'see': false,
                'isNew':true,
                'unread_num':1
              }
            ];
            print('111111111111111111111111111111111');
            print(arguments);
            PublicStorage.setHistoryChatListPage('historyChatList', arguments, gl_context);
        });
        
        switch (response['content_type']) {
          case 'text':
              Provide.value<SocketProvider>(gl_context).setRecords(response['content'], 'text',  false);
            break;
          case 'img':
              Provide.value<SocketProvider>(gl_context).setRecords(response['content'],'img', false);
            break;
          case 'video':
              Provide.value<SocketProvider>(gl_context).setRecords(response['content'],'video',  false);      
            break;
          case 'audio':
              Provide.value<SocketProvider>(gl_context).setRecords(response['content'],'audio', false, time_length:response['time_length']);
            break;
          default:
        }
      }

      
    }else{
      var api = new Api();
      var getUserInfo;

      api.getData(gl_context,'userImage', formData:{'user_id':response['send_user']}).then((val){
        if(val == null){
          return;
        }
        getUserInfo = json.decode(val.toString());
        print('获取用户信息：$getUserInfo');

        switch (response['content_type']) {
          case 'text':
              Provide.value<SocketProvider>(gl_context).setGroupRecords(response['content'], 'text',  false, head_pic: getUserInfo['head_pic'], nickname: getUserInfo['nickname']);
            break;
          case 'img':
              Provide.value<SocketProvider>(gl_context).setGroupRecords(response['content'],'img', false, head_pic: getUserInfo['head_pic'], nickname: getUserInfo['nickname']);
            break;
          case 'video':
              Provide.value<SocketProvider>(gl_context).setGroupRecords(response['content'],'video', false, head_pic: getUserInfo['head_pic'], nickname: getUserInfo['nickname']);
            break;
          case 'audio':
              Provide.value<SocketProvider>(gl_context).setGroupRecords(response['content'],'audio', false, time_length:response['time_length'], head_pic: getUserInfo['head_pic'], nickname: getUserInfo['nickname']);
            break;
          default:
        }
      });
      
    }
    

  }
  

  getMessage() async {
    return response;
  }


  // socket报错
  // void errorHandler(error, StackTrace trace){
  //   print('socket报错');
  //   // 出现了错误，就不能清空定时器，开始重复连接
  //   clearTimer = false;
  //   Fluttertoast.showToast(msg: '聊天报错！从新连接服务器2222222222222222222222');
    
    
  //   reconnectSocket();
  //   print(error);
  //   // return error;
  // }

  void doneHandler(){
    print('Socket出现断开的问题');
    socketStatus = false;
    Fluttertoast.cancel();
    // Fluttertoast.showToast(msg: '与服务器断开，正在从新连接!');
    reconnectSocket();
  }
  
  // 重新连接socket
  void reconnectSocket(){
    print('失败了后，从新连接');
    int count = 0;
    const period = const Duration(seconds: 1);
    // 定时器
    Timer.periodic(period, (timer) {
      // 每一次重连之前，都删除关掉上一个socket
      // gl_sock.close();
      gl_sock = null;
      count++;
      if(count >= 3){
        print('时间到了!!!开始从连socket');
        // 链接socket
        Connect(gl_context);
        count = 0;
        timer.cancel();
        timer = null;
        Fluttertoast.cancel();
      }
    });
  }


  // 心跳机，每15秒给后台发送一次，用来保持连接
  void heartbeatSocket(){
    
    const duration =  Duration(seconds:1);
    print(token);
    var callback = (time) async {
      if(!socketStatus){
        time.cancel();
      }
      var _subscription = Connectivity()
                        .onConnectivityChanged
                        .listen((ConnectivityResult result) {
                          // print('--------------------当前网络：$result------------------------');
                      if (result != ConnectivityResult.mobile && result != ConnectivityResult.wifi) {
                        print('没有网络，停止定时器');
                        netWorkStatus = false;
                        time.cancel();
                      }else{
                        netWorkStatus = true;
                      }
                    });
    
      token = await PublicStorage.getHistoryList('token');

      if(token.isEmpty){
        print('token为空，关闭定时器');
        time.cancel();
        return;
      }

      if(commandTime < 1){
        print('-----------------发送心跳------------------');
        print(token);
        Map arguments = {
          "type":"heartbeat",
        };
        gl_sock.write(json.encode(arguments));

        commandTime = 15;
      }else{
        commandTime--;
      }
    };

    timer = Timer.periodic(duration, callback);
  }


}