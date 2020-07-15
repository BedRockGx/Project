import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/appBar.dart';
import 'package:project/plugins/subHeader.dart';

import 'package:project/plugins/appBar.dart';
import 'package:provide/provide.dart';
import 'package:project/provide/userinformation.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:project/pages/EventBus/bus.dart';
import 'package:transparent_image/transparent_image.dart';

class DriverPage extends StatefulWidget {
  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> with TickerProviderStateMixin{
  // 打开侧边栏
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // 控制刷新
  // ScrollController _scrollController = new ScrollController();
  EasyRefreshController _controller;

  AnimationController controller ;     // 动画控制器

  var base_url = 'https://flutter.ikuer.cn/';

  var api = new Api();
  var city; // 获取本地存储中的城市，是否有值，如果没有定位就不显示内容
  var adCode, latLng;
  var data = [];
  var page = 1;     // 第几页
  // 时间，请求参数，返回参数，请求条件
  var now, refreshData, response ,provide;

  // 从新获取了定位之后
  var locationBool = false;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    
    eventBus.on<OrderHallRefresh>().listen((e){
      // print('监听到切换搜索条件触发刷新数据');
      _controller.callRefresh();
    });
    // 二次定位成功后，从新生成数据
    eventBus.on<LocationOver>().listen((e) {
      locationBool = true;
    });

    controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);    // 添加动画控制器

    _getLocation().then((val){
        now = new DateTime.now();
        var lat = latLng[0][0].toString();
        var lng = latLng[0][1].toString();
        refreshData = {
          'page': page,
          'pagesize': 8,
          'time': stampTime(now),
          'condition': 'refresh',
          'adcode': adCode[0],
          'lat': lat.substring(lat.indexOf(' ') + 1),
          'lng': lng.substring(lat.indexOf(' ') + 2),
        };
        // _getData(formData: refreshData);
    });
    
  }
  @override
  void dispose() { 
    _scaffoldKey = null;
    super.dispose();
  }
  

  // 为了达到如果没有了数据取消上拉加载的效果，写成异步的形势，只有当请求完毕后，才会判断是否关闭上拉加载
  Future _getData({formData, typeOf}) async{
    print('-----------------传入参数----------------');
    print(formData);
    await api.getData(context, 'tasklist', formData: formData).then((val) {
      print('返回数据：${json.decode(val.toString())}');
      setState(() {
        response = json.decode(val.toString());
      });
      
      /*
        避免切换城市之后，数据没有刷新的问题：
        1:下拉刷新的情况 才会触发，新来的数据，会替换掉旧的数据
        2.上拉加载的情况 才会触发，新来的数据，会添加到旧数据之后
      */
      if(typeOf == 1){
        if(response.isEmpty){
          Fluttertoast.showToast(msg: '没有最新的数据！快去发布吧!');
        }
        setState(() {
          data = response;
        });
      }else{
        if(response.isEmpty){
          Fluttertoast.showToast(msg: '已经到底了！');
          // _controller.finishLoad(success:response.isEmpty,);
        //  _controller.finishLoad(noMore:response.isEmpty,);
        }
        setState(() {
          data.addAll(response);
        });
      }
      
      // print(data);
    });
  }

  // 判断是否定位，如果没有定位就不显示数据
  Future _getLocation() async {
    Plugins.getLocation(context);
    city = await PublicStorage.getHistoryList('LocationCity');
    adCode = await PublicStorage.getHistoryList('LocationCityCode');
    latLng = await PublicStorage.getHistoryList('LocationLatLng');
    if (city.isEmpty) {
      Plugins.getLocation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        // appBar: appBar(context),
       
        body: Provide<UserInfomation>(
          builder: (context, child, val) {
            print('--------------------11111111111111');
            print(val.city);
            if (val.city == '未定位') {
              return Loading(text: '请允许定位请求');
            } else {
              return Container(
              color: Colors.white,
                child: Stack(
                children: <Widget>[
                  Container(
                    color: Color.fromRGBO(245, 245, 246, 1),
                    margin: EdgeInsets.fromLTRB(
                        0, ScreenAdapter.setHeight(230), 0, 0),
                    child: EasyRefresh.custom(
                      enableControlFinishRefresh: false,
                      enableControlFinishLoad: true,
                      controller: _controller,
                      firstRefresh:true,
                      header: MaterialHeader(
                        valueColor:ColorTween(begin: Color(0xffff8080), end: Color(0xffff8080),)
                          .animate(controller)
                          ..addListener((){
                            setState(() {});
                          })
                      ),
                      footer: MaterialFooter(
                        valueColor:ColorTween(begin: Color(0xffff8080), end: Color(0xffff8080),)
                          .animate(controller)
                          ..addListener((){
                            setState(() {});
                          })
                      ),
                      onRefresh: () async {
                        await Future.delayed(Duration(seconds: 0), () async {
                          // print('-------------下拉刷新----------------');
                          // 每次刷新都从新获取一下本地存储的,防止用户改变了城市
                          var newadCode = await PublicStorage.getHistoryList('LocationCityCode');
                          var newLatLng = await PublicStorage.getHistoryList('LocationLatLng');
                          var lat = newLatLng[0][0].toString();
                          var lng = newLatLng[0][1].toString();
                          var now = new DateTime.now();
                          print('--------------新的时间------------');
                          print(now);
                          print(locationBool);
                          if(locationBool){
                            setState(() {
                                refreshData = {
                                'page': page,
                                'pagesize': 8,
                                'time': stampTime(now),
                                'condition': 'refresh',
                                'adcode': newadCode[0],
                                'lat': lat.substring(lat.indexOf(' ') + 1),
                                'lng': lng.substring(lat.indexOf(' ') + 2),
                              };
                            });
                          }
                          print(refreshData);

                          setState((){
                            refreshData['page'] = 1;
                            refreshData['time'] = stampTime(now);
                            refreshData['adcode'] = newadCode[0];
                            refreshData['lat'] = lat.substring(lat.indexOf(' ') + 1);
                            refreshData['lng'] = lng.substring(lat.indexOf(' ') + 2);
                            refreshData['condition'] = val.condition;
                          });
                          
                            print('传输参数:${refreshData}');
                          _getData(formData: refreshData, typeOf:1);
                          _controller.resetLoadState();
                        });
                      },
                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 0), () async {
                          print('---------------------上拉加载--------------');
                          // 每次刷新都从新获取一下本地存储的
                          var newadCode = await PublicStorage.getHistoryList('LocationCityCode');
                          var newLatLng = await PublicStorage.getHistoryList('LocationLatLng');
                          var lat = newLatLng[0][0].toString();
                          var lng = newLatLng[0][1].toString();
                          setState(() {
                            refreshData['page']++;
                            refreshData['adcode'] = newadCode[0];
                            refreshData['lat'] = lat.substring(lat.indexOf(' ') + 1);
                            refreshData['lng'] = lng.substring(lat.indexOf(' ') + 2);
                            refreshData['condition'] = val.condition;
                          //  setadCode();
                          });
                          _getData(formData: refreshData, typeOf:2).then((val){
                            _controller.finishLoad(noMore:response.isEmpty,);
                          });
                          
                          
                          
                          
                        });
                      },
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // print('--------------下拉刷新上拉加载的内容-----------');
                              // print(index);
                              return DriverWidget(context, index);
                            },
                            childCount: data.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SubHeaderWidget(),
                  
                ],
              )
              );
            }
          },
        ));
  }

