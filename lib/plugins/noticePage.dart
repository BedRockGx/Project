import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ota_update/generated/i18n.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/ScreenAdapter.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> with TickerProviderStateMixin{
  // 总数
  int _count = 5;

  var duration = Duration(milliseconds: 200);
  double _height = 0;
  var api = new Api();
  var data = [];
  var refreshData, response;
  var base_url = 'https://flutter.ikuer.cn';      // baserUrl接口
  var now;
  AnimationController controller ;     // 动画控制器
  EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = new EasyRefreshController();
    // now = new DateTime.now();
    controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);    // 添加动画控制器
    // // padLeft(int width,String sring)：如果字符串长度小于width，在左边填充sring
    // now =
    //     "${now.month.toString().padLeft(2, '0')}月${now.day.toString().padLeft(2, '0')}日 ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    var now = new DateTime.now();
    refreshData = {
       'time':now,
       'page':1,
       'pagesize':8
    };
  }

 Future _getData({formData, typeOf}) async {
    print('传进来的参数:$formData');
    await api.getData(context, 'notifyList').then((val){
      print('后台返回的数据：$val');
      if(val == null){
        return;
      }
      response = json.decode(val.toString());
      // print(response);

      if(typeOf == 1){
        if(response.isEmpty){
          Fluttertoast.showToast(msg: '还没有新的通知!');
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
      // print('数据长度：${data.length}');
    });
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
          title: Text('通知',style: TextStyle(fontSize: ScreenAdapter.size(35))),
          centerTitle: true,
          elevation: 1,
        ),
        body: 
        ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Container(
            color: Color.fromRGBO(233, 233, 233, 0.7),
            child: Stack(
              children: <Widget>[
                // Positioned(
                //   top: 0,
                //   child: AnimatedContainer(
                //     duration: duration,
                //     height: _height,
                //     child: Container(
                //       alignment: Alignment.center,
                //       width: ScreenAdapter.setWidth(750),
                //       height: ScreenAdapter.setHeight(80),
                //       child: Container(
                //         decoration: BoxDecoration(
                //             color: Color.fromRGBO(200, 200, 200, 1),
                //             borderRadius: BorderRadius.circular(10)),
                //         padding: EdgeInsets.all(5),
                //         child: Text(
                //           '$now',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                EasyRefresh.custom(
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
                    firstRefresh: true,
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
                      await Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          _count += 5;
                        });
                      });
                    },
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return InkWell(
                              child: noticContainer(data[index]),
                              onTap: (){
                                var url = '$base_url/page/notify_detail.html?notify_id=${data[index]['id']}';
                                print(url);
                                Navigator.pushNamed(context, '/webpage', arguments: url);
                              },
                            );
                          },
                          childCount: data.length,
                        ),
                      ),
                    ],
                  ),
                // AnimatedContainer(
                //   duration: duration,
                //   margin: EdgeInsets.fromLTRB(0, _height, 0, 0),
                //   child: 
                // )
              ],
            ),
          ),
        )
    );
  }

  Widget noticContainer(val) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:ScreenAdapter.setHeight(10)),
      child: Column(
        children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical:ScreenAdapter.setHeight(10), horizontal:ScreenAdapter.setWidth(20)),
                    
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('${Plugins.dateTimeSocket(int.parse(val['notify_time']))}', style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(30)),),
                  ),
                  Container(
                        margin: EdgeInsets.symmetric(
                            vertical: ScreenAdapter.setHeight(10),
                            horizontal: ScreenAdapter.setWidth(20)),
                        // padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(30), vertical: ScreenAdapter.size(20)),
                        padding: EdgeInsets.fromLTRB(ScreenAdapter.setWidth(30), ScreenAdapter.size(20),  ScreenAdapter.size(30),  ScreenAdapter.size(20)),
                        
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Text.rich(
                                    TextSpan(
                                      children:[
                                        WidgetSpan(
                                          child: Icon(IconData(0xe626, fontFamily: 'myIcon'), color: Colors.deepOrangeAccent, size: ScreenAdapter.size(35),),
                                        ),
                                        TextSpan(
                                          text:'${val['title']}',
                                          style: TextStyle(
                                            fontSize: ScreenAdapter.size(30)
                                          ),
                                        )
                                      ]
                                    )
                                  ),
                                )
                              ],
                            ),
                            Divider(color: Colors.grey,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[Text('查看详情', style: TextStyle(color: Colors.black45, fontSize: ScreenAdapter.size(30)),), Icon(Icons.chevron_right, color: Colors.black45,)],
                            )
                          ],
                        ),
                      )
  
        ],
      ),
    );
    
  }

  // 当前时间转时间戳
  stampTime(DateTime now) {
    print('---------------------转换时间戳----------------------');
    print(now.millisecondsSinceEpoch);
    return now.millisecondsSinceEpoch.toString().substring(0, 10);
  }
}
