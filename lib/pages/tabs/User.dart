import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/config/api.dart';
import 'package:project/pages/EventBus/bus.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/RadiusImage.dart';
import 'package:project/plugins/RatingBar.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/provide/HomeProvide.dart';
import 'package:project/provide/SocketProvide.dart';
import 'package:provide/provide.dart';
import 'package:project/provide/Colors.dart';
import 'package:project/provide/ColorProvide.dart';
import 'package:project/plugins/PublicStorage.dart';

import 'package:provide/provide.dart';
import 'package:project/provide/Useridentity.dart';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:open_file/open_file.dart';



class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin{

   @override
  bool get wantKeepAlive => true;
  

  int isVip = 0;
  int is_driver = 0;

  var userData,employerData,driverData, isShowBackgroundImage = false, switchVlue = false;

  var api = new Api();
  var base_url = 'https://flutter.ikuer.cn';      // baserUrl接口
  var app_url;

  @override
  void initState() { 
    super.initState();
    _getUserData();
    _getEmployerData();
    _getDriverData();
    _setBackgroundImage();
    print('----------------------User用户页面-----------------------');
  }
  _getUserData(){
    api.getData(context, 'userInfo').then((val){
      if(val == null){
        return;
      }
      print(json.decode(val.toString()));
      var response = json.decode(val.toString());
      setState(() {
        userData = response;
        isVip = response['is_vip'];
      });
    }); 
  }

  _getEmployerData(){
    api.getData(context, 'employerInfo').then((val){
      if(val == null){
        return;
      }
      print('');
      print(json.decode(val.toString()));
      var response = json.decode(val.toString());
      setState(() {
        employerData = response;
      });
    });
  }

  _getDriverData(){
    api.getData(context, 'driverInfo').then((val){
      print(val);
      if(val == null){
        return;
      }
      // print('我会被触发吗？？');
      print(json.decode(val.toString()));
      var response = json.decode(val.toString());
      setState(() {
        driverData = response;
        is_driver = response['is_driver'];
      });
    });
  }
  
