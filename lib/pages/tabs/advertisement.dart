import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:flutter_demo/view/HomePage.dart';

class SplashPage extends StatefulWidget{

  SplashPage({Key key}):super(key:key);
  @override
  _SplashPage createState()=> new _SplashPage();

}

class _SplashPage extends State<SplashPage>{

  bool isStartHomePage = false;
  Timer timer;
  var count = 3;

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      new Image.asset(
        "assets/images/sp.png",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
      new Positioned(
        top: 20.0,
        right: 10.0,
        child: new FlatButton(
          child: new Text(
            '跳过 ${count}',
            style: new TextStyle(color: Colors.white),
          ),
          color: Color.fromARGB(55, 0, 0, 0),
          onPressed: () {
            goHomePage();
          },
        ),
      ),
    ]);
  }

  //页面初始化状态的方法
  @override
  void initState() {
    super.initState();
    //开启倒计时
    countDown();
  }

  void countDown() {
    timer = new Timer(new Duration(seconds: 1), () {
      // 只在倒计时结束时回调
      if (count != 1) {
        setState(() {
          count = count - 1;
          countDown();
        });
      } else {
        timer.cancel();
        goToHomePage();
      }
    });
    //设置倒计时三秒后执行跳转方法
    
    // var duration = new Duration(seconds: 3);
    // new Future.delayed(duration, goToHomePage);
  }
  goHomePage(){
    //跳转主页 且销毁当前页面
    Navigator.pushNamed(context, '/tab');
    isStartHomePage=true;
  }
  void goToHomePage(){
    //如果页面还未跳转过则跳转页面
    if(!isStartHomePage){
      //跳转主页 且销毁当前页面
      Navigator.pushNamed(context, '/tab');
      isStartHomePage=true;
    }
  }
}
