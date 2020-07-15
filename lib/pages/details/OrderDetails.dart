import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:project/plugins/RadiusImage.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/provide/SocketProvide.dart';
import 'package:provide/provide.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  final arguments;

  OrderDetails(this.arguments, {Key key}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState(arguments);
}

class _OrderDetailsState extends State<OrderDetails> {
  final arguments;
  _OrderDetailsState(this.arguments);

  var latLng, formData, id, isMe;
  var data = {};

  var api = new Api();
  var base_url = 'https://flutter.ikuer.cn/';

  @override
  void initState() {
    super.initState();
    // 获取传进来的Id
    id = arguments['id'];
    isMe = arguments['isMe'];
    print('页面加载！！！！');
    _getLocation().then((val) {
      print('获取数据！！！！！');
      print(val);
      var lat = latLng[0][0].toString();
      var lng = latLng[0][1].toString();
      formData = {
        'lat': lat.substring(lat.indexOf(' ') + 1),
        'lng': lng.substring(lat.indexOf(' ') + 2),
        'id': id
      };

      
      _getData(formData);
    });
  }

  _getData(formData) {
    print(formData);
    api.getData(context, 'orderDetails', formData: formData).then((val) {
      
      if (val == null) {
        return;
      }
      
      var response = json.decode(val.toString());
      setState(() {
        data = response;
      });
    });
  }

