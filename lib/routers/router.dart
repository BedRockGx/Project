import 'package:flutter/material.dart';
import 'package:project/pages/Chat/groupChatPage.dart';
import 'package:project/pages/Chat/servicePage.dart';
import 'package:project/pages/UserOrderList/DriverNumList.dart';
import 'package:project/pages/UserOrderList/Drivider_order_list.dart';
import 'package:project/pages/UserOrderList/myRecruitHall.dart';
import 'package:project/pages/details/RecruitDetails.dart';
import 'package:project/pages/tabs/DriverPage.dart';

import 'package:project/pages/tabs/Tab.dart';
import 'package:project/pages/SearchPage/search.dart';
import '../pages/user_operation/Login.dart';
import '../pages/SearchPage/searchTest.dart';
import 'package:project/pages/details/ArticleDetails.dart';
import 'package:project/pages/Chat/ChatListPage.dart';
import 'package:project/pages/Chat/ChatPage.dart';
import 'package:project/pages/FormPage/addOrder.dart';
import 'package:project/plugins/search_map.dart';
// import 'package:project/plugins/CitySelect.dart';            // 自定义城市列表选择
import 'package:project/pages/SearchPage/register.dart';
import 'package:project/plugins/CommodityDetails.dart';
import 'package:project/pages/details/OrderDetails.dart';
import 'package:project/pages/UserOrderList/user_order_list.dart';
import 'package:project/pages/user_operation/modifyUserInfo.dart';
import 'package:project/pages/FormPage/AuthenicationDriver.dart';
import 'package:project/pages/user_operation/upgradeVip.dart';
import 'package:project/pages/Pay/pay.dart';
import 'package:project/pages/Pay/TiPay.dart';
import 'package:project/plugins/evaluatePage.dart';
import 'package:project/pages/tabs/advertisement.dart';
import 'package:project/pages/Chat/MessageListPage.dart';
import 'package:project/pages/Chat/Video.dart';
import 'package:project/pages/Chat/showImage.dart';
import 'package:project/plugins/noticePage.dart';
import 'package:project/plugins/transactionPage.dart';
import 'package:project/pages/Pay/wallet.dart';
import 'package:project/pages/Pay/bill.dart';
import 'package:project/pages/Chat/VipUserList.dart';
import 'package:project/pages/user_operation/Settings.dart';
import 'package:project/plugins/webPage.dart';
import 'package:project/pages/UserOrderList/recruitHall.dart';
import 'package:project/pages/FormPage/addRecruit.dart';
import 'package:project/pages/tabs/OrderHall.dart';
// import 'package:project/pages/Chat/videoTest.dart';

// 配置路由

final routes = {
  '/':(context) => SplashPage(),
  '/tab':(context) => Tabs(),
  '/orderHall':(context) => DriverPage(),
  '/search':(context) => SearchPage(),
  '/login':(context) => LoginPage(),
  '/search_test':(context) => SearchBarDemo(),
  '/register' :(context, {arguments}) => RegisterPage(arguments),
  '/article_details':(context, {arguments}) => ArticleDetailsPage(arguments),
  '/chatList':(context) => ChatListPage(),
  '/chatPage':(context,{arguments}) => ChatPage(arguments),
  '/groupChat':(context,{arguments}) => GroupChatPage(arguments),
  '/servicePage':(context,{arguments}) => ServiceChatPage(arguments),
  // '/chatPage':(context) => ChatPage(),
  '/addOrder':(context) => AddOrder(),
  '/search_map':(context) => SearchMap(),
  // '/city_select':(context) => CitySelectRoute(),
  '/commodity_details':(context, {arguments}) => CommodityDetails(arguments:arguments),
  '/order_details':(context, {arguments}) => OrderDetails(arguments),
  '/user_order':(context, {arguments}) => UserOrderList(arguments),
  '/modify_userInfo':(context, {arguments}) => ModifyUserInfo(arguments),
  '/authenication_Driver':(context, {arguments}) => AuthenicationDriver(),
  '/upgrade_vip':(context) => UpgradeVip(),
  '/pay':(context,{arguments}) => PayPage(arguments),
  '/ti_pay':(context,{arguments}) => TiPayPage(arguments),
  '/evaluate':(context, {arguments}) => EvaluatePage(arguments),
  '/driverList':(context, {arguments}) => DriverNumList(arguments),
  '/dirviderOrderList':(context, {arguments}) => DirividerOrderList(arguments),
  '/messagePush':(context, {arguments}) => MessageListPage(arguments),
  '/video':(context, {arguments}) => VideoApp(arguments),
  '/image':(context, {arguments}) => PhotoViewSimpleScreen(arguments),
  '/noticePage':(context, {arguments}) => NoticePage(),
  '/transactionPage':(context, {arguments}) => TransactionPage(),
  '/wallet':(context, {arguments}) => WalletPage(arguments),
  '/bill':(context, {arguments}) => BillPage(),
  '/vipList':(context, {arguments}) => VipUserList(arguments: arguments,),
  '/settings':(context, {arguments}) => SettingsPage(),
  '/webpage':(context, {arguments}) => WebPage(arguments),
  '/recruitHall':(context, {arguments}) => RecruitHall(),
  '/addRecruit':(context, {arguments}) => AddRecruitPage(),
  '/myRecruitHall':(context, {arguments}) => MyRecruitHall(),
  '/recruitDetails':(context, {arguments}) => RecruitDetails(arguments),
  // '/videoTest':(context, {arguments}) => VideoTest(),
};

// 路由跳转

var onGenerateRoute = (RouteSettings settings) {
  final String router_name = settings.name;         // 路由路径
  final Function router_fn = routes[router_name];     // 路由构造器
  
  // 判断确实有这个路由构造器
  if(router_fn != null){
    // 如果有参数的话
    if(settings.arguments != null){
      final Route route = MaterialPageRoute(
        builder: (context) => router_fn(context, arguments:settings.arguments)
      );
      return route;
    }else{
      final Route route = MaterialPageRoute(
        builder:(context) => router_fn(context)
      );
      return route;
    }
  }


  
};
