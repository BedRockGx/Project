import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/plugins/ScreenAdapter.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';    // 嵌套HTML WebView

import 'package:project/pages/model/productContent_model.dart';     // 接口Model

import 'package:project/config/api.dart';

import 'Behavior.dart';     // 接口请求

/*
  商品详情
 */

class CommodityDetails extends StatefulWidget {
  final Map arguments;

  CommodityDetails({Key key, this.arguments}) : super(key: key);

  @override
  _CommodityDetailsState createState() => _CommodityDetailsState();
}


class _CommodityDetailsState extends State<CommodityDetails>{

  Api api = new Api();

  List<Map> arr = [
    {'cate':'颜色', 'list':[{'title':'碳纤黑', 'checked':true}, {'title':'冰川蓝', 'checked':false}, {'title':'火焰红', 'checked':false}, {'title':'夏之密语', 'checked':false}]},
    {'cate':'版本', 'list':[{'title':'6GB+64GB', 'checked':true}, {'title':'6GB+128GB', 'checked':false}, {'title':'8GB+128GB', 'checked':false}, {'title':'6GB+256GB', 'checked':false},]},
    {'cate':'购买方式', 'list':[{'title':'官方标配', 'checked':true}]},
  ];
  List<Map> currentList = [];

  String _selectValue;

  @override

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getContentData();
    _initAttr();      // 修改源数据（第一种渲染方法）
    _getSelectedAttrValue();
  }

  _getContentData(){
      api.jd_getData('productList', formData: {'id':'59f6a2d27ac40b223cfdcf81'}).then((res){
        // print(json.decode(res.toString()));      // 转为Map类型
        var productContent = ProductContentModel.fromJson(res.data);      // 利用Model数据类型
        print(productContent.result.title);
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child:Container(
              alignment: Alignment.center,
              width: ScreenAdapter.setWidth(400),
              child: TabBar(
                indicatorColor: Colors.white,
                // indicatorSize: TabBarIndicatorSize.label,         // 选中长度
                tabs: <Widget>[
                  Tab(
                    child: Text('商品'),
                  ),
                  Tab(
                    child: Text('详情'),
                  ),
                  Tab(
                    child: Text('评价'),
                  ),
                ],
              ),
            )
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: (){
                  // 下拉菜单
                  showMenu(
                    context: context,
                    // 定位下拉菜单的位置
                    position:RelativeRect.fromLTRB(ScreenAdapter.setWidth(600), 80, 10, 0),
                    items: [
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.home),
                            Text('首页')
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search),
                            Text('搜索')
                          ],
                        ),
                      )
                    ]
                  );
              },
            )
          ],
        ),
        body:Stack(
          children: <Widget>[
            TabBarView(
              children: <Widget>[
                shoppingWidget(context),
                detailsWidget(),
                commentWidget()
              ],
            ),
            // 底部购物栏
            Positioned(
              width: ScreenAdapter.setWidth(750),
              height: ScreenAdapter.setHeight(100),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: ScreenAdapter.setHeight(100),
                      padding: EdgeInsets.only(top:ScreenAdapter.setHeight(10)),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.shopping_cart),
                          Text('购物车')
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: shoppingButtonWidget(color:Colors.orangeAccent, text: '加入购物车'),
                    ),
                    Expanded(
                      flex: 1,
                      child: shoppingButtonWidget(color:Colors.redAccent, text:'立即购买'),
                    ),
                  ],
                ), 
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(width: 0.5, color: Colors.black12)
                  )
                ),
              ),
              bottom: 0,
            )
          ],
        )
      ),
    );
  }



// 初始化数据，将返回的List数据增加一个true和false
// 有两种办法：一种是让后台返回带有checked的数据，一种是创建一个空数组来接收转换后的数据（下面提供转换数据的方法）
_initAttr(){
  var newArr = arr;
  for(var i = 0;i<newArr.length;i++){
    for(var j = 0; j<newArr[i]['list'].length;j++){
      if(j==0){
        currentList.add({
          'title':newArr[i]['list'][j],
          'checked':true
        });
      }else{
        currentList.add({
          'title':newArr[i]['list'][j],
          'checked':false
        });
      }
    }
  }
  print(currentList);
}

