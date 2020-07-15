import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:dio/dio.dart';
import 'package:project/config/httpHeaders.dart';
import 'package:project/config/api_url.dart';
import 'dart:async';                  // 异步的包
import 'dart:io';

import 'package:project/plugins/PublicStorage.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/alertDialog.dart';                     // 设置属性的时候使用的包

// import 'package:project/pages/model/SwiperModel.dart';

// 为什么要用Future： https://segmentfault.com/a/1190000014396421?utm_source=tag-newest
// Future：可以指定返回值的类型，提高代码可读性

class Api {
  // Map headers = httpHeaders;
  Dio dio = new Dio();
  // 统一Get请求
  Future getData(context, url, {formData}) async {
    try{
      Response response;
      // 获取验证码不需要设置请求头
      if(url != 'getUserCode'){
        // print('------------------Get设置请求头开始--------------');
        dio.options.headers['Authorization'] = await PublicStorage.getHistoryList('token');
        // print('------------------Get设置请求头结束--------------');
      }
      
      // dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded")    // 设置数据返回格式    
      if(formData == null){
        response = await dio.get(path[url]);
      }else{
        response = await dio.get(path[url], queryParameters:formData);
      }
    
      // print('----------------------返回Token---------------------------');
      // print( response.headers.value('authorization'));
       /*
        如果请求200,，并且返回了新的token，那么就替换掉
       */
      if(response.statusCode == 200 && response.headers.value('authorization') != null){
        await PublicStorage.setHistoryList('token', response.headers.value('authorization'));
      }
      
      return response;
    }on DioError catch(e){
      print('get错误：$e');
      if(e == null){
        return null;
      }
      var msg = json.decode(e.response.toString());
      if(e.response.statusCode == 401){
        Navigator.pushNamed(context, '/login');
        return null;
      }
      if(e.response.statusCode == 412){
        _alertDialog(context, msg['msg'], (){
          Navigator.pop(context);
          Navigator.pushNamed(context, '/authenication_Driver');
        });
        return null;
      }
      
      // print(msg);
      Fluttertoast.showToast(msg: msg['msg'],gravity:ToastGravity.CENTER, backgroundColor: Colors.black, textColor: Colors.white);
      
    }
  }
  
  // 统一Post请求
  Future postData(context, url, {formData}) async {
    try{
      Response response;
      // 登录不需要设置请求头
      if(url != 'login'){
        // print('------------------Post设置请求头开始--------------');
        dio.options.headers['Authorization'] = await PublicStorage.getHistoryList('token');
        // print('------------------Post设置请求头结束--------------');
      }
      
      if(formData == null){
        response = await dio.post(path[url]);
      }else{
        response = await dio.post(path[url], data:formData);
      }
      /*
        如果请求200,，并且返回了新的token，那么就替换掉
       */
      if(response.statusCode == 200 && response.headers.value('authorization') != null){
        await PublicStorage.setHistoryList('token', response.headers.value('authorization'));
      }

      return response;
    }on DioError catch(e){
      print('post错误：$e');
      if (e.response != null) {
        if(e.response.statusCode == 401){
          // Navigator.pushNamed(context, '/login');
        }
        var msg = json.decode(e.response.toString());
        alertDialog(context, '提示', msg['msg'], (){
          Navigator.pop(context);
        });
        // Fluttertoast.showToast(msg: msg['msg'],gravity:ToastGravity.CENTER, backgroundColor: Colors.black, textColor: Colors.white);
        
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
  }

   // 统一Put请求
  Future putData(context, url, {formData}) async {
    try{
      Response response;
      // 登录不需要设置请求头
      if(url != 'login'){
        // print('------------------Post设置请求头开始--------------');
        dio.options.headers['Authorization'] = await PublicStorage.getHistoryList('token');
        // print('------------------Post设置请求头结束--------------');
      }
      
      if(formData == null){
        response = await dio.put(path[url]);
      }else{
        response = await dio.put(path[url], data:formData);
      }
      /*
        如果请求200,，并且返回了新的token，那么就替换掉
       */
      if(response.statusCode == 200 && response.headers.value('authorization') != null){
        await PublicStorage.setHistoryList('token', response.headers.value('authorization'));
      }

      return response;
    }on DioError catch(e){
      print('put错误：$e');
      if (e.response != null) {
        if(e.response.statusCode == 401){
          // Navigator.pushNamed(context, '/login');
        }
        var msg = json.decode(e.response.toString());
        Fluttertoast.showToast(msg: msg['msg'],gravity:ToastGravity.CENTER, backgroundColor: Colors.black, textColor: Colors.white);
        
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
  }

  // 统一Put请求
  Future deleteData(context, url, {formData}) async {
    try{
      Response response;
      // 登录不需要设置请求头
      if(url != 'login'){
        // print('------------------Post设置请求头开始--------------');
        dio.options.headers['Authorization'] = await PublicStorage.getHistoryList('token');
        // print('------------------Post设置请求头结束--------------');
      }
      
      if(formData == null){
        response = await dio.delete(path[url]);
      }else{
        response = await dio.delete(path[url], data:formData);
      }
      /*
        如果请求200,，并且返回了新的token，那么就替换掉
       */
      if(response.statusCode == 200 && response.headers.value('authorization') != null){
        await PublicStorage.setHistoryList('token', response.headers.value('authorization'));
      }

      return response;
    }on DioError catch(e){
      print('delete错误：$e');
      if (e.response != null) {
        if(e.response.statusCode == 401){
          // Navigator.pushNamed(context, '/login');
        }
        var msg = json.decode(e.response.toString());
        Fluttertoast.showToast(msg: msg['msg'],gravity:ToastGravity.CENTER, backgroundColor: Colors.black, textColor: Colors.white);
        
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
  }


  _alertDialog(context, msg, fn) {
    showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('$msg'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                onPressed: () {
                  print('点击了取消');
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(
                child: Text('确定',style: TextStyle(fontSize: ScreenAdapter.size(30))),
                onPressed: fn
              )
            ],
          );
        });
  }



  Future jd_getData(url, {formData}) async {
    try{
      Response response;

      if(formData == null){
        response = await dio.get(jd_path[url]);
      }else{
        print(jd_path[url]);
        print(formData);
        response = await dio.get(jd_path[url], queryParameters:formData);
      }
      
      return response;
    }catch(e){
      return print('ERROR:======>${e}');
    }
  }


  Future unified_getData(url, {formData}) async {
    try{
      Response response;

      if(formData == null){
        response = await dio.get(news_path[url]);
      }else{
        response = await dio.get(news_path[url], queryParameters:formData);
      }
      
      return response;
    }catch(e){
      return print('ERROR:======>${e}');
    }
  }
  



}