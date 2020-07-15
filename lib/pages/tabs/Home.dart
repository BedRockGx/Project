import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/pages/EventBus/bus.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/Swiper.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/config/api.dart';
import 'package:provide/provide.dart';
import 'package:project/provide/SocketProvide.dart';

import 'package:project/plugins/appBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var api = new Api(); // 初始化接口
  var data;
  var recruitresponse ;
  var newData = [];
  var token;
  var netWorkBool = false;

  @override
  bool get wantKeepAlive => true;
  
  

  @override
  void initState() {
    super.initState();
    _getSwiper();
    _getHomeRecruit();

    eventBus.on<NetWorkOver>().listen((e) {
      netWorkBool = true;
      _getSwiper();
      _getHomeRecruit();
    });
  }

  var num_index = 0;
  void add() {
    setState(() {
      num_index++;
    });
  }

  _getSwiper() {
    // print(a);
    
    api.getData(context, 'swiperData').then((val) {
      if(val == null ){
        return ;
      }
      setState(() {
        data = json.decode(val.toString());
      });
    });
  }

  _getNewsData(){
    
  }

  _getHomeRecruit(){
    api.getData(context, 'home_recruit').then((val){
      print(val == null);
      if(val == null){
        return;
      }
      setState(() {
        recruitresponse = json.decode(val.toString());
      });

      for(var i = 2; i<recruitresponse.length; i++){
        setState(() {
          newData.add(recruitresponse[i]);
        });
      }

    });
  }

  
  @override
  Widget build(BuildContext context) {
    final rpx = MediaQuery.of(context).size.width / 750;
    // 初始化
    ScreenAdapter.init(context);
    // FutureBuilder 可以完美的解决异步请求，不用setState改变，就可以渲染
    return Scaffold(
        // appBar: appBar(context),
        body: Provide<SocketProvider>(
          builder: (context, child, val){
            if(val.netWorkstate != 'none'){
              return Container(
              color: Colors.white,
            child: data == null 
                ? Center(
                  child: CircularProgressIndicator(),
                )
                : Stack(
                  children: <Widget>[
                    
                    Container(
                       margin: EdgeInsets.only(top:120 * rpx),
                       child:  ScrollConfiguration(
                      behavior: OverScrollBehavior(),
                      child: ListView(
                                children: <Widget>[
                                  SizedBox(height: ScreenAdapter.setHeight(20),),
                                  SwiperWidget(swiperDataList: data),
                                  HomeButton(context),
                                  NewOrder(context, recruitresponse),
                                  ListOrder(context, newData),
                                ],
                              ),
                      ),
                    ),
                   Positioned(
                      top: ScreenAdapter.setHeight(43),
                      width: ScreenAdapter.setWidth(750),
                      height:120 * rpx,
                      child: appBar(context),
                    ),
                  ],
                )
                
                
                );
         
              // Fluttertoast.showToast(msg: '当前网络：${val.netWorkstate}');
              
            }else{
              return ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: InkWell(
                  child: Center(
                    child: Container(
                      child: Text('网络出现问题了，点击从新加载'),
                    ),
                  ),
                  onTap: (){
                    print('点击了');
                    _getSwiper();
                  },
                )
                
              );
            }
            // Fluttertoast.showToast(msg: '当前网络2222222222：${val.netWorkstate}');
            
          },
        )
      );
  }


// 首页按钮
Widget HomeButton(context){
  return Container(
    // margin: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(25), horizontal: ScreenAdapter.setWidth(20)),
    margin: EdgeInsets.fromLTRB(ScreenAdapter.setWidth(20), ScreenAdapter.setHeight(25), ScreenAdapter.setWidth(20), ScreenAdapter.setHeight(15)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/noticePage');
          },
          child: Column(
            children: <Widget>[
             Container(
               width: ScreenAdapter.setWidth(110),
               child:  AspectRatio(
                aspectRatio: 1/1,
                child: ClipOval(
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color.fromRGBO(255, 128, 128, 1), Colors.red]),
                      ),
                      alignment: Alignment.center,
                      child:Icon(IconData(0xe616, fontFamily: "myIcon"),color: Colors.white,size: ScreenAdapter.size(50))
                    ),
                ),
              ),
             ),
             SizedBox(height: ScreenAdapter.setHeight(20),),
              Text('通知', style: TextStyle(fontSize: ScreenAdapter.size(30)))
            ],
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/transactionPage');
          },
          child: Column(
            children: <Widget>[
              Container(
               width: ScreenAdapter.setWidth(110),
               child:  AspectRatio(
                aspectRatio: 1/1,
                child: ClipOval(
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color.fromRGBO(255, 128, 128, 1), Colors.red]),
                      ),
                      alignment: Alignment.center,
                      child:Icon(IconData(0xe618, fontFamily: "myIcon"),color: Colors.white,size: ScreenAdapter.size(50))
                    ),
                ),
              ),
             ),
             SizedBox(height: ScreenAdapter.setHeight(20),),
              Text('交易额', style: TextStyle(fontSize: ScreenAdapter.size(30)),)
            ],
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/upgrade_vip');
          },
          child: Column(
            children: <Widget>[
              Container(
                width: ScreenAdapter.setWidth(110),
                child:  AspectRatio(
                  aspectRatio: 1/1,
                  child: ClipOval(
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color.fromRGBO(255, 128, 128, 1), Colors.red]),
                        ),
                        alignment: Alignment.center,
                        child:Icon(IconData(0xe615, fontFamily: "myIcon"),color: Colors.white,size: ScreenAdapter.size(60))
                      ),
                  ),
                ),
              ),
              SizedBox(height: ScreenAdapter.setHeight(20),),
              Text('升级Vip', style: TextStyle(fontSize: ScreenAdapter.size(30)))
            ],
          ),
        ),
        InkWell(
          onTap: (){
            
            Map arguments = {
              'nickname':'VIP群聊',
              'isVip':true 
            };
            api.getData(context, 'isVip').then((val){
              if(val == null){
                return;
              }
              var response = json.decode(val.toString());
              if(response['is_vip'] == 1){
                arguments['isVip'] = true;
                Navigator.pushNamed(context, '/groupChat',
                arguments: arguments).then((val){
                  Provide.value<SocketProvider>(context).clearRecords();
                });
              }else{
                arguments['isVip'] = false;
                Fluttertoast.showToast(msg: '您还不是VIP，快来加入吧~');
              }
            });

            
            
          },
          child:Column(
            children: <Widget>[
              Container(
                width: ScreenAdapter.setWidth(110),
                child:  AspectRatio(
                  aspectRatio: 1/1,
                  child: ClipOval(
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color.fromRGBO(255, 128, 128, 1), Colors.red]),
                        ),
                        alignment: Alignment.center,
                        child:Icon(IconData(0xe614, fontFamily: "myIcon"),color: Colors.white,size: ScreenAdapter.size(50))
                      ),
                  ),
                ),
              ),
              SizedBox(height: ScreenAdapter.setHeight(20),),
              Text('VIP群聊', style: TextStyle(fontSize: ScreenAdapter.size(30)))
            ],
          ), 
        ),
        
      ],
    ),
  );
}

