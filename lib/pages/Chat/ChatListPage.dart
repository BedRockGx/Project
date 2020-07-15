import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/provide/SocketProvide.dart';
import 'package:provide/provide.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:transparent_image/transparent_image.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with TickerProviderStateMixin{

  EasyRefreshController _controller;            // 下拉刷新
  var refreshData, response, id;
  var data = [];
  var base_url = 'https://flutter.ikuer.cn'; 
  var api = new Api();
  // AnimationController controller ;     // 动画控制器
  var chatList = [];


  @override
  void initState() {
    // controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);    // 添加动画控制器
    super.initState();

    // _getData();
    _getRongData();
  }
  

  _getData(){
    api.getData(context, 'lastest_contacts').then((val) async {
      if(val == null){
        return;
      }
      print('返回数据：$val');
      var response = json.decode(val.toString());
      print('后台返回列表：${response}');
      await PublicStorage.removeHistoryData('historyChatList');

      for(var i = 0; i<response.length; i++){
        response[i]['see'] = false;
        response[i]['isNew'] = false;
        response[i]['content'] = json.decode(response[i]['content']);
      }
      PublicStorage.setHistoryChatListPage('historyChatList', response, context);
      // print('------------------------------------------');
      

    });
  }

  _getRongData() async {
     List conversationList = await RongIMClient.getConversationList([RCConversationType.Private,RCConversationType.Group,RCConversationType.System]);
     var idList = [];
     print('----------------------获取消息列表-----------------');
     print(conversationList);
     if(conversationList == null){
       return;
     }
     for(var item in conversationList){
       idList.add(item.targetId);
     }
     print(idList);
     if(idList.isNotEmpty){
      api.getData(context, 'getMessageList', formData: {'contact_list':idList.join(',')}).then((val){
        if(val != null){
          var res = json.decode(val.toString());
          // List<Map> st = (res as List).cast();
          var msgList = [];
          // print(conversationList[0].targetId);
          // print(res[0]['id']);
          // List<Map> students = [
          // { 'name': 'tom', 'age': 16 },
          // { 'name': 'jack', 'age': 18 },
          // { 'name': 'lucy', 'age': 20 }
          // ];
         
          for(var i = 0; i < conversationList.length; i++){
            for(var j = 0; j<res.length; j++){
              // print('融云：${conversationList[i].targetId is int}');
              // print('服务器：${res[j]['id'] is int}');
              // print(conversationList[i].targetId == res[j]['id']);
               if(int.parse(conversationList[i].targetId)== res[j]['id']){
                 Map myData = {
                   'content':conversationList[i].latestMessageContent.content,
                   'chat_time':conversationList[i].sentTime.toString().substring(0, 10),
                   'id':conversationList[i].targetId,
                   'nickname':res[j]['nickname'],
                   'head_pic':res[j]['head_pic']
                };
                msgList.add(myData);
              }
            }
          }
          print(msgList);
          setState(() {
            chatList = msgList;
          });
        }
      });
     }
    
      // print(conversationList[0].targetId);
      // print(conversationList[0].sentTime);
      // print(conversationList[0].latestMessageContent.content);
      // print(conversationList[0]);
  }



   @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
          title: Container(
            child:  Text('消息', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body:
          Provide<SocketProvider>(
            builder: (context, child, val){
              // print('有吗？？？？');
              // print(val.historyChat.isEmpty);
              // print(val.historyChat[0]);
              if(chatList.length == 0){
                return Center(
                  child: Container(
                    child: Text('目前还没有人联系你呦~'),
                  ),
                );
              }else{
                return Container(
                      color: Colors.white,
                      child:
                      ListView.builder(
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: (){
                              Map arguments = {
                                'nickname':chatList[index]['nickname'],
                                'head_pic':chatList[index]['head_pic'],
                                'recv_id':chatList[index]['id'],
                                'isVip':false,
                                // 'seeIndex':index
                              };
                              // return;
                              Navigator.pushNamed(context, '/chatPage', arguments: arguments).then((val){
                                // _getData();
                                _getRongData();
                                // PublicStorage.replaceHistoryChatListSee('historyChatList', index, context);
                                
                                // Provide.value<SocketProvider>(context).clearRecords();
                              });
                              // print('谁发来的ID：${val.historyChat[index]['id']}');
                              // api.putData(context, 'read_status', formData: {
                              //   'user_id':val.historyChat[index]['user_id']
                              // }).then((val){
                              //   if(val == null){
                              //     return;
                              //   }
                              //   var response = json.decode(val.toString());
                              //   print(response);
                              // });
                            },
                            child: CardWidget(context, chatList[index], index, chatList.length),
                          );
                        },
                        itemCount:chatList.length,
                      )
                      // EasyRefresh.custom(
                      //       enableControlFinishRefresh: false,
                      //       enableControlFinishLoad: true,
                      //       controller: _controller,
                      //       // firstRefresh:true,
                      //       header: MaterialHeader(
                      //               valueColor:ColorTween(begin: Color(0xffff8080), end: Color(0xffff8080),)
                      //                 .animate(controller)
                      //                 ..addListener((){
                      //                   setState(() {});
                      //                 })
                      //             ),
                      //       footer: MaterialFooter(
                      //               valueColor:ColorTween(begin: Color(0xffff8080), end: Color(0xffff8080),)
                      //                 .animate(controller)
                      //                 ..addListener((){
                      //                   setState(() {});
                      //                 })
                      //             ),
                      //       onRefresh: () async {
                      //         await Future.delayed(Duration(seconds: 1), () {
                      //           print('--------------下拉刷新-------');
                      //           var now = new DateTime.now();
                                
                      //           _controller.resetLoadState();
                      //         });
                      //       },
                      //       onLoad: () async {
                      //         await Future.delayed(Duration(seconds: 1), () {
                      //           print('-----上拉加载------');
                      //           _controller.finishLoad(noMore:response.isEmpty,);
                      //         });
                      //       },
                      //       slivers: <Widget>[
                      //         SliverList(
                      //           delegate: SliverChildBuilderDelegate(
                      //                 (context, index) {
                      //               return CardWidget(context, index);
                      //               // EvaluatLayout(context, index);
                      //             },
                      //             childCount: data.length,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                    );
           
              }
               },
          )
         
    );
  
  }

  // Card消息列表
