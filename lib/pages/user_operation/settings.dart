import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/api.dart';
import 'package:project/pages/EventBus/bus.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/provide/Useridentity.dart';
import 'package:provide/provide.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var switchVlue = false;
  var api = new Api();
  var base_url = 'https://flutter.ikuer.cn'; // baserUrl接口

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            IconData(0xe622, fontFamily: 'myIcon'),
            size: ScreenAdapter.size(40),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          child: Text('设置',style: TextStyle(fontSize: ScreenAdapter.size(35))),
        ),
        centerTitle: true,
        // backgroundColor: Colors.grey[200],
        elevation: 1.0,
      ),
      body: Container(
        color: Color(0xfff3f3f3),
        child: Column(
          children: <Widget>[
            Container(
              margin:
                  EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(30)),
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(30)),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(ScreenAdapter.setWidth(15)),
                    height: ScreenAdapter.setHeight(80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '设置头像为背景图',
                          style: TextStyle(fontSize: ScreenAdapter.size(32)),
                        ),
                        Provide<Useridentity>(
                          builder: (context, child, val) {
                            return CupertinoSwitch(
                              value: val.getisShowBackgroundImage,
                              onChanged: (bool value) async {
                                Provide.value<Useridentity>(context)
                                      .modifyShowBackgroundImage(value);
                                await PublicStorage.setHistoryList('ShowBackgroundImage', value);
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenAdapter.setHeight(0.5),
                    color: Colors.black26,
                    // margin: ,
                  ),
                  InkWell(
                    onTap: () async {
                      var version = await Plugins.getPackageInfo(context);
                      api.getData(context, 'update').then((val) {
                        // print('-------------获取版本信息--------------');
                        // print(json.decode(val.toString()));
                        var response = json.decode(val.toString());
                        // 如果当前版本比服务器小，返回-1，大返回1，相等返回0
                        var isUpdate =
                            version.compareTo(response['version_no']);
                        var app_url = '$base_url${response['app_path']}';

                        if (isUpdate.toString() == '-1') {
                          Plugins.showUpdateDialog(context, app_url);
                        } else {
                          Fluttertoast.showToast(msg: '最新版本为：$version，不需要更新');
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left:ScreenAdapter.setWidth(15), right: ScreenAdapter.setWidth(15), top: ScreenAdapter.setWidth(15), bottom:ScreenAdapter.setWidth(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('检查更新',
                              style:
                                  TextStyle(fontSize: ScreenAdapter.size(32))),
                          Icon(IconData(0xe623, fontFamily: 'myIcon'), size: ScreenAdapter.size(32))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(30)),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                    padding: EdgeInsets.all(ScreenAdapter.setWidth(15)),
                    height: ScreenAdapter.setHeight(80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '关于',
                          style: TextStyle(fontSize: ScreenAdapter.size(32)),
                        ),
                        Icon(IconData(0xe623, fontFamily: 'myIcon'), size: ScreenAdapter.size(32))
                      ],
                    ),
                  ),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenAdapter.setHeight(0.5),
                    color: Colors.black26,
                    // margin: ,
                  ),
                  InkWell(
                    onTap: (){
                      _alertDialog();
                    },
                    child: Container(
                      padding: EdgeInsets.only(left:ScreenAdapter.setWidth(15), right: ScreenAdapter.setWidth(15), top: ScreenAdapter.setWidth(15), bottom:ScreenAdapter.setWidth(25)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('退出登录',
                              style:
                                  TextStyle(fontSize: ScreenAdapter.size(32))),
                          Icon(IconData(0xe623, fontFamily: 'myIcon'), size: ScreenAdapter.size(32),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  // 退出登录
  _alertDialog() {
    showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('退出'),
            content: Text('您确定要退出吗？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                onPressed: () {
                  print('点击了取消');
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(
                child: Text('确定', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                onPressed: () async {
                  // 只有异步才能删掉
                  var token =await PublicStorage.getHistoryList('token');
                  print(token[0]);
                  // 删除掉token
                  await PublicStorage.removeHistoryData('token');
                  
                  Navigator.pushNamed(context, '/login');

                  Fluttertoast.showToast(msg: '成功退出',);
                },
              )
            ],
          );
        });
  }
}