// 点击修改checked
_changeChecked(cate, title, setBottomState){
  var newArr = arr;
  for(var i = 0; i<newArr.length;i++){
    // 如果循环出来的cate和点击的cate相等
    if(newArr[i]['cate'] == cate){
      for(var j = 0;j<newArr[i]['list'].length;j++){ 
        newArr[i]['list'][j]['checked'] = false;
        if(title == newArr[i]['list'][j]['title']){
          newArr[i]['list'][j]['checked'] = true;
        }
      }
    }
  }
  setBottomState(() {     // 注意 改变showModalBottomState的数据(来源于StatefulBuilder)
    this.arr = newArr;
  });
  _getSelectedAttrValue();
}

// 获取选中的值
_getSelectedAttrValue(){
  var newArr = arr;
  List tempArr = [];
  for(var i = 0; i<newArr.length;i++){
    for(var j = 0; j<newArr[i]['list'].length;j++){
      if(newArr[i]['list'][j]['checked'] == true){
        tempArr.add(newArr[i]['list'][j]['title']);
      }
    }
  }
  setState(() {
    this._selectValue = tempArr.join(',');
  });
}

// 底部弹出框 选择类型按钮
_getAttrItem(attrItem, setBottomState){
  List<Widget> attrItemList = [];

  attrItem['list'].forEach((val){
    attrItemList.add(
        Container(
          margin: EdgeInsets.all(ScreenAdapter.setWidth(10)),
          child: InkWell(
            onTap: (){
              _changeChecked(attrItem['cate'], val['title'], setBottomState);
            },
            child: Chip(
              padding: EdgeInsets.all(ScreenAdapter.setWidth(10)),
              backgroundColor: val['checked'] ? Colors.redAccent : null,
              label: Text('${val['title']}', style: TextStyle(color: val['checked'] ? Colors.white : null),),
            ),
          )
        ),
    );
  });
  return attrItemList;
}

// 购买选择 底部弹出框
_attrBottomSheet(context){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, setBottomState){
            return Container(
                    height: ScreenAdapter.setHeight(600),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: ScreenAdapter.setHeight(80)),
                          child: ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child:  ListView(
                            children: <Widget>[
                              // 外面为什么外面包一个Wrap？
                              // 如果直接使用Text和Wrap，会内容溢出，利用Wrap来自适应宽度
                              Column(
                                children:arr.map((val){
                                  return Wrap(
                                    children: <Widget>[
                                      Container(
                                        width: ScreenAdapter.setWidth(110),
                                        padding: EdgeInsets.only(top:ScreenAdapter.setHeight(25)),
                                        child: Text('${val['cate']}:', style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      // wrapTitle(),
                                      Container(
                                        width: ScreenAdapter.setWidth(600),
                                        child: Wrap(
                                          children:_getAttrItem(val, setBottomState)
                                        ),
                                      )
                                    ],
                                  );
                                }).toList()
                              )
                            ],
                          ),
                        
          )
                         ),
                        Positioned(
                          bottom: 0,
                          width: ScreenAdapter.setWidth(750),
                          height: ScreenAdapter.setHeight(80),
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: shoppingButtonWidget(color: Colors.orangeAccent, text: '加入购物车'),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: shoppingButtonWidget(color: Colors.redAccent, text: '立即购买'),
                                )
                              ],
                            ),
                          )
                        )
                      ],
                    )
                  );
          },
        );
      }
    );
  }

