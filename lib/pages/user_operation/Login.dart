import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/socket.dart';

import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/PublicStorage.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/config/api.dart';

import 'package:provide/provide.dart';
import 'package:project/provide/userinformation.dart';

import 'package:project/pages/android_back.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phone = new TextEditingController(); // 手机号、验证码
  TextEditingController _verification = new TextEditingController(); // 手机号、验证码
  Timer _timer;
  int _countdownTime = 0;
  bool _isget; // 验证码Widget
  bool _verification_available; // 输入框是否可用

  var api = Api();

  Widget getVerification(val) {
    // print('全局倒计时${val}');
    if (_isget && val == 60 || val == 0) {
      return Text('获取验证码', style: TextStyle(fontSize: ScreenAdapter.size(28)),);
    } else {
      return Text('${val}秒后获取', style: TextStyle(fontSize: ScreenAdapter.size(25)),);
    }
  }
  // 初始化
  @override
  void initState() {
    super.initState();
    // _phone.addListener((){
    //   print(_phone.text);
    // });
    _verification_available = false;
    _isget = true;
  }

  // 销毁时
  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {

    

    // 屏幕适配初始化
    ScreenAdapter.init(context);

    return WillPopScope(
      onWillPop: () async {
        AndroidBackTop.backDeskTop(); //设置为返回不退出app
        return false; //一定要return false
        },
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor:Colors.white,
        //   leading:IconButton(
        //     icon: Icon(
        //       Theme.of(context).platform == TargetPlatform.iOS ? Icons.arrow_back_ios : Icons.arrow_back,
        //       color: Theme.of(context).accentColor,
        //     ),
        //     onPressed: (){
        //       Navigator.of(context).pop();
        //     },
        //   )
        // ),
        body: Provide<UserInfomation>(
          builder: (context,child, val){
            // print('--------------------------倒计时-------------------');
            // print(val.countdownTime);
            return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(height: ScreenAdapter.setHeight(50),),
                      // InkWell(
                      //   child: Container(
                      //     margin: EdgeInsets.all(ScreenAdapter.setWidth(15)),
                      //     child: Icon(Icons.clear, color: Colors.black38,size: ScreenAdapter.size(50),),
                      //   ),
                      //   onTap: (){
                      //     Navigator.pushNamed(context, '/');
                      //   },
                      // ),
                      Container(
                        width: double.infinity, // 自适应全局
                        margin: EdgeInsets.symmetric(horizontal: 25.0),
                        padding: EdgeInsets.fromLTRB(0, 150.0, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text('欢迎登录',
                                  style:
                                      TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 40.0),
                            ),
                            TextField(
                                // autofocus: true,
                                decoration: InputDecoration(
                                  hintText: "请输入手机号",
                                  focusedBorder: UnderlineInputBorder(
                                     borderSide: BorderSide(
                                    color: Colors.blue, //边线颜色为黄色
                                    width: 2, //边线宽度为2
                                  ))
                                  // errorText: ,
                                ),
                                maxLength: 11,
                                controller: _phone, // 表示默认值
                                onChanged: (value) {
                                  _phone.text = value;
                                  //  判断如果手机号可用才能进行验证码操作
                                  if (Plugins.isChinaPhoneLegal(value)) {
                                    setState(() {
                                      _verification_available = true;
                                    });
                                  } else {
                                    setState(() {
                                      _verification_available = false;
                                    });
                                  }
                                  //  将光标一直置于末尾
                                  _phone.selection = TextSelection.fromPosition(
                                      TextPosition(offset: _phone.text.length));
                                },
                                onSubmitted: (val) {
                                  print(_phone.text);
                                  print("点击了键盘上的动作按钮，当前输入框的值为：${val}");
                                },
                                keyboardType: TextInputType.number),
                            SizedBox(height: ScreenAdapter.setHeight(20)),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                      decoration: InputDecoration(
                                        hintText: '输入验证码',
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                          color: Colors.blue, //边线颜色为黄色
                                          width: 2, //边线宽度为2
                                        ))
                                      ),
                                      enabled: _verification_available ? true : false,
                                      controller: _verification,
                                      onChanged: (val) {
                                        _verification.text = val;
                                        _verification.selection = TextSelection.fromPosition(
                                            TextPosition(offset: _verification.text.length));
                                      },
                                      onSubmitted: (val) {
                                        // print("点击了键盘上的动作按钮，当前输入框的值为：${val}");
                                      },
                                      keyboardType: TextInputType.number),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: RaisedButton(
                                    child: getVerification(val.countdownTime),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)),
                                    color: Theme.of(context).accentColor,
                                    textColor: Colors.white,
                                    /*
                                      由于在60秒时，还会显示可点击状态控件
                                      为避免用户重复点击，在全局倒计时开始的时候，先自减1，所以真正开始倒计时是从59开始的
                                     */

                                    onPressed:  val.countdownTime == 0 || val.countdownTime == 60 &&  _verification_available ?   () {
                                      if (_verification_available && val.countdownTime == 60) {
                                        print(_phone.text is String);
                                        api.getData(context, 'getUserCode', formData: {'phone':_phone.text}).then((val){
                                          if(val == null ){
                                            return ;
                                          }
                                          var msg = json.decode(val.toString());
                                          Fluttertoast.showToast(
                                            msg: '${msg['msg']}',
                                            backgroundColor: Colors.black, textColor: Colors.white
                                          );
                                        });

                                        setState(() {
                                          // _countdownTime = 60;
                                          _isget = false;
                                        });
                                        //开始倒计时
                                        // startCountdownTimer();
                                        Provide.value<UserInfomation>(context).startCountdownTimer();
                                      } else {
                                        if (val.countdownTime == 60) {
                                          Fluttertoast.showToast(msg: '请输入正确的手机号', backgroundColor: Colors.black, textColor: Colors.white);
                                          return;
                                        } else {
                                          Fluttertoast.showToast(msg: '请稍后获取验证码', backgroundColor: Colors.black, textColor: Colors.white);
                                        }
                                      }

                                      // print('手机号是${_phone.text}, 验证码是${_verification.text}');
                                    } : null,
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                            SizedBox(height: ScreenAdapter.setHeight(30)),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: ScreenAdapter.setHeight(80),
                                    child: RaisedButton(
                                      child: Text(
                                        '登录',
                                        style: TextStyle(),
                                      ),
                                      color: Theme.of(context).accentColor,
                                      textTheme: ButtonTextTheme.primary,
                                      onPressed: () {
                                        print('点击');
                                        if (_verification_available) {
                                          api.postData(context, 'login', formData: {'phone':_phone.text, 'code':_verification.text}).then((val){
                                            if(val == null ){
                                              return ;
                                            }
                                            var res = json.decode(val.toString());
                                            print(res['rongcloud_token']);
                                            if(val.statusCode == 200){
                                              Provide.value<UserInfomation>(context).setToken(val.headers.value('authorization'));
                                              PublicStorage.setHistoryList('rongcloud_token', res['rongcloud_token']);
                                              // 一旦登录成功那么就连接socket
                                              var socket = new ClientSocket();
                                              socket.Connect(context);
                                              Navigator.pushNamed(context, '/tab');
                                            }
                                          });
                                        }
                                      },
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
         
        ,
            );
             
          },
        )
    ),
      );
    
  }
}
