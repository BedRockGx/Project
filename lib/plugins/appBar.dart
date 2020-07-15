import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:project/pages/EventBus/bus.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/Plugins.dart'; // 公用方法(申请定位)
import 'package:project/provide/SocketProvide.dart';

import 'package:provide/provide.dart';                           // 状态管理
import 'package:project/provide/userinformation.dart';
import 'package:project/plugins/PublicStorage.dart';          // 本地存储

/*
  头部搜索导航栏

 */



Widget appBar(context) {

  var a = Provide.value<UserInfomation>(context);

  // 城市选择
selectProvinceCity() async {
   Color tagBgColor = Color.fromRGBO(255, 255, 255, 0);
  Color tagBgActiveColor = Color(0xffeeeeee);
  Color tagFontColor = Color(0xff666666);
  Color tagFontActiveColor = Color(0xff242424);
   double tagBarFontSize = ScreenAdapter.size(30);

  double cityItemFontSize = ScreenAdapter.size(30);

  double topIndexHeight = ScreenAdapter.setHeight(40);

  double topIndexFontSize = ScreenAdapter.size(30);

  Color topIndexFontColor = Color(0xffc0c0c0);

  Color topIndexBgColor = Color(0xfff3f4f5);

  Color itemSelectFontColor = Colors.cyan;

  Color itemSelectBgColor = Colors.blueGrey;

  Color itemFontColor = Colors.black;

  Result result = await CityPickers.showCitiesSelector(
    context: context,
    title: '城市选择',
    // sideBarStyle:BaseStyle(color: Colors.red),
    sideBarStyle: BaseStyle(
            fontSize: tagBarFontSize,
            color: tagFontColor,
            backgroundColor: tagBgColor,
            backgroundActiveColor: tagBgActiveColor,
            activeColor: tagFontActiveColor),
        cityItemStyle: BaseStyle(
            fontSize: cityItemFontSize,
            color: itemFontColor,
            activeColor: itemSelectFontColor),
        topStickStyle: BaseStyle(
            fontSize: topIndexFontSize,
            color: topIndexFontColor,
            backgroundColor: topIndexBgColor,
            height: topIndexHeight)
  );
  print('----------------返回数据----------------');
  print(result);
  if(result == null){return;}

  var cityObj = json.decode(result.toString());
  // 将地址转为坐标，用于刷新坐标对应的订单列表页面
 Plugins.codeTransformLatlng(cityObj['cityName'], type: 0);

  //触发刷新订单列表
  eventBus.fire(OrderHallRefresh('刷新'));

  // 存储手动定位城市
  Provide.value<UserInfomation>(context).setCity(cityObj['cityName']);
  PublicStorage.setHistoryList('LocationCity', cityObj['cityName']);

  // 存储手动定位城市编码
  Provide.value<UserInfomation>(context).setCityCode(cityObj['cityId']);
  PublicStorage.setHistoryList('LocationCityCode', cityObj['cityId']);
  
}

  final rpx = MediaQuery.of(context).size.width / 750;

  return Container(
    color: Colors.white,
    child: Container(
        margin: EdgeInsets.symmetric(vertical:ScreenAdapter.setHeight(20)),
        padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(20)),
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenAdapter.setWidth(150),
              child:  Provide<UserInfomation>(
                // counter 是自定义逻辑类
                builder: (context, child, counter){
                  return InkWell(
                    child: Container(
                      // width: ScreenAdapter,
                      padding: EdgeInsets.only(left: counter.city.length > 3 ? ScreenAdapter.setWidth(5) : ScreenAdapter.setWidth(10)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: counter.city.length>4?ScreenAdapter.setWidth(100) : null,
                            child: Text('${counter.city}',overflow: TextOverflow.ellipsis,maxLines: 1, style: TextStyle(fontSize: counter.city.length>3? ScreenAdapter.size(25): ScreenAdapter.size(28)),),
                          ),
                          SizedBox(
                            width: ScreenAdapter.setWidth(6),
                          ),
                          Icon(IconData(0xe61c, fontFamily: 'myIcon'), size: ScreenAdapter.size(35),),
                        ],
                      ),
                    ),
                    onTap: a.city == '未定位' ?
                    (){
                      Plugins.getLocation(context);
                    }
                    :
                    selectProvinceCity
                  
                    
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                  height: ScreenAdapter.setHeight(60),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(200, 200, 200, 0.3), borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.only(left:ScreenAdapter.setWidth(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // 上下居中
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(10)),
                        child: Icon(Icons.search,size: ScreenAdapter.size(40), color: Color.fromRGBO(200, 200, 200, 0.8),),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          // padding: EdgeInsets.only(left:ScreenAdapter.setWidth(20)),
                          child: Text(
                            '请输入任务关键字',
                            style: TextStyle(
                                color: Colors.grey, fontSize: ScreenAdapter.size(30),
                              ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
            ),
            
            InkWell(
                    child: Container(
              width: ScreenAdapter.setWidth(80),
              // height: ScreenAdapter.setHeight(50),
              // height: 80 * rpx,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left:ScreenAdapter.setWidth(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(IconData(0xe617, fontFamily: 'myIcon'), size: 25 * rpx,),
                  
                  
                  Text('消息', style: TextStyle(fontSize: 20 * rpx),)
                ],
              ),
            ),
                    onTap: (){
                      Navigator.pushNamed(context, '/chatList').then((_){
                        // Provide.value<SocketProvider>(context).clearRecords();
                      });
                      // Navigator.pushNamed(context, '/conversationListPage');
                    },
                  ),
           
          ],
        ),
      ),
  );
}