// 商品页面
Widget shoppingWidget(context){
  return Container(
    margin: EdgeInsets.only(bottom: ScreenAdapter.setHeight(80)),
    child:ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child: ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16/16,
          child: Image.network('http://m.360buyimg.com/mobilecms/s750x750_jfs/t1/53679/32/1028/217626/5cebc494E799aca0e/b9b78195adbb4bc4.jpg!q80.dpg', fit:BoxFit.cover),
        ),
        
        // 标题，副标题
        Container(
          color: Colors.white,
          padding:EdgeInsets.fromLTRB(ScreenAdapter.setWidth(10), 0, ScreenAdapter.setWidth(10) , ScreenAdapter.setWidth(20)),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: ScreenAdapter.setHeight(20)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Text('特价：'),
                          Text('¥2399.00', style: TextStyle(color: Colors.redAccent, fontSize: ScreenAdapter.size(45)),)
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('原价：'),
                          Text('¥2899.00', style: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenAdapter.size(28),
                            decoration: TextDecoration.lineThrough
                          ),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:ScreenAdapter.setHeight(15)),
                child: Text(
                  'Redmi K20Pro 骁龙855 索尼4800万超广角三摄 AMOLED弹出式全面屏 8GB+256GB 冰川蓝 游戏智能手机 小米 红米',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: ScreenAdapter.size(35)
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:ScreenAdapter.setHeight(10)),
                child: Text(
                  '【骁龙855旗舰处理器,索尼4800万超广角三摄】巨惠来袭，数量有限，售完即止。',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenAdapter.size(28)
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 优惠
        Container(
          color: Colors.white,
          margin: EdgeInsets.fromLTRB(0, ScreenAdapter.setHeight(10), 0, ScreenAdapter.setHeight(10)),
          padding: EdgeInsets.all(ScreenAdapter.setHeight(10)),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      height: ScreenAdapter.setHeight(60),
                      child: Text('优惠:', style: TextStyle(fontSize: ScreenAdapter.size(25), color: Colors.grey)),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: ScreenAdapter.setWidth(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: ScreenAdapter.size(25)),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '免费领 ',
                                  style: TextStyle(color: Colors.redAccent)
                                ),
                                TextSpan(
                                  text: ' 体验卡免费领，超大流量任意使用'
                                )
                              ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: ScreenAdapter.size(25)),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '优惠套装 ',
                                  style: TextStyle(color: Colors.redAccent)
                                ),
                                TextSpan(
                                  text: ' 该商品共有10款优惠套装'
                                )
                              ]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.more_horiz),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // 选择商品，收货地址
        Container(
          color: Colors.white,
          margin: EdgeInsets.fromLTRB(0, ScreenAdapter.setHeight(10), 0, ScreenAdapter.setHeight(10)),
          padding: EdgeInsets.all(ScreenAdapter.setHeight(10)),
          child: Column(
            children: <Widget>[
              Container(
                child: InkWell(
                  onTap: (){
                    _attrBottomSheet(context);
                  },
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        height: ScreenAdapter.setHeight(60),
                        child: Text('已选:', style: TextStyle(fontSize: ScreenAdapter.size(25), color: Colors.grey)),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: ScreenAdapter.setWidth(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black, fontSize: ScreenAdapter.size(25)),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${_selectValue}'
                                  )
                                ]
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.grey, fontSize: ScreenAdapter.size(25)),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '本商品支持保障服务，京东服务， 点击可选服务'
                                  )
                                ]
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.more_horiz),
                        ),
                      )
                    ],
                  ),
                )
              ),
              Divider(),
              // 收货地址
              Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      height: ScreenAdapter.setHeight(60),
                      child: Text('送至:', style: TextStyle(fontSize: ScreenAdapter.size(25), color: Colors.grey)),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: ScreenAdapter.setWidth(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: ScreenAdapter.size(25)),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '北京朝阳区三环到四环之间 ',
                                ),
                              ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.grey, fontSize: ScreenAdapter.size(25)),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '现货',
                                  style: TextStyle(color: Colors.red)
                                ),
                                TextSpan(
                                  text: '23:00前下单，预计明天(12月02日)送达'

                                )
                              ]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.more_horiz),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    )
  )
        )
    ;
}

// 详情页面
// 为避免每次进入详情都会再次加载一遍页面的情况出现，可以继承一下automatikeepalive实现状态保持
// 所以要将该详情页面抽离成一个stful状态控件
Widget detailsWidget(){
  return Container(
    child: Column(
      children: <Widget>[
        Text('我是顶部数据'),
        // Expanded(
        //       child: Container(
        //         child: InAppWebView(
        //           initialUrl: "https://item.m.jd.com/ware/view.action?wareId=100003582705&sid=null",
        //           initialHeaders: {},
        //           initialOptions: InAppWebViewWidgetOptions(
        //               inAppWebViewOptions: InAppWebViewOptions(
        //                 debuggingEnabled: true,
        //               )
        //           ),
        //           onWebViewCreated: (InAppWebViewController controller) {
  
        //           },
        //           onLoadStart: (InAppWebViewController controller, String url) {
  
        //           },
        //           onLoadStop: (InAppWebViewController controller, String url) {
  
        //           },
        //         ),
        //       ),
        // ),
        Text('我是底部数据'),
      ],
    )
  );
}

// 评价页面
Widget commentWidget(){
  return Container(
    child: Text('评价11111111'),
  );
}

// 底部购买按钮
Widget shoppingButtonWidget({Color color = Colors.black, String text = '按钮', Object fn = null}){
  return InkWell(
    onTap: fn,
    child: Container(
      height: ScreenAdapter.setHeight(70),
      width: double.infinity,
      margin: EdgeInsets.all(5),
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(color: Colors.white),),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10)
      ),
    ),
  );
}



}