  Future _getLocation() async {
    // 获取当前地理位置
    latLng = await PublicStorage.getHistoryList('FixedLatLng');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
          // title: Container(
          //   child:  Text('订单详情',),
          // ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          child: data.toString() == '{}' ? Loading(text: '加载中') : ContentDetails(),
          color: Colors.white,
        )
      );
  }

  // 详情内容
  Widget ContentDetails() {
    return 
    Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom:arguments['identity'] != 1? ScreenAdapter.setWidth(160) : 0),
          child: ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child: ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(40)),
          // margin: EdgeInsets.only(bottom: ScreenAdapter.setWidth(100)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(20)),
                child: Text(
                  '${data['title']}',
                  style: TextStyle(
                      fontSize: ScreenAdapter.size(40),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right:ScreenAdapter.setWidth(20)),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            IconData(0xe620, fontFamily: 'myIcon'),
                            size: ScreenAdapter.size(30),
                            color: Colors.grey,
                          ),
                          SizedBox(width: ScreenAdapter.setWidth(5)),
                          Text(
                            '${transformDistance(data['distance'])}',
                            style: TextStyle(
                                fontSize: ScreenAdapter.size(25),
                                color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(20)),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(IconData(0xe61f, fontFamily: 'myIcon'), size: ScreenAdapter.size(30), color: Colors.grey,),
                          SizedBox(width: ScreenAdapter.setWidth(5)),
                          Text(
                            '${data['price']}/天',
                            style: TextStyle(
                                fontSize: ScreenAdapter.size(25),
                                color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(20)),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            IconData(0xe624, fontFamily: 'myIcon'),
                            size: ScreenAdapter.size(30),
                            color: Colors.grey,
                          ),
                          SizedBox(width: ScreenAdapter.setWidth(5)),
                          Text.rich(TextSpan(
                            style: TextStyle(
                                  fontSize: ScreenAdapter.size(25),
                                  color: Colors.grey),
                            children: [
                            TextSpan(
                              text: '剩余',
                            ),
                            TextSpan(
                              text: ' ${data['surplus_quota']} ',
                              style: TextStyle(
                                  fontSize: ScreenAdapter.size(30),
                                  color: Color(0xffff8080)),
                            ),
                            TextSpan(
                              text: '个名额',
                            )
                          ]))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              isMe
                  ? Text('')
                  : Column(
                      children: <Widget>[
                        Divider(
                          color: Colors.grey,
                        ),
                        Container(
                            width: double.infinity,
                            child: Row(
                              children: <Widget>[
                                ImageRadius(
                                    '$base_url${data['head_pic']}', 120, 120),
                                SizedBox(
                                  width: ScreenAdapter.setWidth(20),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                  height: ScreenAdapter.setHeight(100),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text('${data['nickname']}', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '成交笔数：${data['employer_order_num']}',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenAdapter.size(25),
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: ScreenAdapter.setWidth(20),
                                          ),
                                          Text(
                                            '好评率：${(data['employer_reputation'])}%',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenAdapter.size(25),
                                                color: Colors.grey),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                ),
                                InkWell(
                                  onTap: (){
                                     Map arguments = {
                                        'nickname':data['nickname'],
                                        'head_pic':data['head_pic'],
                                        'recv_id':data['user_id'],
                                        'isVip':false
                                      };
                                      Navigator.pushNamed(context, '/chatPage', arguments: arguments).then((val){
                                        Provide.value<SocketProvider>(context).clearRecords();
                                      });
                                  },
                                  child: Container(
                                    width: ScreenAdapter.setWidth(155),
                                    height: ScreenAdapter.setHeight(55),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xffff8080),
                                      borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: Text('立即沟通', style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(30)),),
                                  ),
                                )
                                 
                              ],
                            ))
                      ],
                    ),

              
              Divider(
                color: Colors.grey,
              ),
              Container(
                height: ScreenAdapter.setHeight(400),
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '任务详情',
                      style: TextStyle(fontSize: ScreenAdapter.size(35)),
                    ),
                    SizedBox(
                      height: ScreenAdapter.setHeight(20),
                    ),
                    Scrollbar(
                      child: Text(
                        '${data['content']}',
                        style: TextStyle(
                            fontSize: ScreenAdapter.size(30),
                            color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
              // Divider(color: Colors.grey,),
              Container(
                // color: Colors.greenAccent,
                // height: ScreenAdapter.setHeight(400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    OrderWidget('任务周期：',
                        '${Plugins.timeStamp(int.parse(data['start_date']))} 至 ${Plugins.timeStamp(int.parse(data['end_date']))}'),
                    OrderWidget('招募人数：', '${data['driver_num']}人'),
                    OrderWidget('总计薪酬：', '¥${totalFn(data['total'])}'),
                    OrderWidget('地址：', '${data['position_addr']}'),
                    OrderWidget('详细地址：', '${data['addr']}'),
                    OrderWidget('发布时间：',
                        '${Plugins.timeStamp(int.parse(data['release_time']))}'),
                    Row(
                      children: <Widget>[
                        Container(
                          width: ScreenAdapter.setWidth(165),
                          child: Text(
                            '地图导航：',
                            style: TextStyle(fontSize: ScreenAdapter.size(30)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child:Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                child: ImageRadius('assets/images/map.png', 120, 120, isAssets: true,),
                                onTap: (){
                                  Plugins.gaodeMap(data['lat'], data['lng']);
                                },
                              )
                            ],
                          )
                        )
                      ],
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        )
      ],
    )
        ),
        ),
        arguments['identity'] != 1?
        Positioned(
          bottom: 0,
          width: ScreenAdapter.setWidth(750),
          height: ScreenAdapter.setHeight(120),
          child: Container(
            color: Colors.white,
            child:  Row(
              children: <Widget>[
                isMe  
                        ? Expanded(
                            flex: 1,
                            child: BottomWidget(
                                '司机申请列表', Color(0xffff8080), () {
                              // Map arguments = {
                              //   'id':id,
                              // };
                              Navigator.pushNamed(context, '/driverList',
                                      arguments: arguments)
                                  .then((val) {
                                var lat = latLng[0][0].toString();
                                var lng = latLng[0][1].toString();
                                formData = {
                                  'lat': lat.substring(lat.indexOf(' ') + 1),
                                  'lng': lng.substring(lat.indexOf(' ') + 2),
                                  'id': id
                                };
                                _getData(formData);
                              });
                            }))
                        : Expanded(
                            flex: 1,
                            child: BottomWidget(
                                '申请任务', Color(0xffff8080),  () {
                              api.getData(context, 'applyOrder',
                                  formData: {'id': id}).then((val) {
                                if (val == null) {
                                  return;
                                }
                                var msg = json.decode(val.toString());
                                Fluttertoast.showToast(msg: msg['msg']);
                                Navigator.pop(context);
                              });
                            })),
              ],
            ),
          )
         
        )
        :
        Container(child: Text(''),)
      ],
    );
    //将ListView用ScrollConfiguration包裹
      
  }

  Widget OrderWidget(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom:ScreenAdapter.setHeight(45)),
      child: Row(
      children: <Widget>[
        Container(
          width: ScreenAdapter.setWidth(165),
          child: Text(
            '$title',
            style: TextStyle(fontSize: ScreenAdapter.size(30)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '$content',
            style:
                TextStyle(fontSize: ScreenAdapter.size(30), color: Colors.black54),
          ),
        )
      ],
    )
    );
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

  // 拨打电话
  _launchURL() async {
    String url = 'tel:' + '18369665635';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 公用按钮控件
  Widget BottomWidget(String title, Color color, Function fn) {
    return InkWell(
        child: Container(
          margin: EdgeInsets.all(ScreenAdapter.setWidth(20)),
          height: ScreenAdapter.setHeight(70),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(30)),
          ),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20)),
        ),
        onTap: fn);
  }

  totalFn(n){
    return n.toStringAsFixed(2);
    // return '123';
  }
}
