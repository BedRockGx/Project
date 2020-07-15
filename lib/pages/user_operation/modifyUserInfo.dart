import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/config/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../plugins/PublicStorage.dart';


class ModifyUserInfo extends StatefulWidget {
  var arr;
  ModifyUserInfo(this.arr);
  @override
  _ModifyUserInfoState createState() => _ModifyUserInfoState(this.arr);
}

class _ModifyUserInfoState extends State<ModifyUserInfo> {

  var data,imageUrl, uploadImage;
  _ModifyUserInfoState(this.data);

  var base_url = 'https://flutter.ikuer.cn/'; 
  TextEditingController _username = TextEditingController();
  TextEditingController _userPhone = TextEditingController();
  TextEditingController _msgController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    imageUrl = '$base_url${data['head_pic']}';

  }

  var _file;
  // var _croppFile;        // 展示手机本地图片路径图片

  var api = Api();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40),), onPressed: ()=>Navigator.pop(context),),
          title: Container(
            child: Text('个人资料',style: TextStyle(fontSize: ScreenAdapter.size(35))),
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child: ListView(
              children: <Widget>[
                Container(
                  child: Column(
                  children: <Widget>[
                    InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenAdapter.setWidth(20)),
                    color: Colors.white,
                    height: ScreenAdapter.setHeight(150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '头像',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenAdapter.size(28)),
                        ),
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                              radius: 20.0,
                            ),
                            Icon(Icons.chevron_right)
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: showSelectPicker,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(20)),
                  child: Divider(),
                ),
                UserInfoList('昵称', '${data['nickname']}', (){
                    showModifyUserName('修改用户昵称', 8, _username, TextInputType.text, (){
                    
                    api.putData(context, 'modifyUserName', formData: {'nickname':_username.text}).then((val){
                      if(val == null){
                        return;
                      }
                      var response = json.decode(val.toString());
                      Fluttertoast.showToast(msg: response['msg']);
                      setState(() {
                        data['nickname'] = _username.text;
                        _username.text = '';
                      });
                      Navigator.pop(context);
                    });
                  });
                }),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(20)),
                  child: Divider(),
                ),
                UserInfoList('手机号', '${data['phone']}', (){
                  showModifyUserName('修改绑定手机号', 11, _userPhone, TextInputType.number, (){
                    if(_userPhone.text == '' || _msgController.text == ''){
                      Fluttertoast.showToast(msg: '请输入手机号或验证码');
                      return;
                    }
                    var isPhone = Plugins.isChinaPhoneLegal(_userPhone.text);
                    !isPhone ? Fluttertoast.showToast(msg: '手机号不规范！') 
                    :
                   
                    api.putData(context, 'modifyUserPhone', formData: {'phone':_userPhone.text, 'code':_msgController.text}).then((val){
                      if(val ==null){
                        return;
                      }
                      var response = json.decode(val.toString());
                      Fluttertoast.showToast(msg: response['msg'] );
                      setState(() {
                        data['phone'] = _userPhone.text;
                        _userPhone.text = '';
                        _msgController.text = '';
                      });
                      Navigator.pop(context);
                      
                    });
                    
                    
                  });
                }),
                  ],
                ),
                color: Colors.white,
                )
                
                // Text('')
                // 展示本地手机路径图片
                // _croppFile != null ? Image.file(_croppFile) : Text('')
              ],
            ),
        
          )
          ));
   
  }
  // 修改用户信息
    showModifyUserName(String title, int length, controller, type, fn){
    showDialog(
      context:context,
      builder:(context){
        return AlertDialog(
          title: Text('${title}'),
          content: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                // border: Border.all(width: 1, color: Colors.black45)
              ),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: controller,
                    keyboardType:type,
                    decoration: InputDecoration(
                      hintText: '最多${length}位',
                    ),
                    maxLength: length,
                  ),
                  controller == _userPhone ? 
                   Row(
                     children: <Widget>[
                       Expanded(
                         flex: 2,
                         child: TextField(
                            controller: _msgController,
                            keyboardType:type,
                            decoration: InputDecoration(
                              hintText: '请输入验证码',
                            ),
                          ),
                       ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: ScreenAdapter.setWidth(20),
                          child: OutlineButton(
                            child: Text('验证码'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ScreenAdapter.setWidth(30))
                            ),
                            onPressed: (){
                              if(_userPhone.text == ''){
                                Fluttertoast.showToast(msg: '请输入手机号码！');
                                return;
                              }
                              print(_userPhone.text);
                              api.getData(context, 'getUserCode', formData: {'phone':_userPhone.text}).then((val){
                                if(val == null ){
                                  return ;
                                }
                                var msg = json.decode(val.toString());
                                Fluttertoast.showToast(
                                  msg: msg['msg'],
                                  backgroundColor: Colors.black, textColor: Colors.white
                                );
                              });
                            },
                          ),
                        )
                      )
                     ],
                   )
                  :
                  SizedBox()
                ],
              )
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('确定', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
              onPressed: fn
            )
          ],
        );
      }
    );
  }

  // 选择图片
  showSelectPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: ScreenAdapter.setHeight(200),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  var file = await Plugins.takePhoto();
                  if(file!=null){
                    // 获取图片路径
                    setState(() {
                      _file = file;
                    });
                    // 关闭弹窗
                    Navigator.pop(context);
                    // 获取裁剪后地址
                    
                    var croppFile = await Plugins.cropImage(context, file.path, false);
                    // 请求接口上传图片
                    if(croppFile!=null){
                      api.postData(context, 'uploadFile', formData: await FormData1(croppFile.path)).then((val){
                        var imgurl = json.decode(val.toString())['file_path'];
                        setState(() {
                          uploadImage = imgurl;
                          imageUrl = '$base_url$imgurl';
                        });
                        PublicStorage.setHistoryList('UserInfo', {"head_pic":imageUrl});
                        _modifyImage();
                      });
                    }
                  }
                  
                },
                child: Container(
                  alignment: Alignment.center,
                  height: ScreenAdapter.setHeight(100),
                  child: Text('拍照'),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.black26
                      )
                    )
                  ),
                ),
              ),
              InkWell(
                onTap: ()  async {
                  var file = await Plugins.openGallery();
                  print('-----------------图片路径--------------');
                  if(file!=null){
                    
                    setState(() {
                      _file = file;
                    });
                    
                    Navigator.pop(context);
                    var croppFile = await Plugins.cropImage(context, file.path, false);

                    if(croppFile!=null){
                      api.postData(context, 'uploadFile', formData: await FormData1(croppFile.path)).then((val){
                        var imgurl = json.decode(val.toString())['file_path'];
                        setState(() {
                          uploadImage = imgurl;
                          imageUrl = '$base_url$imgurl';
                        });
                        _modifyImage();
                      });
                    }
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: ScreenAdapter.setHeight(100),
                  child: Text('相册选择'),
                ),
              )
            ],
          )
        );
      }
    );
  }

  // 修改图片接口
  _modifyImage() async {
    api.putData(context, 'modifyUserImage', formData: {'head_pic':uploadImage}).then((val){
        var response = json.decode(val.toString());
        Fluttertoast.showToast(msg: response['msg']);
      });
      
  }

 // dio上传文件FormData格式
  Future<FormData> FormData1(fileUrl) async {
    return FormData.fromMap({
      "file": await MultipartFile.fromFile(fileUrl)
    });
  }

  // 用户信息列表
  Widget UserInfoList(String title, String subtitle, Function fn) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20)),
        color: Colors.white,
        height: ScreenAdapter.setHeight(150),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${title}',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: ScreenAdapter.size(28)),
            ),
            Row(
              children: <Widget>[Text('${subtitle}', style: TextStyle(fontSize: ScreenAdapter.size(30)),), Icon(Icons.chevron_right)],
            )
          ],
        ),
      ),
      onTap: fn
    );
  }
}
