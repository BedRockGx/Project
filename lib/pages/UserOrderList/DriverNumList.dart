import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/RadiusImage.dart';
import 'package:project/plugins/ScreenAdapter.dart';

class DriverNumList extends StatefulWidget {
  final Map arguments;
  DriverNumList(this.arguments);
  @override
  _DriverNumListState createState() => _DriverNumListState(this.arguments);
}

class _DriverNumListState extends State<DriverNumList> with TickerProviderStateMixin{
  final Map arguments;
  _DriverNumListState(this.arguments);

  EasyRefreshController _controller; // 下拉刷新
  var refreshData, response, id;
  var data = [];
  var base_url = 'https://flutter.ikuer.cn';
  var api = new Api();
  AnimationController controller ;     // 动画控制器

  @override
  void initState() {
    super.initState();
    id = arguments['id'];
    print('传入进来的参数：${arguments}');
    _controller = EasyRefreshController(); // 下拉刷新
    controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);    // 添加动画控制器
    var now = new DateTime.now();
    refreshData = {'task_id': id, 'time': now, 'page': 1, 'pagesize': 8};
  }

  _getData({formData, typeOf}) {
    // print('----------------传入进来的参数--------------');
    // print(formData);
    api.getData(context, 'taskDrivers', formData: formData).then((val) {
      if (val.toString() == '[]') {
        print('空数组');
        Fluttertoast.showToast(msg: '还没有司机申请，再等等哦~');
        return;
      }
      response = json.decode(val.toString());
      print(response);
      if (typeOf == 1) {
        if (response.isEmpty) {
          Fluttertoast.showToast(msg: '没有最新的数据！快去发布吧!');
        }
        setState(() {
          data = response;
        });
      } else {
        if (response.isEmpty) {
          Fluttertoast.showToast(msg: '已经到底了！');
        }
        setState(() {
          data.addAll(response);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(IconData(0xe622, fontFamily: 'myIcon'),
                size: ScreenAdapter.size(40)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('司机申请列表',style: TextStyle(fontSize: ScreenAdapter.size(35))),
          centerTitle: true,
          elevation: 0,
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Container(
            // margin: EdgeInsets.only(top: ScreenAdapter.setHeight(10)),
            color: Color.fromRGBO(233, 233, 233, 0.7),
            child: EasyRefresh.custom(
              enableControlFinishRefresh: false,
              enableControlFinishLoad: true,
              controller: _controller,
              firstRefresh: true,
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
                await Future.delayed(Duration(seconds: 1), () {
                  print('--------------下拉刷新-------');
                  var now = new DateTime.now();
                  setState(() {
                    refreshData['page'] = 1;
                    refreshData['time'] = Plugins.stampTime(now);
                  });
                  print(refreshData);
                  _getData(formData: refreshData, typeOf: 1);
                  _controller.resetLoadState();
                });
              },
              onLoad: () async {
                await Future.delayed(Duration(seconds: 1), () {
                  print('-----上拉加载------');
                  setState(() {
                    refreshData['page']++;
                    //  setadCode();
                  });
                  _getData(formData: refreshData, typeOf: 2);
                  _controller.finishLoad(
                    noMore: response.isEmpty,
                  );
                });
              },
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return DrividerList(context, index);
                      // EvaluatLayout(context, index);
                    },
                    childCount: data.length,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget DrividerList(context, index) {
    // arguments['status'] = 5;
    // data[index]['employer_appraise_status'] = 0;
    // data[index]['status'] = 1;
    // print(arguments['status']);
    // print(data[index]['employer_appraise_status']);
    // print(data[index]['status']);
    // print(data[index]['status'] != 2 &&
    //     ((arguments['status'] < 3 ||
    //             data[index]['employer_appraise_status'] != 0) ||
    //         (data[index]['employer_appraise_status'] != 0 &&
    //             data[index]['status'] != 2)));
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
              vertical: ScreenAdapter.setHeight(15),
              horizontal: ScreenAdapter.setWidth(30)),
          padding: EdgeInsets.symmetric(vertical: ScreenAdapter.setWidth(20)),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenAdapter.setWidth(30)),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.timer,
                        size: ScreenAdapter.size(40), color: Colors.grey),
                    SizedBox(
                      width: ScreenAdapter.setWidth(3),
                    ),
                    Text(
                      '${Plugins.datetimeStamp(int.parse(data[index]['apply_time']))}',
                      style: TextStyle(color: Colors.grey, fontSize: ScreenAdapter.size(30)),
                    ),
                  ],
                ),
              ),
              
              Container(
                width: double.infinity,
                height: ScreenAdapter.setHeight(0.5),
                margin:
                    EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(5)),
                color: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenAdapter.setWidth(20)),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenAdapter.setWidth(15)),
                      child: Row(
                        children: <Widget>[
                          ImageRadius(
                              '$base_url${data[index]['head_pic']}', 120, 120),
                          SizedBox(
                            width: ScreenAdapter.setWidth(20),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              // height: ScreenAdapter.setHeight(100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${data[index]['nickname']}',
                                    style: TextStyle(
                                        fontSize: ScreenAdapter.size(30)),
                                  ),
                                  SizedBox(
                                    height: ScreenAdapter.setHeight(5),
                                  ),
                                  Icon(
                                    IconData(0xe625, fontFamily: 'myIcon'),
                                    color: Color(0xffE16A28),
                                    size: ScreenAdapter.size(35),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // 任务状态不为0，申请状态为1和2的时候显示【立即沟通】显示状态信息
                          (data[index]['status'] == 1 ||
                                      arguments['status'] != 0) ||
                                  (data[index]['status'] == 2 &&
                                      arguments['status'] != 0)
                              ? InkWell(
                                  onTap: () {
                                    Map arguments = {
                                      'nickname': data[index]['nickname'],
                                      'head_pic': data[index]['head_pic'],
                                      'isVip':false
                                    };
                                    Navigator.pushNamed(context, '/chatPage',
                                        arguments: arguments);
                                  },
                                  child: Container(
                                    width: ScreenAdapter.setWidth(120),
                                    height: ScreenAdapter.setHeight(50),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Color(0xffff8080),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Text(
                                      '沟通',
                                      style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(30)),
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Text(''),
                                )
                        ],
                      ),
                    ),
                    
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '成交笔数：${(data[index]['driver_order_num'])}',
                                style: TextStyle(
                                    fontSize: ScreenAdapter.size(30),
                                    color: Colors.black38),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                  '信誉度：${data[index]['driver_reputation']}%',
                                  style: TextStyle(
                                      fontSize: ScreenAdapter.size(30),
                                      color: Colors.black38)),
                            ),
                          )
                        ],
                      ),
                      margin: EdgeInsets.symmetric(
                          vertical: ScreenAdapter.setHeight(10)),
                    ),

                    // 建立在不是审核中的基础上来判断： （任务状态没有结束或者没有评价）或者（申请状态只要不是审核中或者没有评价）
                    data[index]['status'] != 2 &&
                            ((arguments['status'] < 3 ||
                                    data[index]['employer_appraise_status'] !=
                                        0) ||
                                (data[index]['employer_appraise_status'] != 0 &&
                                    data[index]['status'] != 2))
                        ? Container(
                            margin: EdgeInsets.only(top: ScreenAdapter.setHeight(5), bottom: ScreenAdapter.setWidth(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${statusText(data[index]['status'])}',
                                  style: TextStyle(
                                      color: statusTextStyle(
                                          data[index]['status']), fontSize: ScreenAdapter.size(30)),
                                ),
                              ],
                            ))
                        :
                        // 如果是申请状态为2(审核中)的时候，才能显示确定和拒绝
                        data[index]['status'] == 2
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: ScreenAdapter.setWidth(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        api.putData(context, 'applyAgree',
                                            formData: {
                                              'apply_id': data[index]['id'],
                                              'task_id': id
                                            }).then((val) {
                                          if (val == null) {
                                            return;
                                          }
                                          var response =
                                              json.decode(val.toString());
                                          Fluttertoast.showToast(
                                              msg: response['msg']);
                                          _controller.callRefresh();
                                        });
                                      },
                                      child: Container(
                                        width: ScreenAdapter.setWidth(260),
                                        height: ScreenAdapter.setHeight(50),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Color(0xffff8080),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Text(
                                          '同意',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        api.putData(context, 'applyRefuse',
                                            formData: {
                                              'apply_id': data[index]['id'],
                                              'task_id': id
                                            }).then((val) {
                                          if (val == null) {
                                            return;
                                          }
                                          var response =
                                              json.decode(val.toString());
                                          Fluttertoast.showToast(
                                              msg: response['msg']);
                                          _controller.callRefresh();
                                        });
                                      },
                                      child: Container(
                                        width: ScreenAdapter.setWidth(260),
                                        height: ScreenAdapter.setHeight(50),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            // color: Color(0xffff8080),
                                            border: Border.all(
                                                width:
                                                    ScreenAdapter.setWidth(1),
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Text(
                                          '拒绝',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            :
                            // 如果任务已经结束，并且进入结束后的阶段，同时未评价的话显示评价按钮
                            arguments['status'] >= 3 &&
                                    data[index]['employer_appraise_status'] == 0
                                ? InkWell(
                                    onTap: () {
                                      Map arguments = {
                                        'id': data[index]['id'],
                                        'user_id': data[index]['user_id'],
                                        'isDivider': false,
                                      };
                                      Navigator.pushNamed(context, '/evaluate',
                                              arguments: arguments)
                                          .then((val) {
                                        _controller.callRefresh();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(
                                          ScreenAdapter.setWidth(15)),
                                      width: ScreenAdapter.setWidth(260),
                                      height: ScreenAdapter.setHeight(50),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Color(0xffff8080),
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Text(
                                        '评价',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: Text('111'),
                                  )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  statusText(status) {
    switch (status) {
      case 0:
        return '已拒绝';
        break;
      case 1:
        return '已同意';
        break;
      case 2:
        return '审核中';
        break;
      case 3:
        return '已失效';
        break;
      default:
    }
  }

  statusTextStyle(status) {
    switch (status) {
      case 0:
        return Colors.black54;
        break;
      case 1:
        return Colors.red;
        break;
      case 3:
        return Colors.grey;
        break;
      default:
    }
  }
}
