import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/provide/HomeProvide.dart';
import 'package:provide/provide.dart';
import 'package:project/plugins/alertDialog.dart';


class UserOrderList extends StatefulWidget {
  List<Map> data;
  UserOrderList(this.data);
  @override
  _UserOrderListState createState() => _UserOrderListState(this.data);
}

class _UserOrderListState extends State<UserOrderList> with TickerProviderStateMixin{

  List<Map> arr;
  _UserOrderListState(this.arr);
  

  EasyRefreshController _controller;            // 下拉刷新
  String ratingValue ;                          // 评分
  var api = new Api();
  var refreshData,response;
  var data = [];
  var visible = false;
  AnimationController controller ;     // 动画控制器

  

  @override
  void initState() { 
    super.initState();
    _controller = EasyRefreshController();            // 下拉刷新
    controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);    // 添加动画控制器
    var now = new DateTime.now();
    refreshData = {
       'time':now,
       'condition':'all',
       'page':1,
       'pagesize':8
    };
  }


  // 为了达到如果没有了数据取消上拉加载的效果，写成异步的形势，只有当请求完毕后，才会判断是否关闭上拉加载
  Future _getData({formData, typeOf}) async {
    print('----------------传入进来的参数--------------');
    print(formData);
    await api.getData(context, 'taskListAll', formData:formData).then((val){
      response = json.decode(val.toString());
      
      print('返回数据：$response');
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
        leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
        title: Text('${widget.data[0]['title']}列表',style: TextStyle(fontSize: ScreenAdapter.size(35))),
        centerTitle: true,
        elevation: 0,
      ),
      body: Provide<HomeProvide>(
        builder: (context, child, val){
          return ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(
              // margin: EdgeInsets.only(top: ScreenAdapter.setHeight(10)),
              color: Color.fromRGBO(233, 233, 233, 0.7),
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
                  await Future.delayed(Duration(seconds: 1), () {
                    print('--------------下拉刷新-------');
                    var now = new DateTime.now();
                    setState((){
                        refreshData['page'] = 1;
                        refreshData['time'] = stampTime(now);
                        refreshData['condition'] = val.condition;
                      });
                    _getData(formData: refreshData, typeOf: 1);
                    _controller.resetLoadState();
                  });
                },
                onLoad: () async {
                  await Future.delayed(Duration(seconds: 1), () {
                    print('-----上拉加载------');
                    setState(() {
                      refreshData['page']++;
                      refreshData['condition'] = val.condition;
                    //  setadCode();
                    });
                    _getData(formData: refreshData, typeOf: 2).then((_)=>{
                      _controller.finishLoad(noMore:response.isEmpty)
                    });
                    
                  });
                },
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return judge(widget.data[0]['state'],index);
                        // EvaluatLayout(context, index);
                      },
                      childCount: data.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }

   Widget judge(int state, index){
    return InkWell(
            child: EvaluatLayout(context, index),
            onTap: (){
              Map arguments = {
                'id': data[index]['id'],
                'isMe':true,
                'status':data[index]['status']
              };
              Navigator.pushNamed(context, '/order_details', arguments:arguments);
            },
          );
  }


Widget EvaluatLayout(context, index){
    return Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(ScreenAdapter.setHeight(15)),
                child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.timer, size: ScreenAdapter.size(30),color: Colors.grey),
                            SizedBox(width: ScreenAdapter.setWidth(3),),
                            Text('${Plugins.timeStamp(int.parse(data[index]['release_time']))}', style: TextStyle(color: Colors.grey, fontSize: ScreenAdapter.size(30)),),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(ScreenAdapter.setWidth(10)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text('${statusText(data[index]['status'])}',style: TextStyle(color: statusTextStyle(data[index]['status']), fontSize: ScreenAdapter.size(30)),),
                                    ),
                                  ],
                                )
                              ),
                          ],
                        ),
                        SizedBox(height: ScreenAdapter.setHeight(20),),
                        Container(
                          child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          // margin: EdgeInsets.only(left: ScreenAdapter.setWidth(10)),
                                          width: ScreenAdapter.setWidth(600),
                                          child: Text('${data[index]['title']}',maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ScreenAdapter.size(35)),),
                                        )
                                      ],
                                    )
                                  ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: IconButton(
                                  //     icon: Icon(Icons.more_horiz),
                                  //     onPressed: (){
                                  //       setState(() {
                                  //         visible = ! visible;
                                  //       });
                                  //     },
                                  //   ),
                                  // )
                                ],
                              ),
                        ),
                        SizedBox(height: ScreenAdapter.setHeight(20)),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Text('¥${data[index]['total']}', style: TextStyle( color: Colors.grey, fontSize: ScreenAdapter.size(30)),)
                              ),
                            ),
                            Align(
                                  alignment: Alignment.bottomRight,
                                  child:Container(
                                        margin: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            // statusButon(data[index]['status']),
                                            Container(
                                              // width: ScreenAdapter.setWidth(180),
                                              height: ScreenAdapter.setHeight(50),
                                              child: data[index]['status'] == 0 ||data[index]['status'] == 3 ||data[index]['status'] == 4 ? Text('') :
                                              
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    // width: ScreenAdapter.setWidth(120),
                                                    // height: ScreenAdapter.setHeight(50),
                                                    child: RaisedButton(
                                                      child: Text('${statusButonText(data[index]['status'])}', style: TextStyle(fontSize: ScreenAdapter.size(25)),),
                                                      color: Color(0xffff8080),
                                                      textColor: Colors.white,
                                                      elevation: 0,
                                                      onPressed: statusButtonFunction(data[index]['status'], data[index]['id']),
                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(20)),
                                                    ),
                                                  ),
                                                  SizedBox(width: ScreenAdapter.setWidth(10),),
                                                  data[index]['status'] == 1 ?
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        // width: ScreenAdapter.setWidth(120),
                                                        // height: ScreenAdapter.setHeight(50),
                                                        child: OutlineButton(
                                                          child: Text('取消任务', style: TextStyle(fontSize: ScreenAdapter.size(25)),),
                                                          onPressed: (){
                                                            alertDialog(context, '提示', '您确定要取消吗？', (){
                                                              print('取消任务');
                                                              print(data[index]['id']);
                                                              var id = data[index]['id'];
                                                              api.putData(context, 'taskCancel', formData: {'task_id':id}).then((val){
                                                                if(val == null){
                                                                  return;
                                                                }
                                                                var response = json.decode(val.toString());
                                                                Fluttertoast.showToast(msg: response['msg']);
                                                                Navigator.pop(context);
                                                                _controller.callRefresh();
                                                              });
                                                            });
                                                          },
                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(20)),
                                                        ),
                                                      ),
                                                      SizedBox(width: ScreenAdapter.setWidth(10),),
                                                      Container(
                                                        // width: ScreenAdapter.setWidth(120),
                                                        // height: ScreenAdapter.setHeight(50),
                                                        child: OutlineButton(
                                                          child: Text('刷新', style: TextStyle(fontSize: ScreenAdapter.size(25)),),
                                                          onPressed: (){
                                                            print('刷新');
                                                            print(data[index]['id']);
                                                            api.putData(context, 'taskRefresh', formData: {'task_id':data[index]['id']}).then((val){
                                                              if(val == null){
                                                                return;
                                                              }
                                                              var response = json.decode(val.toString());
                                                              Fluttertoast.showToast(msg: response['msg']);
                                                            });
                                                          },
                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(20)),
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   width: ScreenAdapter.setWidth(100),
                                                      //   height: ScreenAdapter.setHeight(50),
                                                      //   child: OutlineButton(
                                                      //     padding: EdgeInsets.all(5),
                                                      //     child: Text('刷新', style: TextStyle(fontSize: ScreenAdapter.size(23)),),
                                                      //     onPressed: (){

                                                      //     },
                                                      //     shape: RoundedRectangleBorder(
                                                      //                       borderRadius: BorderRadius.circular(20)),
                                                      //   ),
                                                      // )
                                                    ],
                                                  )
                                                  :Text('')
                                                ],
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              ),
              Visibility(
                visible: visible,
                child: Positioned(
                  top: ScreenAdapter.setHeight(80),
                  right: ScreenAdapter.setWidth(30),
                  child: Container(
                    width: ScreenAdapter.setWidth(150),
                    height: ScreenAdapter.setHeight(80),
                    color: Colors.orange,
                    child: Text('我是弹出来'),
                  ),
                ),
              )
            ],
          );
    
  }

  

  statusText(status){
    switch (status) {
      case 0:
        return '已失效';
        break;
      case 1:
        return '招募中';
        break;
      case 2:
        return '已开始';
        break;
      case 3:
        return '已完成';
        break;
      case 4:
        return '已结算';
        break;
      default:
    }
  }

  statusTextStyle(status){
    switch (status) {
      case 0:
        return Colors.grey;
        break;
      case 1:
        return Colors.blue;
        break;
      case 2:
        return Colors.green;
        break;
      case 3:
        return Colors.red;
        break;
      case 4:
        return Colors.orange;
        break;
      default:
    }
  }
  
                    
  statusButonText(status){
    switch (status) {
      case 0:
        return '已失效';
        break;
      case 1:
        return '开始任务';
        break;
      case 2:
        return '结束';
        break;
      case 3:
        return '等待发放佣金';
        break;
      default:
    }
  }

  statusButtonFunction(status, id){
    switch (status) {
      case 1:
        return (){
          print('开始任务');
          alertDialog(context, '提示', '您确定要开始吗？', (){
              api.putData(context, 'taskStart', formData: {'task_id':id}).then((val){
              if(val == null){
                return;
              }
              var response = json.decode(val.toString());
              Fluttertoast.showToast(msg: response['msg']);
              Navigator.pop(context);
              _controller.callRefresh();
            });
          });
          
        };
        break;
      case 2:
        return (){
          print('结束任务');
          alertDialog(context, '提示', '您确定要结束吗？', (){
            api.putData(context, 'taskEnd', formData: {'task_id':id}).then((val){
              if(val == null){
                return;
              }
              var response = json.decode(val.toString());
              Fluttertoast.showToast(msg: response['msg']);
              Navigator.pop(context);
              _controller.callRefresh();
            });
          });
          
        };
        break;
      case 3:
        return (){
          Fluttertoast.showToast(msg: '任务已完成，等待发放佣金');
        };
        break;
      default:
    }
  }

  // 当前时间转时间戳
  stampTime(DateTime now) {
    print('---------------------转换时间戳----------------------');
    print(now.millisecondsSinceEpoch);
    return now.millisecondsSinceEpoch.toString().substring(0, 10);
  }

}

