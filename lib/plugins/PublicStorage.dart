import 'dart:convert';

import 'package:project/provide/SocketProvide.dart';
import 'package:provide/provide.dart';

import 'Storage.dart';

// 公用的本地存储

class PublicStorage {
  /*
    1.获取本地存储里面的数据
    2.判断本地存储是否有数据

      2.1 如果有数据
        1、读取本地存储的数据
        2、判断本地存储中有没有当前的数据,
            如果有，不做操作
            如果没有当前数据，本地存储的数据和当前数据拼接后重新写入
      2.2、 如果没有数据
          直接把当前数据放在数组中写入到本地存储
   */

  

   static setHistoryList(key, value, {isSearch}) async {
    try{
      // 首先获取一下判断有没有数据
      var searchListData = json.decode(await Storage.getString(key));

    // 如果本地存储有值，判断是否有这个值
       var hasData = searchListData.any((v){
          // 如果有就返回true，如果没有返回false
          return v == value;
        });
      
      // 本地存储判断
      if(!hasData){
        if(isSearch){
          searchListData.add(value);
        }else{
          searchListData[0] = value;
        }
        await Storage.setString(key, json.encode(searchListData));
      }
    }catch(e){
      // 没有数据
      List tempList = new List();
      tempList.add(value);
      // json.encode:数组转为字符串
      await Storage.setString(key, json.encode(tempList));
    }
  }

// //   处理消息列表
  static setHistoryChatListPage(key, value, context) async{
    
     try{
    //  print('xxxxxxxxxxxxxxxxxxxxxxxxxx');
      // 首先获取一下判断有没有数据
      var chatListData = json.decode(await Storage.getString(key));
      // print('首先获取本地存储数据${chatListData[0]}');
      // print('传入进来的数据：$value!!!!!!!!');
        for(var i = 0; i<chatListData[0].length; i++){
          // print('循环吗？');
          try{
            // var a = json.decode(value[i]['content']);
            if(chatListData[0][i]['nickname'] == value[i]['nickname']){
              chatListData[0][i]['content_type'] = value[i]['content_type'];
              chatListData[0][i]['content'] = value[i]['content'];
              chatListData[0][i]['chat_time'] = value[i]['chat_time'];
              chatListData[0][i]['nickname'] = value[i]['nickname'];
              // chatListData[0][i]['see'] = value[i]['see'];
              chatListData[0][i]['head_pic'] = value[i]['head_pic'];
              chatListData[0][i]['unread_num'] = value[i]['unread_num'];
            }else{
              print('-------------------不相等------------------');
              // chatListData[0].add(value[i]);
               if(chatListData[0][0]['nickname'] == value[0]['nickname']){
                chatListData[0][0]['content_type'] = value[0]['content_type'];
                chatListData[0][0]['content'] = value[0]['content'];
                chatListData[0][0]['chat_time'] = value[0]['chat_time'];
                chatListData[0][0]['nickname'] = value[0]['nickname'];
                // chatListData[0][i]['see'] = value[i]['see'];
                chatListData[0][0]['head_pic'] = value[0]['head_pic'];
                chatListData[0][0]['unread_num'] = value[0]['unread_num'];
              }else{
                chatListData[0]..insert(0, value[i]);
              }
              
            }
          }catch(e){
            // print('内部catch！！！');
            
            break;
          }
        }
        // 再向本地存储当中存一遍
        await Storage.setString(key, json.encode(chatListData));
        Provide.value<SocketProvider>(context).setHistoryChat();
    }catch(e){
      // print('Catch！！！！！');
      // try{
      //   var chatListData = json.decode(await Storage.getString(key));
      //   print(chatListData);
      // }catch(e){

      // }
      
      // 没有数据
      List tempList = new List();
      tempList.add(value);
      // json.encode:数组转为字符串
      await Storage.setString(key, json.encode(tempList));
      Provide.value<SocketProvider>(context).setHistoryChat();
    }
  }

  // 处理消息列表是否查看
  static replaceHistoryChatListSee(key, index, context) async {
      // 首先获取
      // 删除掉指定的值，
      // 再次存储进去新的值
      List chatListData = json.decode(await Storage.getString(key));
      for(var i = 0; i < chatListData[0].length; i++){
        if(index == i){
          chatListData[0][i]['see'] = true;
        }
      }
      // print('处理后的数据：$chatListData');
       await Storage.setString(key, json.encode(chatListData));
       Provide.value<SocketProvider>(context).setHistoryChat();
  }

  // 处理消息列表中的数据
  static replaceHistoryChatList(key, index, context) async {
      // 首先获取
      // 删除掉指定的值，
      // 再次存储进去新的值
      List chatListData = json.decode(await Storage.getString(key));
      for(var i = 0; i < chatListData[0].length; i++){
        if(index == i){
          chatListData[0][i]['see'] = true;
        }
      }
      // print('处理后的数据：$chatListData');
       await Storage.setString(key, json.encode(chatListData));
       Provide.value<SocketProvider>(context).setHistoryChat();
  }

// 获取历史记录
  static Future getHistoryList(key) async {
    try{
      List searchListData = json.decode(await Storage.getString(key));
      return searchListData;
    }catch(e){
      return [];
    }
  }

  // 清空
  static clearHistoryList() async {
      
      await Storage.clear();
     
  }

  static replaceListHistoryData(key, value) async {

      // 首先获取
      // 删除掉指定的值，
      // 再次存储进去新的值
      List searchListData = json.decode(await Storage.getString(key));
      
      searchListData.remove(value);
      // print(searchListData);
      await Storage.setString(key, json.encode(searchListData));
     
  }

  static removeHistoryData(key) async {
    Storage.remove(key);
  }

}