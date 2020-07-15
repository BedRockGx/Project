
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/subHeader.dart';

import 'package:project/plugins/appBar.dart';


class OrderHall extends StatefulWidget {
  @override
  _OrderHallState createState() => _OrderHallState();
}

class _OrderHallState extends State<OrderHall> {
  // 打开侧边栏
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // 用于上拉加载分页
  ScrollController _scrollController = ScrollController(); // lsitview的控制器

  int page = 1;
  List<Map> data = [];
  // 解决重复请求的问题
  bool flag = true;

  @override
  void initState() { 
    super.initState();
    // 监听滚动条滚动事件
    _scrollController.addListener((){
      // _scrollController.position.pixels;      // 获取滚动条滚动的高度
    _scrollController.position.maxScrollExtent;      // 获取滚动条可滚动区域高度
    // print(_scrollController.position.pixels);
    // print(_scrollController.position.maxScrollExtent);
    if(_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 20 ){
      
      if(flag){
        // 请求数据接口
        // getData();
      }
    }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scaffoldKey = null;
    super.dispose();
  }


  // 筛选导航
  Widget OrderWidget() {
  // var str = '{"img":"http://img2.imgtn.bdimg.com/it/u=1953606852,863263430&fm=26&gp=0.jpg", "title":"你好，我是司机，我会开汽车，火车，飞机", "price":160, "rommond":16}';

  var itemWidth = (ScreenAdapter.getScreenWidth() - 20) / 2; // 每一个网格的宽度

  data = [
    {
      "img": "https://www.itying.com/images/flutter/list1.jpg",
      "title": "你好，我是素馨，我会开汽车，火车，飞机",
      "price": 560,
      "rommond": 12
    },
    {
      "img": "https://www.itying.com/images/flutter/list2.jpg",
      "title": "你好，我是梓潼，我会开火车，轮船",
      "price": 360,
      "rommond": 35
    },
    {
      "img": "https://www.itying.com/images/flutter/list3.jpg",
      "title": "你好，我是疏影，我会开赛车，巡洋舰",
      "price": 130,
      "rommond": 13
    },
    {
      "img": "https://www.itying.com/images/flutter/list4.jpg",
      "title": "你好，我是青岚，我会开坦克，航母，航天飞行器",
      "price": 999,
      "rommond": 5
    },
    {
      "img": "https://www.itying.com/images/flutter/list5.jpg",
      "title": "你好，我是若兰，我会开大炮，骑行车",
      "price": 420,
      "rommond": 32
    },
    {
      "img": "https://www.itying.com/images/flutter/list6.jpg",
      "title": "你好，我是甜甜，我会开客机，快艇",
      "price": 500,
      "rommond": 160
    },
    {
      "img": "https://www.itying.com/images/flutter/list7.jpg",
      "title": "你好，我是萱萱，我会吃鸡",
      "price": 700,
      "rommond": 1850
    },
  ];

  if(data.length>0){
    return ListView(
    controller: _scrollController,          // 监听ListView滚动太滚动事件
    children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5), // 两边内边距
        margin: EdgeInsets.fromLTRB(
            0, ScreenAdapter.setHeight(90), 0, ScreenAdapter.setHeight(10)),
        child: Wrap(
            spacing: 10, // 平行距离
            runSpacing: 10, // 上下距离
            children: data.map((value) {
              return InkWell(
                onTap: (){
                  print('点击事件${value['price']}');
                  // 模拟商城中的商品详情
                  Navigator.pushNamed(context, '/commodity_details', arguments: {
                    'id':value['price']
                  });
                },
                child: Container(
                  width: itemWidth,
                  padding: EdgeInsets.all(ScreenAdapter.setWidth(10)),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1)),
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: double.infinity, // 自适应占满全部
                          child: AspectRatio(
                            aspectRatio: 1 / 1, // 图片宽高比 1/1
                            child: Image.network(
                              value['img'],
                              fit: BoxFit.cover,
                            ), // 图片自适应
                          )),
                      Padding(
                        padding: EdgeInsets.all(ScreenAdapter.setWidth(5)),
                        child: Text(
                          value['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenAdapter.setWidth(5)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '￥' + value['price'].toString() + '/夜',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 15.0),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Text(
                                  '已完成' + value['rommond'].toString() + '单',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 12.0)),
                              flex: 1,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList()),
      )
    ],
  );
  }else{
    return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitFadingCircle(
                  color: Colors.grey,
                  size: 50.0,
                  // controller: AnimationController(vsync: context, duration: const Duration(milliseconds: 1200)),
                ),
                Text('正在加载中请稍后')
              ],
            )
          );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(context),
        key: _scaffoldKey, // 绑定侧边栏Key
        endDrawer: Drawer(
          child: Container(
            child: Text('司机实现筛选功能'),
          ),
        ),
        body: Stack(
          children: <Widget>[
            OrderWidget(),
            SubHeaderWidget(),
          ],
        ));
  }
}