// 最新招聘信息
Widget NewOrder(context, recruitresponse){
  if(recruitresponse == null){
    return Container(child: Text(''),);
  }
  return Container(
    margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(30)),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('最新招聘', style: TextStyle(fontSize: ScreenAdapter.size(33)),),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/recruitHall');
              },
              child: Text('更多 >', style: TextStyle(fontSize: ScreenAdapter.size(25), color: Color.fromRGBO(180, 180, 180, 1)),),
            )
          ],
        ),
        SizedBox(height: ScreenAdapter.setHeight(13),),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child:InkWell(
                onTap: (){
                  Map arguments = {
                    'Hall':true,
                    'id':recruitresponse[0]['id']
                  };
                  Navigator.pushNamed(context, '/recruitDetails', arguments:arguments);
                },
                child: Container(
                padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(15), vertical: ScreenAdapter.setWidth(10)),
                height: ScreenAdapter.setHeight(200),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(231, 245, 255, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text('${recruitresponse[0]['title']}',maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(color:Color(0xff424F66),fontSize: ScreenAdapter.size(30)),),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('${recruitresponse[0]['start_salary']}K-${recruitresponse[0]['end_salary']}K', style: TextStyle(fontSize: ScreenAdapter.size(28), color: Colors.grey)),
                            Opacity(
                              opacity: 0.5,
                              child: Container(
                                width: ScreenAdapter.setWidth(130),
                                child: Image.asset('assets/images/home_left.png',fit: BoxFit.cover,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
              )
               
            ),
            SizedBox(
              width: ScreenAdapter.setWidth(30),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: (){
                  Map arguments = {
                    'Hall':true,
                    'id':recruitresponse[1]['id']
                  };
                  Navigator.pushNamed(context, '/recruitDetails', arguments:arguments);
                },
                child: Container(
                padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(15), vertical: ScreenAdapter.setWidth(10)),
                height: ScreenAdapter.setHeight(200),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(223, 232, 229, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text('${recruitresponse[1]['title']}',maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(color:Color(0xff42553B),fontSize: ScreenAdapter.size(30)),),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('${recruitresponse[1]['start_salary']}K-${recruitresponse[1]['end_salary']}K', style: TextStyle(fontSize: ScreenAdapter.size(28), color: Colors.grey)),
                            Opacity(
                              opacity: 0.5,
                              child: Container(
                                // alignment: Alignment.bottomCenter,
                                width: ScreenAdapter.setWidth(160),
                                child: Image.asset('assets/images/home_right.png',fit: BoxFit.cover,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
           
              )
               ),
          ],
        )
      ],
    )
  );
  
}

// 简易招聘信息
Widget ListOrder(context, recruitresponse){
  if(recruitresponse == null){
    return Container(child: Text(''),);
  }

  List<Widget> arr = [];

  for(var item in recruitresponse){
    arr.add(
      InkWell(
        onTap: (){
          Map arguments = {
                'Hall':true,
                'id':item['id']
              };
              Navigator.pushNamed(context, '/recruitDetails', arguments:arguments);
        },
        child:  Container(
          margin: EdgeInsets.symmetric(vertical:ScreenAdapter.setHeight(8)),
          decoration: BoxDecoration(
            color: Color.fromRGBO(233, 233, 233, 0.3),
            // borderRadius: BorderRadius.circular(10)
          ),
            child: ListTile(
            leading: Image.asset('assets/images/tongzhi.jpg'),
            title: Text('${item['title']}', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
            subtitle: Container(
              margin: EdgeInsets.only(top:ScreenAdapter.setHeight(20)),
              child:Text('${item['start_salary']}K-${item['end_salary']}K', style: TextStyle(fontSize: ScreenAdapter.size(25)),)
            ),
          ),
        ),
      ),
     
      );
  }

  return Container(
    margin: EdgeInsets.all(ScreenAdapter.setWidth(30)),
    child: Column(
      children: arr
    ),
  );
}
}