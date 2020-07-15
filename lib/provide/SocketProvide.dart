import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/config/socket.dart';
import 'package:project/pages/EventBus/bus.dart';
import 'package:project/plugins/PublicStorage.dart';

class SocketProvider with ChangeNotifier{

    int a = 1;
    Socket socket;
    bool onlineSocket = false;        // socket是否在线
    String netWorkstate = 'none';              // 网络状态
    bool isOne = true;
    List<ChatRecord> records = List<ChatRecord>();
    List<GroupChatRecord> grouprecords = List<GroupChatRecord>();
    List<ServiceChatRecord> servicerecords = List<ServiceChatRecord>();
    List historyChat = [];
    var base_url = 'https://flutter.ikuer.cn'; 
    


    // 存储socket
    setSocket(val){
      this.socket = val;
      notifyListeners();
    }

    // 存储发送来的消息
    // 私聊消息，消息类型, 是不是我发送的，语音时间长度, 是否需要显示成网络信息， 是不是历史记录存储
    setRecords(message,String type, bool newIsMe,{String time_length, bool isNetWork = false, history:false}){
      // 是不是历史记录
      if(history){
        records..insert(records.length, ChatRecord(message: message,type:type, newIsMe: newIsMe, time_length:time_length, isNetWork: isNetWork));
      }else{
        records..insert(0, ChatRecord(message: message,type:type, newIsMe: newIsMe, time_length:time_length, isNetWork: isNetWork));
      }
      notifyListeners();
    }

     // 存储发送来的消息
    // 客服私聊消息，消息类型, 是不是我发送的，语音时间长度, 是否需要显示成网络信息， 是不是历史记录存储
    setServiceRecords(message,String type, bool newIsMe,{String time_length, bool isNetWork = false, history:false}){
      if(history){
        servicerecords..insert(servicerecords.length, ServiceChatRecord(message: message,type:type, newIsMe: newIsMe, time_length:time_length, isNetWork: isNetWork));
      }else{
        servicerecords..insert(0, ServiceChatRecord(message: message,type:type, newIsMe: newIsMe, time_length:time_length, isNetWork: isNetWork));
      }
      // servicerecords..insert(0, ServiceChatRecord(message: message,type:type, newIsMe: newIsMe, time_length:time_length, isNetWork: isNetWork));
      
      notifyListeners();
    }

    // 群聊消息，消息类型, 是不是我发送的，语音时间长度, 是否需要显示成网络信息， 是不是历史记录存储
    setGroupRecords(message,String type, bool newIsMe, {String time_length, bool isNetWork = false, String head_pic, String nickname, history:false}){
      if(history){
        grouprecords..insert(grouprecords.length, GroupChatRecord(message: message,type:type, newIsMe: newIsMe, time_length:time_length, isNetWork: isNetWork, head_pic: head_pic, nickname: nickname));
      }else{
        grouprecords..insert(0, GroupChatRecord(message: message,type:type, newIsMe: newIsMe, time_length:time_length, isNetWork: isNetWork, head_pic: head_pic, nickname: nickname));
      }

      
      
      notifyListeners();
    }


    // 存储消息列表历史记录
    setHistoryChat() async {
      // print('调用了本地存储！！！！');
      var historyChatList =await PublicStorage.getHistoryList('historyChatList');
      // print('获取本地存储数据:$historyChatList');
      
      historyChat = historyChatList[0];
      
      notifyListeners();
    }

    modifyHistory(index){
      // 修改的话，数组当中肯定是有这个数据的
      for(var i = 0; i < historyChat.length; i++){
        if(index == i){
          historyChat[i].see = true;
        }
      }
    }

    // 清空消息
    clearRecords(){
      records = [];
      grouprecords= [];
      servicerecords = [];
    }

    clearChatList(){
      historyChat = [];
    }

    // 设置socket是否在线
    setOnlineSocket(val){
      onlineSocket = val;
      notifyListeners();
    }

    // 设置当前网络状态
    setnetWorkState(val, context) async {
      var socket = new ClientSocket();
      var token = await PublicStorage.getHistoryList('token');
      // 只有当之前没有网络的时候，从新有了网络后才会从新触发socket通信
      // 默认的时候是none 所以初始化第一次打开的时候是可以触发的
      print((val == '4G' || val == 'Wifi'));
      if(val == '4G' || val == 'Wifi'){
        eventBus.fire(NetWorkOver('从新触发一次数据'));
      }
      if(token.isNotEmpty && netWorkstate == 'none' && (val == '4G' || val == 'Wifi')){
        // print('-----------------------------链接socket-------------------------');
        
        socket.Connect(context);
      }
      netWorkstate = val;
      
      
      
      notifyListeners();
    }

    // 获取当前网络状态
    getnetWorkState(){
      return netWorkstate;
    }
}

// 私聊发送消息内容数据
class ChatRecord{
  var message;
  String time_length;
  String type;
  bool newIsMe;
  Widget videoWidget;
  bool isNetWork;
  ChatRecord({this.message, this.type, this.newIsMe,  this.videoWidget, this.time_length, this.isNetWork});
}

// 客服发送消息内容数据
class ServiceChatRecord{
  var message;
  String time_length;
  String type;
  bool newIsMe;
  Widget videoWidget;
  bool isNetWork;
  ServiceChatRecord({this.message, this.type, this.newIsMe,  this.videoWidget, this.time_length, this.isNetWork});
}

// 群聊发送消息内容数据
class GroupChatRecord{
  var message;
  String time_length;
  String type;
  bool newIsMe;
  Widget videoWidget;
  bool isNetWork;
  String head_pic;
  String nickname;
  GroupChatRecord({this.message, this.type, this.newIsMe,  this.videoWidget, this.time_length, this.isNetWork, this.head_pic, this.nickname});
}

