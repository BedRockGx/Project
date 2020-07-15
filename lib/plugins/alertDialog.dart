import 'package:flutter/material.dart';

import 'ScreenAdapter.dart';

alertDialog(context, title,content, fn) {
    showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
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
                onPressed: fn
              )
            ],
          );
        });
  }