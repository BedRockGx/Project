import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 沉浸式状态栏
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/config/api.dart';
import 'package:project/pages/Chat/ChatListPage.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/user_data.dart';
import 'package:provide/provide.dart'; // 状态管理
import 'package:project/provide/Useridentity.dart';
import 'package:project/provide/HomeProvide.dart';
import 'package:project/provide/ColorProvide.dart';
import 'package:project/provide/Colors.dart';
import 'package:project/provide/userinformation.dart';
import 'package:project/provide/SocketProvide.dart';

import 'package:project/routers/router.dart';
import 'package:project/pages/tabs/Tab.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:amap_core_fluttify/amap_core_fluttify.dart'; // 设置定位通用插件
import 'package:flutter_localizations/flutter_localizations.dart'; // Flutter 国际化包
import 'plugins/CustomLocalizations.dart';

import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
// import 'package:jpush_flutter/jpush_flutter.dart';


void main() async {
  // //初始化
  // JPush jpush = new JPush();
  // // 获取版本号时，就准备下载
  // // await FlutterDownloader.initialize();
  // jpush.setup(
  //     appKey: "6ff6c2adb5c3a9604c14a0da",
  //     channel: "themChannel",
  //     production: false,
  //     debug: false //是否打印debug日志
  //     );

  // // 获取注册id 能够获取到id 就说明你配置成功了
  // jpush.getRegistrationID().then((r) {
  //   print("getRegistrationID获取注册idjpush---------id: $r");
  // });
  // jpush.addEventHandler(
  //     // 接收通知回调方法
  //     onReceiveMessage: (Map<String, dynamic> message) async {
  //   //do something
  //   print("flutter------------onReceiveMessage-------${message}----");
  // },
  //     // 点击通知回调方法
  //     onOpenNotification: (Map<String, dynamic> message) async {
  //   //do something
  //   print("onOpenNotification---------点击通知回调方法--${message}--");
  // },R
  //     // 接收自定义消息回调方法
  //     onReceiveNotification: (Map<String, dynamic> message) async {
  //   //do something
  //   print("onReceiveNotification---------点击通知回调方法-------${message}-");
  // });

  RongIMClient.disconnect(false);     // 断掉IM链接

  await AmapCore.init('bfe8ea871313c532985f8b5733f6ec04'); // 地图IOS配置
  // await enableFluttifyLog(false); // 关闭log(false);  // 新版本可用

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  var providers = Providers();
  var counter = Useridentity();
  var homeProvide = HomeProvide();
  var theme = ThemeProvide();
  var userinfomation = UserInfomation();
  var socketProvider = SocketProvider();

  providers
    ..provide(Provider<Useridentity>.value(counter))
    ..provide(Provider<HomeProvide>.value(homeProvide))
    ..provide(Provider<ThemeProvide>.value(theme))
    ..provide(Provider<UserInfomation>.value(userinfomation))
    ..provide(Provider<SocketProvider>.value(socketProvider));
    

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  
  static BuildContext getContext() {
    return _MyAppState.getContext();
  }
}

class _MyAppState extends State<MyApp>{

    AppLifecycleState currentState = AppLifecycleState.resumed;
  DateTime notificationQuietEndTime;
  DateTime notificationQuietStartTime;
  static BuildContext appContext;

  static BuildContext getContext() {
    return appContext;
  }

  
  var locationList = []; // 获取本地存储定位信息
  var token;
  
  var api = new Api();

  // var position = 0;

  @override
  void initState() {
    super.initState();
    Plugins.getLocation(context);
    _getLocation();
    _getToken();
    _setUserData();
    _getThem();
  }



  // 本地存储主题
  _getThem() async {
    var index = await PublicStorage.getHistoryList('Theme');
    if (index.isEmpty) {
      return;
    }
    Provide.value<ThemeProvide>(context).setTheme(index[0]);
  }

  // 获取本地存储定位
  _getLocation() async {
    locationList = await PublicStorage.getHistoryList('LocationCity');
    if (locationList.length == 0) {
      locationList.add('未定位');
    }
    Provide.value<UserInfomation>(context).setCity(locationList[0]);
  }

  // 获取本地存储token，判定用户token是否过期
  _getToken() async {
    token = await PublicStorage.getHistoryList('token');
    // print('获取本地存储token:${token}');
    Provide.value<UserInfomation>(context).setToken(token);
  }

  _setUserData() {
    api.getData(context, 'userInfo').then((val) {
      if (val == null) {
        return;
      }
      var response = json.decode(val.toString());
      PublicStorage.setHistoryList('UserInfo', response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provide<ThemeProvide>(
      builder: (context, child, theme) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: MaterialApp(
            debugShowCheckedModeBanner: false, // 关闭debug图标
            // 自定义主题
            theme: ThemeData(
              // primaryColor: YColors.themeColor[theme.value]["primaryColor"],
              primaryColor:Colors.white,
              platform: TargetPlatform.iOS,       // IOS风格
              // 修复TextField光标无法与提示文本对齐问题
              textTheme: TextTheme(
                  subhead: TextStyle(textBaseline: TextBaseline.alphabetic)),
            ),
            // home: ChatListPage(),
            initialRoute: '/', // 默认路由
            // routes: routes,
            onGenerateRoute: onGenerateRoute, // 跳转拦截
            localizationsDelegates: [
              ChineseCupertinoLocalizations.delegate, // 自定义的delegate

              DefaultCupertinoLocalizations.delegate, // 目前只包含英文
              //此处
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            // locale: const Locale('CH'),

            supportedLocales: [
              //此处
              const Locale('zh', 'CH'),
              const Locale('en', 'US'),
            ],
          ),
        );
      },
    );
  }

    @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    currentState = state;
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        break;
    }
  }
}
