import 'package:flutter/material.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/ScreenAdapter.dart';

class StackLoading extends StatelessWidget {
  Widget widget;
  bool visible;
  StackLoading({@required this.widget, this.visible});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget,
        Visibility(
          visible: visible,
          child: Positioned(
              top: 0,
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                width: ScreenAdapter.getScreenWidth(),
                height: ScreenAdapter.getScreenHeight(),
                child: Container(
                  margin: EdgeInsets.only(bottom: ScreenAdapter.setHeight(150)),
                  child: Loading(text: '', colors: Colors.white, textColors: Colors.white,),
                )
              ),
            ),
        )
      ],
    );
  }
}