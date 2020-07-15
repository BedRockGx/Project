import 'package:flutter/material.dart';

import 'ScreenAdapter.dart';

Widget currencyAppBar(String title, context){
  return AppBar(
        leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
        title: Text(title,style: TextStyle(fontSize: ScreenAdapter.size(35))),
        centerTitle: true,
        elevation: 1,
      );
}