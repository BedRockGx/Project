import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/config/api.dart';

class BillPage extends StatefulWidget {
  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> with TickerProviderStateMixin{
  
  var api = new Api();
  var data = [];
  // 时间，请求参数，返回参数
  var now, refreshData, response;
  // 刷新控制器
  EasyRefreshController _controller;
  AnimationController controller ;     // 动画控制器

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController();
    controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);    // 添加动画控制器
    refreshData = {
      'time':DateTime.now(),
      'page':1,
      'pagesize':10
    };
  }


  Future _getData({formData, typeOf}) async {
    // print('参数：${formData}');
   await api.getData(context, 'bill', formData: formData).then((val){
    //  print('返回数据：$val');
     if(val.toString() == '{}'){
        return;
      }
      // print('返回数据：${json.decode(val.toString())}');
      setState(() {
        response = json.decode(val.toString());
      });
      
      /*
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
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          // backgroundColor: Colors.blue,
          leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
          title: Container(
            child:  Text('账单记录', style: TextStyle( fontSize: ScreenAdapter.size(35)),),
          ),
          centerTitle: true,
          elevation: 1,
      ),
      body:Container(
        color: Colors.white,
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
                          var now = new DateTime.now();
                          print('--------------新的时间------------');
                          print(now);
                          setState((){
                            refreshData['page'] = 1;
                            refreshData['time'] = stampTime(now);
                          });
                          
                          _getData(formData: refreshData, typeOf:1);
                          _controller.resetLoadState();
                        });
                      },
                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 0), () async {
                          print('---------------------上拉加载--------------');
                          setState(() {
                            refreshData['page']++;
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
                              return BillWidget(context, index);
                            },
                            childCount: data.length,
                          ),
                        ),
                      ],
                    ),
    
      )
       );
  }

  Widget BillWidget(context, index){
    // print(data);
    return Container(
            padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(30)),
            child:Container(
              decoration: BoxDecoration(
                border:Border(
                  bottom: BorderSide(
                    width: ScreenAdapter.setHeight(0.5),
                    color: Colors.black45
                  )
                )
              ),
              padding: EdgeInsets.symmetric(vertical:ScreenAdapter.setHeight(18)),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${data[index]['description']}', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                    Text('${Plugins.datetimeStamp(int.parse(data[index]['bill_time']))}', style: TextStyle(fontSize: ScreenAdapter.size(25), color: Colors.black54),)
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right:ScreenAdapter.setWidth(10)),
                  child: 
                  data[index]['io'] == 0 ? 
                  Text('-${stampPrice(data[index]['money'])}', style: TextStyle(fontSize: ScreenAdapter.size(40), color:Color(0xff666666)))
                  :
                  Text('+${stampPrice(data[index]['money'])}', style: TextStyle(fontSize: ScreenAdapter.size(40), color: Color(0xffC91717))),
                )
              ],
            ),
            )
          );
  }


  // 当前时间转时间戳
  stampTime(DateTime now) {
    return now.millisecondsSinceEpoch.toString().substring(0, 10);
  }

  // 转换钱
  stampPrice(price){
    return price.toStringAsFixed(2);
  }
}