Widget CardWidget(context, val, index, length) {
  // print(val);
  return Container(
    padding: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(0),horizontal: ScreenAdapter.setWidth(30)),
    // margin: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
    child: Row(
      children: <Widget>[
        Container(
          width: ScreenAdapter.setWidth(110),
          child: AspectRatio(
            aspectRatio: 1/1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: '$base_url${val['head_pic']}', fit: BoxFit.cover,))
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(left:ScreenAdapter.setWidth(30)),
            height: ScreenAdapter.setHeight(120),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0,
                  color: index+1 == length ? Colors.white : Colors.black12
                )
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      // margin: EdgeInsets.only(left:ScreenAdapter.setWidth(30)),
                      child: Text(
                        // '哈哈哈',
                        val['nickname'],
                        style: TextStyle(fontSize: ScreenAdapter.size(30))),
                    ),
                    Text(
                      '${Plugins.dateTimeSocket(int.parse(val['chat_time']))}',
                      // '1234',
                        style:
                            TextStyle(fontSize: ScreenAdapter.size(28), fontWeight: FontWeight.w300)),
                  ],
                ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      // margin: EdgeInsets.only(left:ScreenAdapter.setWidth(30)),
                      child: Text(
                        // data[index]['content'][''],
                        // '${messageType(val['content_type'], val)}',
                        '${val['content']}',
                        style: TextStyle(fontSize: ScreenAdapter.size(30), color: Colors.black38),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // val['unread_num'] != 0 ? 
                    // Container(
                    //   width: ScreenAdapter.setWidth(40),
                    //   child: AspectRatio(
                    //     aspectRatio: 1/1,
                    //     child: ClipRRect(
                    //       borderRadius: BorderRadius.circular(20),
                    //       child: Container(
                    //         color: Color(0xffff8080),
                    //         alignment: Alignment.center,
                    //         child: Text('${val['unread_num']}', style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(25)),),
                    //       ),
                    //     ),
                    //   ),
                    // ) 
                    // :Text('')
                    
                  ],
                ),
              // Container(
              //   // margin: EdgeInsets.only(top:ScreenAdapter.setHeight(10)),
              //   height: ScreenAdapter.setHeight(0.5),
              //   color: Colors.black26,
              // )
            ],
          ),
          )
        ),
        
      ],
    ),
  );
}

// 判断消息类型

  messageType(type, val){
    // print('判断的数据：${val['content']}');
    switch (type) {
      case 'text':
          var newVal;
          newVal =  val['content']['content'];
          return newVal;
          break;
        case 'img':
          return '[图片]';
          break;
        case 'video':
          return '[视频]';
          break;
        case 'audio':
          return '[语音]';
          break;
        default:
    }
  }

}