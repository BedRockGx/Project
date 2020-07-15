import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/api.dart';
import 'package:project/config/api_url.dart';
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

class RegisterPage extends StatefulWidget {
  final arguments;
  RegisterPage(this.arguments);
  
  @override
  _RegisterPageState createState() => _RegisterPageState(this.arguments);
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin{
  final arguments;
  _RegisterPageState(this.arguments);
  // 控制刷新
  EasyRefreshController _controller;

  var api = new Api();

  var data = [];
  var page = 1;     // 第几页
  var city; // 获取本地存储中的城市，是否有值，如果没有定位就不显示内容
  var adCode, latLng;
  // 时间，请求参数，返回参数，请求条件
  var now, refreshData, response ,provide;
  AnimationController controller ;     // 动画控制器

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);    // 添加动画控制器
    _getLocation().then((val){
       now = new DateTime.now();

        var lat = latLng[0][0].toString();
        var lng = latLng[0][1].toString();
        refreshData = {
          'page': page,
          'pagesize': 8,
          'time': arguments['now'],
          'adcode': arguments['adcode'],
          'keyword':arguments['keyword'],
          'lat': lat.substring(lat.indexOf(' ') + 1),
          'lng': lng.substring(lat.indexOf(' ') + 2),
        };
    });
   
    
    
  }

  _getData({formData, typeOf}) {
    print('-----------------传入参数----------------');
    print(formData);
    api.getData(context, 'search', formData: formData).then((val) {
      // print('返回数据：${json.decode(val.toString())}');
      response = json.decode(val.toString());
      
      /*
        避免切换城市之后，数据没有刷新的问题：
        1:下拉刷新的情况 才会触发，新来的数据，会替换掉旧的数据
        2.上拉加载的情况 才会触发，新来的数据，会添加到旧数据之后
      */
      if(typeOf == 1){
        if(response.isEmpty){
          Fluttertoast.showToast(msg: '没有搜索到哦，快去发布一个吧');
        }
        setState(() {
          data = response;
        });
      }else{
        if(response.isEmpty){
          Fluttertoast.showToast(msg: '已经到底了！');
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
        appBar: AppBar(
          leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
          title: Container(
            child:  Text('搜索结果',style: TextStyle(fontSize: ScreenAdapter.size(35))),
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: Provide<UserInfomation>(
          builder: (context, child, val) {
            
            if (val.city == '未定位') {
              return Loading(text: '请允许定位请求');
            } else {
              return Stack(
                children: <Widget>[
                  Container(
                    color: Color.fromRGBO(245, 245, 246, 1),
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
                          setState((){
                            refreshData['page'] = 1;
                            refreshData['time'] = stampTime(now);
                            refreshData['adcode'] = newadCode[0];
                            refreshData['lat'] = lat.substring(lat.indexOf(' ') + 1);
                            refreshData['lng'] = lng.substring(lat.indexOf(' ') + 2);
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
                          _getData(formData: refreshData, typeOf:2);
                          _controller.finishLoad(noMore:response.isEmpty,);
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
                ],
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
  
  

//  司机展示Widget
//   Widget DriverWidget(context, index) {
    

//     // 转换价钱
//     transformPrice(double price) {
//       print(price);
//       return price;
//     }

//     return Column(
//         children: <Widget>[
//           InkWell(
//             onTap: () {
//               // Map arr = {'title': data[index]['title'], 'isUserList': false};
//               Map arguments = {
//                 'id': data[index]['id'],
//                 'isMe':false
//               };
//               Navigator.pushNamed(context, '/order_details', arguments:arguments );
//             },
//             child: AspectRatio(
//               aspectRatio: 3 / 1,
//               child: Container(
//                   margin: EdgeInsets.only(bottom: ScreenAdapter.setWidth(20)),
//                   padding: EdgeInsets.all(ScreenAdapter.setWidth(30)),
//                   color: Colors.white,
//                   child: Stack(
//                     children: <Widget>[
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: Column(
//                             children: <Widget>[
//                               Container(
//                                 width: ScreenAdapter.setWidth(350),
//                                 child: Text(
//                                   data[index]['title'],
//                                   style: TextStyle(
//                                       fontSize: ScreenAdapter.setWidth(35),
//                                       fontWeight: FontWeight.bold),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 width: ScreenAdapter.setWidth(350),
//                                 margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                                 child: Text(
//                                   '联系人：${data[index]['nickname']}',
//                                 ),
//                               ),
//                             ],
//                           )),
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: Text(
//                           // '￥${transformPrice(double.parse(value['price']))}/天',
//                           '￥${data[index]['price']}/天',
//                           style: TextStyle(
//                               fontSize: ScreenAdapter.setWidth(35),
//                               color: Colors.lightBlue,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Row(
//                           children: <Widget>[
//                             Icon(Icons.location_on,
//                                 size: ScreenAdapter.setWidth(30),
//                                 color: Colors.orangeAccent),
//                             Text(data[index]['county'])
//                           ],
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child:
//                             Text('${Plugins.timeStamp(int.parse(data[index]['release_time']))}'),
//                       ),
//                     ],
//                   )),
//             ),
//           )
//         ],
//     );
//   }
 
 
//
 
  // 当前时间转时间戳
  stampTime(DateTime now) {
    print('---------------------转换时间戳----------------------');
    print(now.millisecondsSinceEpoch);
    return now.millisecondsSinceEpoch.toString().substring(0, 10);
  }

  // 转换时间 
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
