import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:project/pages/EventBus/bus.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:project/pages/EventBus/event_bus.dart';
import 'package:project/pages/user_operation/Login.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:project/user_data.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

import 'Home.dart';
import 'OrderHall.dart';
import 'DriverPage.dart';
import 'User.dart';

import 'package:project/pages/android_back.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/config/api.dart';
import 'package:project/config/socket.dart';
import 'package:provide/provide.dart';
import 'package:project/provide/SocketProvide.dart';

import 'package:connectivity/connectivity.dart'; // 监控网络

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {

  int _currentIndex = 0; // 展示下标
  PageController _pageController;

  var _token;
  var api = new Api();
  var socket = new ClientSocket();
  var base_url = 'https://flutter.ikuer.cn';      // baserUrl接口
  var app_url;
  String progress = '';

  String _state;
  var _subscription;

  @override
  void initState() { 
    super.initState();
    // 链接socket
    // socket.Connect(context);

    this._pageController = new PageController(initialPage: _currentIndex);
    _getPackageInfo();
    _listenNetWork();

    initPlatformState();
  }

  initPlatformState() async {
    var rongToken = await PublicStorage.getHistoryList('rongcloud_token');
    RongIMClient.init('x18ywvqfx5szc');
    print('----------------------Token----------------');
    print(rongToken[0]);
    //2.连接 im SDK
    RongIMClient.connect(rongToken[0], (int code, String userId, ) {
      print('成功！！！！');
      print(code);
      EventBus.instance.commit(EventKeys.UpdateNotificationQuietStatus, {});
      if (code == 31004 || code == 12) {
        // Navigator.pushNamed(context, '/login');
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => route == null);
      } else if (code == 0) {
        print("用户 id：" + userId);
        // 连接成功后打开数据库
        // _initUserInfoCache();
      }
    });
  }



  _getPackageInfo() async {
   var version = await Plugins.getPackageInfo(context);
   api.getData(context, 'update').then((val){
      // print('-------------获取版本信息--------------');
      // print(json.decode(val.toString()));
      var response = json.decode(val.toString());
      // 如果当前版本比服务器小，返回-1，大返回1，相等返回0
      var isUpdate = version.compareTo(response['version_no']);

      setState(() {
        app_url = '$base_url${response['app_path']}';
      });
      if(isUpdate.toString() == '-1'){
        Plugins.showUpdateDialog(context, app_url);
      }
    });
  }
  
  _listenNetWork(){
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        Provide.value<SocketProvider>(context).setnetWorkState('4G', context);
        setState(() {
          _state = "手机网络";
        });
// I am connected to a mobile network.
      } else if (result == ConnectivityResult.wifi) {
        Provide.value<SocketProvider>(context).setnetWorkState('Wifi', context);
        setState(() {
          _state = "Wifi 网络";
        });
      } else {
        Fluttertoast.showToast(msg: '网络不稳定~ 请检查！');
        Provide.value<SocketProvider>(context).setnetWorkState('none', context);
        setState(() {
          _state = "没有网络";
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  List<Widget> pageList = [HomePage(),  DriverPage(), UserPage()];

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return WillPopScope(
      onWillPop: () async {
        // Plugins.openDrawer();
        AndroidBackTop.backDeskTop(); //设置为返回不退出app
        return false; //一定要return false
      },
      child: Scaffold(
        body: PageView(
          controller: this._pageController,
          children: this.pageList,
          onPageChanged: (index){
            // 滑动每个tab页
            setState(() {
             this._currentIndex = index; 
            });
          },
          // physics: NeverScrollableScrollPhysics(),      // 禁止滑动
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed, //允许多个菜单
          onTap: (index) {
            // print(Plugins.drawerBool);
            // if(Plugins.drawerBool){
            //   Plugins.openDrawer();
            // }
            setState(() {
              this._currentIndex = index;
              this._pageController.jumpToPage(index);
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), title: Text('任务大厅')),
            // BottomNavigationBarItem(icon: Icon(Icons.drive_eta), title: Text('招司机')),
            BottomNavigationBarItem(icon: Icon(Icons.person_pin),title: Text('用户'))
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,   // 按钮在中间
        // floatingActionButton: FloatingActionButton(
        //         child: Icon(Icons.add, color: Colors.black,),
        //         backgroundColor: Theme.of(context).primaryColor,
        //         tooltip: "有疑问？找客服",
        //         onPressed:(){
                  
        //         } 
        //       )
        
      ),
    );
  }
}
