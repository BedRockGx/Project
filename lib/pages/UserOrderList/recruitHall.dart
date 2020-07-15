import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/config/api.dart';
import 'package:transparent_image/transparent_image.dart';

class RecruitHall extends StatefulWidget {
  @override
  _RecruitHallState createState() => _RecruitHallState();
}

class _RecruitHallState extends State<RecruitHall> with TickerProviderStateMixin{

  EasyRefreshController _easyRefreshController;
  AnimationController _animationController;
  var api = new Api();
  var data = [];
  var refreshData, response;
  var base_url = 'https://flutter.ikuer.cn/';      // baserUrl接口

  // 总数
  int _count = 5;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = new EasyRefreshController();
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds:3));
    var now = new DateTime.now();
    refreshData = {
       'time':now,
       'page':1,
       'pagesize':8
    };
  }

  @override
  void dispose() { 
    _easyRefreshController = null;
    _animationController = null;
    super.dispose();
  }

  Future _getData({formData, typeOf}) async {
    print('传进来的参数:$formData');
    await api.getData(context, 'recruit_list', formData: formData).then((val){
      print('后台返回的数据：$val');
      if(val == null){
        return;
      }
      response = json.decode(val.toString());
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
        title: Text('招聘大厅',style: TextStyle(fontSize: ScreenAdapter.size(35))),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Color(0xfff3f3f3),
        child:  EasyRefresh.custom(
                      enableControlFinishRefresh: false,
                      enableControlFinishLoad: true,
                      controller: _easyRefreshController,
                      firstRefresh:true,
                      header: MaterialHeader(
                        valueColor:ColorTween(begin: Color(0xffff8080), end: Color(0xffff8080),)
                          .animate(_animationController)
                          ..addListener((){
                            setState(() {});
                          })
                      ),
                      footer: MaterialFooter(
                        valueColor:ColorTween(begin: Color(0xffff8080), end: Color(0xffff8080),)
                          .animate(_animationController)
                          ..addListener((){
                            setState(() {});
                          })
                      ),
                      onRefresh: () async {
                        await Future.delayed(Duration(seconds: 0), () async {
                          // print('-------------下拉刷新----------------');
                          var now = new DateTime.now();
                          setState((){
                            refreshData['page'] = 1;
                            refreshData['time'] = stampTime(now);
                          });
                          
                            print('传输参数:${refreshData}');
                          _getData(formData: refreshData, typeOf:1);
                          _easyRefreshController.resetLoadState();
                        });
                      },
                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 0), () async {
                          print('---------------------上拉加载--------------');
                         
                          setState(() {
                            refreshData['page']++;
                          //  setadCode();
                          });
                          _getData(formData: refreshData, typeOf:2).then((val){
                            _easyRefreshController.finishLoad(noMore:response.isEmpty,);
                            
                          });
                        });
                      },
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // print('--------------下拉刷新上拉加载的内容-----------');
                              // print(index);
                              return judge(index);
                            },
                            childCount: data.length,
                          ),
                        ),
                      ],
                    ),
      ),
    );
  }

  Widget judge(index){
    return InkWell(
            child: EvaluatLayout(context, index),
            onTap: (){
              Map arguments = {
                'Hall':true,
                'id':data[index]['id']
              };
              Navigator.pushNamed(context, '/recruitDetails', arguments:arguments);
            },
          );
  }

  Widget EvaluatLayout(context, index){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(30),vertical: ScreenAdapter.setHeight(15)),
      padding: EdgeInsets.all(ScreenAdapter.setWidth(20)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('${data[index]['title']}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: ScreenAdapter.size(30)),),
              ),
              Container(
                margin: EdgeInsets.only(left:ScreenAdapter.setWidth(50)),
                child: Text('${data[index]['start_salary']}k-${data[index]['end_salary']}k', style: TextStyle(color: Colors.red, fontSize: ScreenAdapter.size(30)),),
              )
            ],
          ),
          SizedBox(
            height: ScreenAdapter.setHeight(20),
          ),
          Row(
            children: <Widget>[
              Container(
                width: ScreenAdapter.setWidth(50),
                child: AspectRatio(
                  aspectRatio: 1/1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: '$base_url${data[index]['head_pic']}'),
                  ),
                ),
              ),
              SizedBox(
                width: ScreenAdapter.setWidth(10),
              ),
              Text('${data[index]['nickname']}', style: TextStyle(color: Colors.black54, fontSize: ScreenAdapter.size(25)),)
            ],
          ),
          SizedBox(
            height: ScreenAdapter.setHeight(10),
          ),
          Row(
            children: <Widget>[
              Container(
                child: Text('发布时间：', style: TextStyle(color: Colors.black54, fontSize: ScreenAdapter.size(25)),)
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${Plugins.timeStamp(int.parse(data[index]['release_time']))}', style: TextStyle(color: Colors.black54, fontSize: ScreenAdapter.size(25)),),
                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Text(
                            '查看详情',
                            style: TextStyle(color: Colors.black54, fontSize: ScreenAdapter.size(25))
                          ),
                          Icon(IconData(0xe623, fontFamily: 'myIcon'), size: ScreenAdapter.size(25), color: Colors.black54,)
                        ],
                      )
                    )
                  ],
                ),
              )
            ],
          )
        ],
      )
    );
  }

   // 当前时间转时间戳
  stampTime(DateTime now) {
    print('---------------------转换时间戳----------------------');
    print(now.millisecondsSinceEpoch);
    return now.millisecondsSinceEpoch.toString().substring(0, 10);
  }
}