  // 查看本地存储是否设置了背景图片
  _setBackgroundImage() async {
    var showImage = await PublicStorage.getHistoryList('ShowBackgroundImage');
    Provide.value<Useridentity>(context).modifyShowBackgroundImage(showImage[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: Plugins.scaffoldKey,
      // endDrawer: Drawer(
      //   child: Container(
      //     child: ListView(
      //       padding: EdgeInsets.only(top: 0),
      //       children: <Widget>[
      //         Container(
      //           height: ScreenAdapter.setHeight(150),
      //           alignment: Alignment.center,
      //           child: Text('设置',style: TextStyle(fontSize: ScreenAdapter.size(30),fontWeight: FontWeight.bold)),
      //           color: Color.fromRGBO(200, 200, 200, 0.5)
      //         ),
      //         ListTile(
      //           leading: Icon(Icons.whatshot),
      //           title: Text('设置头像为背景图'),
      //           trailing: CupertinoSwitch(
      //           value: this.switchVlue,
      //             onChanged: (bool value) { 
      //               setState(() { 
      //                 this.switchVlue = value;
      //                 this.isShowBackgroundImage = !this.isShowBackgroundImage; 
      //               }); 
      //             },
      //           ),
      //         ),
      //         // DrawerList('消息',Icons.message, (){
      //         //   Navigator.pushNamed(context, '/chatList');
      //         // }),
      //         DrawerList('认证司机',Icons.local_shipping, (){
      //           Navigator.pushNamed(context, '/authenication_Driver');
      //         }),
      //         // DrawerList('更换主题',Icons.color_lens, showThemeDialog),
              
      //         // DrawerList('清除缓存',Icons.delete_sweep, (){
      //         //   PublicStorage.clearHistoryList();
      //         // }),
      //         DrawerList('检查更新',Icons.system_update, () async {
      //           var version = await Plugins.getPackageInfo(context);
      //           api.getData(context, 'update').then((val){
      //               // print('-------------获取版本信息--------------');
      //               // print(json.decode(val.toString()));
      //               var response = json.decode(val.toString());
      //               // 如果当前版本比服务器小，返回-1，大返回1，相等返回0
      //               var isUpdate = version.compareTo(response['version_no']);

      //               setState(() {
      //                 app_url = '$base_url${response['app_path']}';
      //               });
      //               if(isUpdate.toString() == '-1'){
      //                 Plugins.showUpdateDialog(context, app_url);
      //               }else{
      //                 Fluttertoast.showToast(msg: '最新版本为：$version，不需要更新');
      //               }
      //             });
      //         }),
      //         // DrawerList('退出登录',Icons.settings_power, _alertDialog),
      //         DrawerList('关于本App',Icons.error, (){

      //         }),
              
      //       ],
      //     ),
      //   ),
      // ),
      body: Container(
        color: Colors.white,
        child: Provide<Useridentity>(
        builder: (context, child, counter){
          return Container(
            color: Color.fromRGBO(233, 233, 233, 0.7),
            child: userData == null || employerData == null || driverData == null? 
              Loading(text:'加载中')
              : 
              ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: <Widget>[
                  Container(
                    // color: Colors.pink,
                    height: ScreenAdapter.setHeight(450),

                    child: Stack(
                      children: <Widget>[
                        ClipPath(
                          clipper:BottomClipperTest(),
                          child: Container(
                            height: ScreenAdapter.setHeight(800),
                            decoration: BoxDecoration(
                              // color: Colors.green,
                              // image: null
                              image: counter.getisShowBackgroundImage ? 
                                DecorationImage(
                                  image: NetworkImage('$base_url${userData['head_pic']}',),
                                  fit:BoxFit.cover
                                ) : null
                            ),
                            // color:Theme.of(context).primaryColor,
                          ),
                        ),
                       
                        Positioned(
                          top: 0,
                          child:  Container(
                            width: ScreenAdapter.getScreenWidth(),
                            height: ScreenAdapter.setHeight(250 ),
                            padding: EdgeInsets.fromLTRB(ScreenAdapter.setWidth(25), ScreenAdapter.setHeight(60), ScreenAdapter.setWidth(25), ScreenAdapter.setHeight(0)),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              // color: Colors.redAccent
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    
                                    // Container(
                                    //   width: ScreenAdapter.setWidth(35),
                                    //   height: ScreenAdapter.setHeight(35),
                                    //   child: Image.asset('assets/images/kefu.png',fit: BoxFit.cover,),
                                    // ),
                                    SizedBox(width: ScreenAdapter.setWidth(30),),
                                    InkWell(
                                      child: Icon(Icons.settings, color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,),
                                      onTap: (){
                                        Navigator.pushNamed(context, '/settings');
                                        // Plugins.openEndDrawer();
                                      },
                                    )
                                    
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      child: ImageRadius('$base_url${userData['head_pic']}', 135, 135),
                                      onTap: (){
                                        Navigator.pushNamed(context, '/modify_userInfo',arguments: userData ).then((val){
                                          _getUserData();
                                        });
                                      },
                                    ),
                                    
                                    Container(
                                        margin: EdgeInsets.only(left: ScreenAdapter.setWidth(15)),
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  width: userData['nickname'].trim().length > 8 ? ScreenAdapter.setWidth(250) : null,
                                                  child: Text('${userData['nickname']}',maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,fontSize: ScreenAdapter.size(35), fontWeight: FontWeight.w500),),
                                                ),
                                                Container(
                                                    child:  Text('信誉度：${employerData['employer_reputation']}%', style: TextStyle(color:counter.getisShowBackgroundImage ? Colors.white : Colors.black, fontSize: ScreenAdapter.size(20)),),
                                                    padding: EdgeInsets.only(top: ScreenAdapter.setWidth(15)),
                                                    margin: EdgeInsets.only(left: ScreenAdapter.setWidth(10)),
                                                    decoration: BoxDecoration(
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: ScreenAdapter.setHeight(10),
                                            ),
                                            getUseridentity(counter, is_driver)
                                          ],
                                        )
                                    ),
                                    
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                        ),
                        
                        Positioned(
                          bottom: ScreenAdapter.setHeight(-5),
                          child:InkWell(
                            child:  Container(
                            width: ScreenAdapter.getScreenWidth(),
                            height: ScreenAdapter.setHeight(200),
                            padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(25)),
                            // alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              // color: Colors.green
                            ),
                            child:ClipPath(
                              clipper:VipWidget(),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(ScreenAdapter.setWidth(25), ScreenAdapter.setHeight(20), ScreenAdapter.setWidth(25), 0),
                                decoration: BoxDecoration(
                                 color:Theme.of(context).primaryColor == Color(0xff000000) && !isShowBackgroundImage ? Colors.white38 : Color.fromRGBO(0, 0, 0, 0.8),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                ),

                                child: Column(
                                  children: <Widget>[
                                    isVip == 0 ? 
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: ScreenAdapter.setWidth(50),
                                          height: ScreenAdapter.setHeight(50),
                                          margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20)),
                                          child: Image.asset('assets/images/VIP.png',fit: BoxFit.cover,),
                                        ),
                                        Text('升级VIP专项超值权益',style: TextStyle(color: Color.fromRGBO(221, 162, 127, 1), fontSize: ScreenAdapter.size(30)),),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20), vertical: ScreenAdapter.setHeight(5)),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                      gradient: const LinearGradient(
                                                          colors: [Color.fromRGBO(229, 166, 125, 1), Color.fromRGBO(247, 207, 187, 1)]),
                                                  ),
                                                  child: InkWell(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text('充值',style: TextStyle(color: Colors.black87, fontSize: ScreenAdapter.size(30))),
                                                        Icon(Icons.chevron_right,color: Colors.black,size: ScreenAdapter.size(30),)
                                                      ],
                                                    ),
                                                    onTap: (){
                                                      // print('111111111111111111111')
                                                      // Navigator.pushNamed(context, '/wallet');
                                                      // Map data = {
                                                      //   'title':'充值',
                                                      //   'isChong':true,
                                                      //   'isVip':isVip
                                                      // };
                                                      // Navigator.pushNamed(context, '/ti_pay', arguments: data);
                                                    },
                                                  )
                                                )
                                              ],
                                            )
                                          )
                                        )
                                      ],
                                    ) 
                                    :
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: ScreenAdapter.setWidth(50),
                                          height: ScreenAdapter.setHeight(50),
                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                          child: Image.asset('assets/images/VIP.png',fit: BoxFit.cover,),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  // padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20), vertical: ScreenAdapter.setHeight(5)),
                                                  // decoration: BoxDecoration(
                                                  //   borderRadius: BorderRadius.circular(20),
                                                  //     gradient: const LinearGradient(
                                                  //         colors: [Color.fromRGBO(229, 166, 125, 1), Color.fromRGBO(247, 207, 187, 1)]),
                                                  // ),
                                                  child: InkWell(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text('VIP账户',style: TextStyle(color: Color.fromRGBO(221, 162, 127, 1), fontSize: ScreenAdapter.size(30))),
                                                        // Icon(Icons.chevron_right,color: Colors.black,size: ScreenAdapter.size(30),)
                                                      ],
                                                    ),
                                                    onTap: (){

                                                    },
                                                  )
                                                )
                                              ],
                                            )
                                          )
                                        ),
                                        Container(
                                          // width: ScreenAdapter.setWidth(50),
                                          // height: ScreenAdapter.setHeight(50),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20), vertical: ScreenAdapter.setHeight(5)),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                    gradient: const LinearGradient(
                                                        colors: [Color.fromRGBO(229, 166, 125, 1), Color.fromRGBO(247, 207, 187, 1)]),
                                                ),
                                                child: InkWell(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text('充值',style: TextStyle(color: Colors.black87, fontSize: ScreenAdapter.size(30))),
                                                      Icon(Icons.chevron_right,color: Colors.black,size: ScreenAdapter.size(30),)
                                                    ],
                                                  ),
                                                  onTap: (){
                                                    // Navigator.pushNamed(context, '/wallet');
                                                    // Map data = {
                                                    //   'title':'充值',
                                                    //   'isChong':true
                                                    // };
                                                    // Navigator.pushNamed(context, '/ti_pay', arguments: data);
                                                  },
                                                )
                                              )
                                            ],
                                          )
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.grey,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text('余额：¥${userData['wallet']}', style: TextStyle(color: Color.fromRGBO(221, 162, 127, 1), fontSize: ScreenAdapter.size(30)),),
                                        // Text('充值', style: TextStyle(color: Color.fromRGBO(221, 162, 127, 1))),
                                        InkWell(
                                          child: Text('可提现：¥${userData['wallet']}', style: TextStyle(color: Color.fromRGBO(221, 162, 127, 1), fontSize: ScreenAdapter.size(30))),
                                          onTap: (){
                                            // Map data = {
                                            //   'title':'余额提现',
                                            //   'isChong':false,
                                            //   'price':userData['wallet']
                                            // };
                                            // Navigator.pushNamed(context, '/ti_pay', arguments: data);
                                          },
                                        )
                                        // Text('账单', style: TextStyle(color: Color.fromRGBO(221, 162, 127, 1))),
                                      ],
                                    )
                                  ],
                                ),
                             
                              ),
                            ),
                          ),
                          onTap: (){
                            Map data = {
                              'isVip':isVip,
                              'price':userData['wallet']
                            };
                            Navigator.pushNamed(context, '/wallet', arguments: data).then((_){
                              _getUserData();
                            });
                          },
                          )
                        ),
                     
                      ],
                    ),
                  ),
                  Container(
                    margin:EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20)),
                    padding: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10), horizontal: ScreenAdapter.setWidth(30)),
                    width: ScreenAdapter.getScreenWidth(),
                    height: ScreenAdapter.setHeight(150),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: 
                    counter.getIdentity == 0 ? 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        OrderButton(context, '全部任务', Icons.assignment, fn:(){
                          print('全部任务');
                          List<Map> arr = [
                            {
                              'title':'全部任务',
                              'state':3,
                              'userImage':userData['head_pic'],
                              'userName':userData['nickname']
                            }
                          ];
                          Provide.value<HomeProvide>(context).setCondition('all');
                          Navigator.pushNamed(context, '/user_order', arguments: arr);
                        }),
                        OrderButton(context, '招募中的任务', Icons.people, fn:(){
                          print('招募中的任务');
                          List<Map> arr = [
                            {
                              'title':'招募中的任务',
                              'state':3,
                              'userImage':userData['head_pic'],
                              'userName':userData['nickname']
                            }
                          ];
                          Provide.value<HomeProvide>(context).setCondition('recruiting');
                          Navigator.pushNamed(context, '/user_order', arguments: arr);
                        }),
                        // OrderButton(context, is_driver == 1 ? counter.getIdentity == 0 ? '招募任务数量':'成交数量'  : '请先认证司机身份', Icons.confirmation_number, number:employerData['employer_order_num'], fn:(){
                        //   Fluttertoast.showToast(msg: '您当前的总数量为${employerData['employer_order_num']}条', gravity:ToastGravity.CENTER);
                        // }),
                        OrderButton(context, '进行中的任务', Icons.timelapse, fn:(){
                          print('进行中的任务');
                          List<Map> arr = [
                            {
                              'title':'进行中的任务',
                              'state':1,
                              'userImage':userData['head_pic'],
                              'userName':userData['nickname']
                            }
                          ];
                          Provide.value<HomeProvide>(context).setCondition('ongoing');
                          Navigator.pushNamed(context, '/user_order', arguments: arr);
                        }),
                        OrderButton(context, '已完成的任务', Icons.assignment_turned_in, fn:(){
                          print('已完成任务');
                          List<Map> arr = [
                            {
                              'title':'已完成的任务',
                              'state':2,
                              'userImage':userData['head_pic'],
                              'userName':userData['nickname']
                            }
                          ];
                          Provide.value<HomeProvide>(context).setCondition('finished');
                          Navigator.pushNamed(context, '/user_order', arguments: arr);
                        }),
                        
                      ],
                    )
                    :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        OrderButton(context, '全部申请', Icons.layers, fn:(){
                          print('全部申请');
                          List<Map> arr = [
                            {
                              'title':'全部申请',
                              'state':3,
                              'userImage':userData['head_pic'],
                              'userName':userData['nickname']
                            }
                          ];
                          Provide.value<HomeProvide>(context).setConditionDivider('all');
                          Navigator.pushNamed(context, '/dirviderOrderList', arguments: arr);
                        }),
                        OrderButton(context, '审核中的申请', Icons.touch_app, fn:(){
                          print('审核中的申请');
                          List<Map> arr = [
                            {
                              'title':'审核中的申请',
                              'state':3,
                              'userImage':userData['head_pic'],
                              'userName':userData['nickname']
                            }
                          ];
                          Provide.value<HomeProvide>(context).setConditionDivider('checking');
                          Navigator.pushNamed(context, '/dirviderOrderList', arguments: arr);
                        }),
                        // OrderButton(context, is_driver == 1 ? counter.getIdentity == 0 ? '招募任务数量':'成交数量'  : '请先认证司机身份', Icons.confirmation_number, number:employerData['employer_order_num'], fn:(){
                        //   Fluttertoast.showToast(msg: '您当前的总数量为${employerData['employer_order_num']}条', gravity:ToastGravity.CENTER);
                        // }),
                        OrderButton(context, '已完成的任务', Icons.assignment_turned_in, fn:(){
                          print('已完成任务');
                          List<Map> arr = [
                            {
                              'title':'已完成的任务',
                              'state':2,
                              'userImage':userData['head_pic'],
                              'userName':userData['nickname']
                            }
                          ];
                          Provide.value<HomeProvide>(context).setConditionDivider('finished');
                          Navigator.pushNamed(context, '/dirviderOrderList', arguments: arr);
                        }),
                        
                      ],
                    ),
                  ),
                  Container(
                    margin:EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20), vertical: ScreenAdapter.setHeight(15)),
                    padding: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10), horizontal: ScreenAdapter.setWidth(30)),
                    width: ScreenAdapter.getScreenWidth(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          OrderList(context, '发布订单', Icons.edit, (){
                            Navigator.pushNamed(context, '/addOrder').then((val){
                              eventBus.fire(OrderHallRefresh('刷新'));
                            });
                          }),
                          Divider(),
                          OrderList(context, '发布招聘', Icons.format_align_left, (){
                            Navigator.pushNamed(context, '/addRecruit');
                          }),
                          Divider(),
                          OrderList(context, '切换身份', Icons.party_mode, showModifyIdentity),
                          Divider(),
                          OrderList(context, '我的招聘', Icons.donut_large, (){
                            Navigator.pushNamed(context, '/myRecruitHall');
                          }),
                          Divider(),
                          OrderList(context, '消息', Icons.message, (){
                            Navigator.pushNamed(context, '/chatList').then((_){
                            });
                          }),
                          Divider(),
                          OrderList(context, '客服', Icons.headset_mic, (){
                            Map arguments = {
                              'nickname':'客服',
                              'head_pic':'https://dss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3824050368,3611956440&fm=58&w=121&h=140&img.JPEG',
                              'recv_id':'admin',
                              'isVip':false
                            };
                            Navigator.pushNamed(context, '/servicePage', arguments: arguments).then((_){
                              Provide.value<SocketProvider>(context).clearRecords();
                            });
                          }),
                        ],
                      ),
                    )
                  ),
                  
                  // _buttonWidget(context, '京东', (){
                  //   Navigator.pushNamed(context, '/commodity_details');
                  // }),
                  // _buttonWidget(context, '搜索推荐', (){
                  //   Navigator.pushNamed(context, '/search_test');
                  // }),
                ],
              ),
          
        )
              );
        },
      )
    ,
      )
      
    );
  }

  // 显示自定义主题弹窗
  void showThemeDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('切换主题'),
          content: SingleChildScrollView(
            child: Container(
              //包含ListView要指定宽高
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: YColors.themeColor.keys.length,
                itemBuilder: (BuildContext context, int position) {
                  return GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.only(bottom: 15),
                      color: YColors.themeColor[position]["primaryColor"],
                    ),
                    onTap: () {
                      PublicStorage.setHistoryList('Theme', position);
                      Provide.value<ThemeProvide>(context).setTheme(position);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  gaode(){
    AmapService.navigateDrive(LatLng(36.547901, 104.258354));
  }

// 侧边栏选项
Widget DrawerList(String title, IconData icon, Function fn){
  return ListTile(
          leading: Icon(icon),
          title: Text('${title}'),
          trailing: Icon(Icons.chevron_right),
          onTap: fn
        );
}

  // 当前身份、是否认证司机
  getUseridentity(counter, isCart){
    if(counter.getIdentity == 0){
      return Row(
        children: <Widget>[
          Container(
                  child:Row(
                      children: <Widget>[
                        Icon(Icons.attach_money, size: ScreenAdapter.size(30), color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,),
                        Text('雇主身份', style: TextStyle(color:counter.getisShowBackgroundImage ? Colors.white : Colors.black, fontSize: ScreenAdapter.size(23))),
                      ],
                    ),
                  padding: EdgeInsets.all(ScreenAdapter.setWidth(8)),
                  margin: EdgeInsets.only(right: ScreenAdapter.setWidth(10)),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1,color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                SizedBox(width: ScreenAdapter.setWidth(20),),
            Container(
                  child:Row(
                      children: <Widget>[
                        
                        Text('成交笔数：${employerData['employer_order_num']}', style: TextStyle(color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,fontSize: ScreenAdapter.size(23)))
                      ],
                    ),
                  padding: EdgeInsets.all(ScreenAdapter.setWidth(8)),
                  margin: EdgeInsets.only(right: ScreenAdapter.setWidth(10)),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,),
                    borderRadius: BorderRadius.circular(10)
                  ),
                )
        ],
      );
    }else{
      return Row(
              children: <Widget>[
                isCart == 1 ?
                    Row(
                      children: <Widget>[
                        Container( 
                          child:Row(
                            children: <Widget>[
                              Icon(Icons.local_shipping,size: ScreenAdapter.size(30),color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,),
                              SizedBox(width: ScreenAdapter.setWidth(15),),
                              Text('已认证司机身份', style: TextStyle(color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,fontSize: ScreenAdapter.size(23)))
                            ],
                          ), 
                          padding: EdgeInsets.all(ScreenAdapter.setWidth(8)),
                          margin: EdgeInsets.only(right: ScreenAdapter.setWidth(10)),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,),
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        Container( 
                          child:Row(
                            children: <Widget>[
                              Icon(Icons.trending_up, size: ScreenAdapter.size(30),color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,),
                              SizedBox(width: ScreenAdapter.setWidth(15),),
                              Text('成交笔数：${driverData['driver_order_num']}', style: TextStyle(color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,fontSize: ScreenAdapter.size(23)))
                            ],
                          ), 
                          padding: EdgeInsets.all(ScreenAdapter.setWidth(8)),
                          margin: EdgeInsets.only(right: ScreenAdapter.setWidth(10)),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,),
                            borderRadius: BorderRadius.circular(10)
                          ),
                        )
                      ],
                    )
                    :
                    Container( 
                      child: Text('未认证司机身份', style: TextStyle(color:counter.getisShowBackgroundImage ? Colors.white : Colors.black, fontSize: ScreenAdapter.size(23)),),
                        padding: EdgeInsets.all(ScreenAdapter.setWidth(8)),
                        margin: EdgeInsets.only(right: ScreenAdapter.setWidth(10)),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,),
                          borderRadius: BorderRadius.circular(10)
                        ),
                      )
                    ,
                    isCart == 1 ? 
                    Text('')
                    :
                    InkWell(
                      child: Container(
                        // color: Colors.red,
                        height: ScreenAdapter.setHeight(50),
                        child: Row(
                          children: <Widget>[
                            Text('去认证',style: TextStyle(color:counter.getisShowBackgroundImage ? Colors.white : Colors.black,fontSize: ScreenAdapter.size(23))),
                            Icon(Icons.chevron_right,size: ScreenAdapter.size(30),)
                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/authenication_Driver');
                      },
                    )
              ],
            );
    }
  }

  
  // 选择身份
  void showModifyIdentity(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return SimpleDialog(
          title: Text('选择身份', style: TextStyle(fontSize: ScreenAdapter.size(30),)),
          children: <Widget>[
            SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(10)),child: Icon(Icons.attach_money,size: ScreenAdapter.size(30)),),
                  Text('雇主身份', style: TextStyle(fontSize: ScreenAdapter.size(30)),)
                ],
              ),
              onPressed: (){
                Provide.value<Useridentity>(context).modifyindentity(0);
                Navigator.of(context).pop();
                _getEmployerData();
              },
            ),
            SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(10)),child: Icon(Icons.local_shipping,size: ScreenAdapter.size(30)),),      
                  Text('司机身份', style: TextStyle(fontSize: ScreenAdapter.size(30)),)
                ],
              ),
              onPressed: (){
                Provide.value<Useridentity>(context).modifyindentity(1);
                Navigator.of(context).pop();
                _getDriverData();
              },
            )
          ],
        );
      }
    );
  }
}