// 司机展示Widget
  Widget DriverWidget(context, index) {
    

    // 转换价钱
    transformPrice(double price) {
      print(price);
      return price;
    }

    return Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              // Map arr = {'title': data[index]['title'], 'isUserList': false};
              Map arguments = {
                'id': data[index]['id'],
                'isMe':false
              };
              Navigator.pushNamed(context, '/order_details', arguments:arguments );
            },
            child: AspectRatio(
              aspectRatio: 5.5 / 2,
              child: Container(
                  margin: EdgeInsets.only(bottom: ScreenAdapter.setWidth(20)),
                  padding: EdgeInsets.all(ScreenAdapter.setWidth(30)),
                  color: Colors.white,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex:1,
                            child: Text( data[index]['title'],style: TextStyle(
                                      fontSize: ScreenAdapter.setWidth(28)),
                                  overflow: TextOverflow.ellipsis,),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: ScreenAdapter.setWidth(200),
                            child: Text('${stampPrice(data[index]['price'])}', style: TextStyle(color: Color(0xffff8080), fontSize: ScreenAdapter.setWidth(28)),),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right:ScreenAdapter.setWidth(10)),
                            padding: EdgeInsets.symmetric(vertical:ScreenAdapter.setWidth(2), horizontal: ScreenAdapter.setWidth(20)),
                            child: Text('${data[index]['county']}', style: TextStyle(color:Colors.black54, fontSize: ScreenAdapter.size(23)),),
                            decoration: BoxDecoration(
                              color: Color(0xfff3f3f3),
                              borderRadius: BorderRadius.circular(3)
                            ),
                          ),
                          Container(
                            // height: ScreenAdapter.setHeight(30),
                            constraints: BoxConstraints(
                              minHeight: ScreenAdapter.setHeight(30)
                            ),
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(10)),
                            padding: EdgeInsets.symmetric(vertical:ScreenAdapter.setWidth(2), horizontal: ScreenAdapter.setWidth(20)),
                            child: Text('${transformDistance(data[index]['distance'])}', style: TextStyle(color:Colors.black54, fontSize: ScreenAdapter.size(23)),),
                            decoration: BoxDecoration(
                              color: Color(0xfff3f3f3),
                              borderRadius: BorderRadius.circular(3)
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(10)),
                            padding: EdgeInsets.symmetric(vertical:ScreenAdapter.setWidth(2), horizontal: ScreenAdapter.setWidth(20)),
                            child: Text('${data[index]['days']}天', style: TextStyle(color:Colors.black54, fontSize: ScreenAdapter.size(23)),),
                            decoration: BoxDecoration(
                              color: Color(0xfff3f3f3),
                              borderRadius: BorderRadius.circular(3)
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(10)),
                            padding: EdgeInsets.symmetric(vertical:ScreenAdapter.setWidth(2), horizontal: ScreenAdapter.setWidth(22)),
                            child: Text.rich(TextSpan(
                            style: TextStyle(
                                  fontSize: ScreenAdapter.size(23),
                                  color: Colors.black54),
                                    children: [
                                    TextSpan(
                                      text: '剩余',
                                    ),
                                    TextSpan(
                                      text: '${data[index]['surplus_quota']}',
                                      style: TextStyle(
                                          color: Color(0xffff8080)),
                                    ),
                                    TextSpan(
                                      text: '个名额',
                                    )
                                  ])
                                  ),
                            decoration: BoxDecoration(
                              color: Color(0xfff3f3f3),
                              borderRadius: BorderRadius.circular(3)
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: ScreenAdapter.setWidth(50),
                            child: AspectRatio(
                              aspectRatio: 1/1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FadeInImage.memoryNetwork(placeholder:kTransparentImage , image: '$base_url${data[index]['head_pic']}'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenAdapter.setWidth(10),
                          ),
                          Text('${data[index]['nickname']}', style: TextStyle(color: Colors.black54, fontSize: ScreenAdapter.size(30)),)
                        ],
                      )
                    ],
                  )
                  
                  //  Stack(
                  //   children: <Widget>[
                  //     Align(
                  //         alignment: Alignment.topLeft,
                  //         child: Column(
                  //           children: <Widget>[
                  //             Container(
                  //               width: ScreenAdapter.setWidth(350),
                  //               child: Text(
                  //                 data[index]['title'],
                  //                 style: TextStyle(
                  //                     fontSize: ScreenAdapter.setWidth(35)),
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             ),
                  //             Row(
                  //               children: <Widget>[
                  //                 Icon(Icons.location_on,
                  //                     size: ScreenAdapter.setWidth(30),
                  //                     color: Colors.orangeAccent),
                  //                 Text(data[index]['county'])
                  //               ],
                  //             ),
                  //           ],
                  //         )),
                  //     Align(
                  //       alignment: Alignment.topRight,
                  //       child: Text(
                  //         // '￥${transformPrice(double.parse(value['price']))}/天',
                  //         '${stampPrice(data[index]['price'])}',
                  //         style: TextStyle(
                  //             fontSize: ScreenAdapter.setWidth(35)),
                  //       ),
                  //     ),
                  //     Align(
                  //       alignment: Alignment.bottomLeft,
                  //       child: Container(
                  //               width: ScreenAdapter.setWidth(350),
                  //               margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  //               child: Text(
                  //                 '联系人：${data[index]['nickname']}',
                  //               ),
                  //             ),
                        
                        
                  //     ),
                  //     // Align(
                  //     //   alignment: Alignment.bottomRight,
                  //     //   child:
                  //     //       Text('${Plugins.timeStamp(int.parse(data[index]['release_time']))}'),
                  //     // ),
                  //   ],
                  // )),
            ),
          ))
        ],
    );
  }
  
  
  // 当前时间转时间戳
  stampTime(DateTime now) {
    return now.millisecondsSinceEpoch.toString().substring(0, 10);
  }

  stampPrice(price){
    return price.toStringAsFixed(2);
  }

  
  // 转换距离
  transformDistance(result) {
    // var distance = double.parse(result.toStringAsFixed(2));
    print(result);
    // print(distance);
    if (result > 1000) {
      return (result / 1000).toStringAsFixed(2) + 'km';
    } else {
      return result.toStringAsFixed(0) + 'm';
    }
  }
  
}
