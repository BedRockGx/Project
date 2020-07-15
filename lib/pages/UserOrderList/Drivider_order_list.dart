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


class DirividerOrderList extends StatefulWidget {
  List<Map> data;
  DirividerOrderList(this.data);
  @override
  _DirividerOrderListState createState() => _DirividerOrderListState(this.data);
}

class _DirividerOrderListState extends State<DirividerOrderList> with TickerProviderStateMixin{

  List<Map> arr;
  _DirividerOrderListState(this.arr);
  

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

  Future _getData({formData, typeOf}) async {
    print('----------------传入进来的参数--------------');
    print(formData);
    await api.getData(context, 'applyListAll', formData:formData).then((val){
      response = json.decode(val.toString());
      print('返回数据-------------');
      print(response);
      if(typeOf == 1){
        if(response.isEmpty){
          Fluttertoast.showToast(msg: '没有最新的数据！快去申请吧!');
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
                        refreshData['condition'] = val.conditionDivider;
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
                      refreshData['condition'] = val.conditionDivider;
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
                'id': data[index]['task_id'],
                'isMe':true,
                'status':data[index]['apply_status'],
                'identity':1            // 司机身份不能查看司机列表，只能查看订单
              };
              print(arguments);
              Navigator.pushNamed(context, '/order_details', arguments:arguments);
            },
          );
  }


Widget EvaluatLayout(context, index){
    return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
                    padding: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.timer, size: ScreenAdapter.size(30),color: Colors.grey),
                            SizedBox(width: ScreenAdapter.setWidth(3),),
                            Text('${Plugins.timeStamp(int.parse(data[index]['apply_time']))}', style: TextStyle(color: Colors.grey, fontSize: ScreenAdapter.size(25)),),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(ScreenAdapter.setWidth(5)),
                                      child: Text.rich(
                                        TextSpan(
                                          style: TextStyle(fontSize: ScreenAdapter.size(25), color: Colors.grey),
                                          children: [
                                            TextSpan(text: '您的申请：'),
                                            TextSpan(
                                              text: '${statusText(data[index]['apply_status'])}',
                                              style: TextStyle(color: statusTextStyle(data[index]['apply_status']), )
                                            )
                                          ]
                                        )
                                      )
                                    ),
                                   Container(
                                      padding: EdgeInsets.all(ScreenAdapter.setWidth(5)),
                                      
                                      child: Text.rich(
                                        TextSpan(
                                          style: TextStyle(fontSize: ScreenAdapter.size(25), color: Colors.grey),
                                          children: [
                                            TextSpan(text: '任务状态：'),
                                            TextSpan(
                                              text: '${task_statusText(data[index]['task_status'])}',
                                              style: TextStyle(color: task_statusTextStyle(data[index]['task_status']), )
                                            )
                                          ]
                                        )
                                      )
                                      
                                    ),
                                ],
                              ),
                            )
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
                                          child: Text('${data[index]['title']}',maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                                        )
                                      ],
                                    )
                                  ),
                                  
                                ],
                              ),
                        ),
                        SizedBox(height: ScreenAdapter.setHeight(20)),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Text('¥${data[index]['total']}', style: TextStyle(color: Colors.grey, fontSize: ScreenAdapter.size(30)),)
                              ),
                            ),
                            Align(
                                  alignment: Alignment.bottomRight,
                                  child:Container(
                                          margin: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              data[index]['task_status'] >= 3 && data[index]['driver_appraise_status'] == 0 ? 
                                              Container(
                                                width: ScreenAdapter.setWidth(120),
                                                height: ScreenAdapter.setHeight(50),
                                                child: RaisedButton(
                                                  padding: EdgeInsets.all(5),
                                                  color: Color(0xffff8080),
                                                  
                                                  child: Text('评价', style: TextStyle(color:Colors.white,fontSize: ScreenAdapter.size(25)),),
                                                  onPressed: (){
                                                    Map arguments = {
                                                      'id':data[index]['task_id'],
                                                      'user_id':data[index]['employer_id'],
                                                      'isDivider':true,
                                                    };
                                                    Navigator.pushNamed(context, '/evaluate', arguments: arguments).then((val){
                                                      _controller.callRefresh();
                                                    });
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(20)),
                                                ),
                                              )
                                              :Text(''),

                                              data[index]['task_status'] == 1 && (data[index]['apply_status'] == 1 || data[index]['apply_status'] == 2) ? 
                                              Container(
                                                width: ScreenAdapter.setWidth(150),
                                                height: ScreenAdapter.setHeight(60),
                                                child: OutlineButton(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text('撤销申请', style: TextStyle(fontSize: ScreenAdapter.size(23)),),
                                                  onPressed: (){
                                                    alertDialog(context, '提示', '您确定要撤销吗？', (){
                                                        api.putData(context, 'applyDividerCancel', formData: {'apply_id':data[index]['apply_id']}).then((val){
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
                                              ):Text('')
                                              // statusButon(data[index]['status']),
                                              // Container(
                                              //   // width: ScreenAdapter.setWidth(180),
                                              //   height: ScreenAdapter.setHeight(50),
                                              //   child: data[index]['status'] == 0 ||data[index]['status'] == 5 ? Text('') :
                                              //   Row(
                                              //     children: <Widget>[
                                              //       data[index]['task_status'] >=3 && data[index]['driver_appraise_status'] == 0 ?  
                                              //       Container(
                                              //         width: ScreenAdapter.setWidth(120),
                                              //         height: ScreenAdapter.setHeight(50),
                                              //         child: OutlineButton(
                                              //           padding: EdgeInsets.all(5),
                                              //           child: Text('评价', style: TextStyle(fontSize: ScreenAdapter.size(25)),),
                                              //           // color: Theme.of(context).primaryColor,
                                              //           // textColor: Colors.white,
                                              //           onPressed: (){
                                              //             Map arguments = {
                                              //               'id':data[index]['employer_id'],
                                              //               'isDivider':true,
                                              //             };
                                              //             Navigator.pushNamed(context, '/evaluate', arguments: arguments).then((val){
                                              //               _controller.callRefresh();
                                              //             });
                                              //           },
                                              //           shape: RoundedRectangleBorder(
                                              //                             borderRadius: BorderRadius.circular(10)),
                                              //         ),
                                              //       )
                                              //       :
                                              //       Text(''),

                                              //       SizedBox(width: ScreenAdapter.setWidth(10),),

                                              //       data[index]['task_status '] == 1 && data[index]['apply_status'] == 1 || data[index]['apply_status'] == 2 ?
                                              //       Row(
                                              //         children: <Widget>[
                                              //           Container(
                                              //             width: ScreenAdapter.setWidth(120),
                                              //             height: ScreenAdapter.setHeight(50),
                                              //             child: OutlineButton(
                                              //               padding: EdgeInsets.all(5),
                                              //               child: Text('撤销', style: TextStyle(fontSize: ScreenAdapter.size(25)),),
                                              //               onPressed: (){
                                              //                 alertDialog(context, '提示', '您确定要撤销吗？', (){
                                              //                   print('撤销');
                                              //                   print(data[index]['apply_id']);
                                              //                   // var id = data[index]['id'];
                                              //                   api.putData(context, 'applyDividerCancel', formData: {'apply_id':data[index]['apply_id']}).then((val){
                                              //                     if(val == null){
                                              //                       return;
                                              //                     }
                                              //                     var response = json.decode(val.toString());
                                              //                     Fluttertoast.showToast(msg: response['msg']);
                                              //                     Navigator.pop(context);
                                              //                     _controller.callRefresh();
                                              //                   });
                                              //                 });
                                              //               },
                                              //               shape: RoundedRectangleBorder(
                                              //                                 borderRadius: BorderRadius.circular(10)),
                                              //             ),
                                              //           ),
                                              //           SizedBox(width: ScreenAdapter.setWidth(10),),
                                              //         ],
                                              //       )
                                              //       :Text('')
                                              //     ],
                                              //   )
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
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

  statusTextStyle(status){
    switch (status) {
      case 0:
        return Colors.red;
        break;
      case 1:
        return Colors.green;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.grey;
        break;
      default:
    }
  }

  task_statusText(status){
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
      case 3:
        return '已结算';
        break;
      default:
    }
  }

  task_statusTextStyle(status){
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

  // 当前时间转时间戳
  stampTime(DateTime now) {
    print('---------------------转换时间戳----------------------');
    print(now.millisecondsSinceEpoch);
    return now.millisecondsSinceEpoch.toString().substring(0, 10);
  }

}