// 按钮
  Widget _buttonWidget(context, String text, Function fn){
  return RaisedButton(
          child: Text(text),
          onPressed: fn,
          color: Colors.blue,
          textTheme:ButtonTextTheme.primary,
          elevation: 0,
        );
}

// 个人中心操作订单按钮
Widget OrderButton(context, String title,  icon, {number, Function fn}){
  return InkWell(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(icon),
        number != null ? 
        Text('${title}:${number}', style: TextStyle(fontSize: ScreenAdapter.size(25)),) 
        : 
        Text('${title}', style: TextStyle(fontSize: ScreenAdapter.size(25)),)
      ],
    ),
    onTap: fn,
  );
}

// 个人中心用户操作栏
Widget OrderList(BuildContext context, String title, icon, Function fn){
  return InkWell(
          onTap: fn,
          child: Container(
                height: ScreenAdapter.setHeight(70),
                child: Row(
                  children: <Widget>[
                    Icon(icon),
                    Container(
                      margin: EdgeInsets.only(left: ScreenAdapter.setWidth(20)),
                      child: Text('${title}', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Icon(IconData(0xe623, fontFamily: 'myIcon'),color: Colors.black, size: ScreenAdapter.size(30),),
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
  );
}

// 用户页面曲线背景
class BottomClipperTest extends CustomClipper<Path>{
  @override
    Path getClip(Size size) {
      // TODO: implement getClip
      var path = Path();
      path.lineTo(0, 0);
      path.lineTo(0, size.height-ScreenAdapter.setWidth(50));
      var firstControlPoint =Offset(size.width/2,size.height);
      var firstEndPoint = Offset(size.width,size.height-ScreenAdapter.setWidth(50));

      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

      path.lineTo(size.width, size.height-ScreenAdapter.setWidth(50));
      path.lineTo(size.width, 0);

      return path;

    }
    @override
      bool shouldReclip(CustomClipper<Path> oldClipper) {
        // TODO: implement shouldReclip
        return false;
      }

}

// 会员卡
class VipWidget extends CustomClipper<Path>{
  @override
    Path getClip(Size size) {
      // TODO: implement getClip
      var path = Path();
      path.lineTo(0, 0);
      path.lineTo(0, size.height-ScreenAdapter.setWidth(50));
      var firstControlPoint =Offset(size.width/2,size.height);
      var firstEndPoint = Offset(size.width,size.height-ScreenAdapter.setWidth(50));

      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

      path.lineTo(size.width, size.height-ScreenAdapter.setWidth(50));
      path.lineTo(size.width, 0);

      return path;

    }
    @override
      bool shouldReclip(CustomClipper<Path> oldClipper) {
        // TODO: implement shouldReclip
        return false;
      }

}