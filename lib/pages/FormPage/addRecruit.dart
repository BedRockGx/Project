import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/alertDialog.dart';
import 'package:project/plugins/currencyAppBar.dart';

class AddRecruitPage extends StatefulWidget {
  @override
  _AddRecruitPageState createState() => _AddRecruitPageState();
}

class _AddRecruitPageState extends State<AddRecruitPage> {
  TextEditingController _titleController = new TextEditingController(); // 标题控制器
  TextEditingController _startPriceController =
      new TextEditingController(); // 标题控制器
  TextEditingController _endPriceController =
      new TextEditingController(); // 标题控制器
  TextEditingController _phoneController = new TextEditingController(); // 标题控制器
  TextEditingController _describeController =
      new TextEditingController(); // 标题控制器
  GlobalKey _formKey = new GlobalKey<FormState>();

  final titleWidth = ScreenAdapter.setWidth(150);
  final containerHeight = ScreenAdapter.setHeight(80);

  var api = new Api();

  @override
  void dispose() {
    _formKey = null;
    _titleController = null;
    _startPriceController = null;
    _endPriceController = null;
    _phoneController = null;
    _describeController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: currencyAppBar('发布招聘', context),
        body: Container(
            color: Color(0xfff3f3f3),
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: Container(
                  color: Color.fromRGBO(233, 233, 233, 0.5),
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(ScreenAdapter.setWidth(30)),
                          margin:
                              EdgeInsets.only(top: ScreenAdapter.setWidth(20)),
                          child: Form(
                            key: _formKey, //设置globalKey，用于后面获取FormState
                            autovalidate: true, //开启自动校验
                            child: Column(
                              children: <Widget>[
                                Container(
                                  // height: containerHeight,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: titleWidth,
                                        child: Text(
                                          '标题：',
                                          style: TextStyle(
                                              fontSize: ScreenAdapter.size(28)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                            controller: _titleController,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    100, 100, 100, 0.9),
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    ScreenAdapter.size(30)),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              // labelText: "请输入标题",
                                            ),
                                            validator: (v) {
                                              if (v == '') {
                                                return null;
                                              }
                                              return 4 <= v.trim().length &&
                                                      v.trim().length <= 30
                                                  ? null
                                                  : "4-30字";
                                            }
                                          ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      // color: Colors.green,
                                      border: Border(
                                          bottom: BorderSide(
                                              width:
                                                  ScreenAdapter.setWidth(0.5),
                                              color: Colors.grey))),
                                ),
                                Container(
                                    height: ScreenAdapter.setHeight(80),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width:
                                                    ScreenAdapter.setWidth(0.5),
                                                color: Colors.grey))),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: titleWidth,
                                          child: Text('起始薪资：',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenAdapter.size(28))),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 3,
                                                child: TextFormField(
                                                  inputFormatters: [
                                                    WhitelistingTextInputFormatter
                                                        .digitsOnly
                                                  ], // 只允许输入数字
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          100, 100, 100, 0.9),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          ScreenAdapter.size(
                                                              30)),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      _startPriceController,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintStyle: TextStyle(
                                                          fontSize:
                                                              ScreenAdapter
                                                                  .size(30))),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                  'k (单位千,1-100之间)',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: ScreenAdapter.size(30)
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                                Container(
                                    height: ScreenAdapter.setHeight(80),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width:
                                                    ScreenAdapter.setWidth(0.5),
                                                color: Colors.grey))),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: titleWidth,
                                          child: Text('起始薪资：',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenAdapter.size(28))),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 3,
                                                child: TextFormField(
                                                  inputFormatters: [
                                                    WhitelistingTextInputFormatter
                                                        .digitsOnly
                                                  ], // 只允许输入数字
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          100, 100, 100, 0.9),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          ScreenAdapter.size(
                                                              30)),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      _endPriceController,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintStyle: TextStyle(
                                                          fontSize:
                                                              ScreenAdapter
                                                                  .size(30))),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                  'k (单位千,1-100之间)',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: ScreenAdapter.size(30)
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                                Container(
                                  // height: containerHeight,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: titleWidth,
                                        child: Text(
                                          '联系方式：',
                                          style: TextStyle(
                                              fontSize: ScreenAdapter.size(28)),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly
                                            ], // 只允许输入数字
                                            keyboardType: TextInputType.number,
                                            controller: _phoneController,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    100, 100, 100, 0.9),
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    ScreenAdapter.size(30)),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            // 校验手机号
                                            validator: (v) {
                                              if (v == '') {
                                                return null;
                                              }
                                              return Plugins.isChinaPhoneLegal(
                                                      v)
                                                  ? null
                                                  : "手机号不符合";
                                            }
                                          ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      // color: Colors.green,
                                      border: Border(
                                          bottom: BorderSide(
                                              width:
                                                  ScreenAdapter.setWidth(0.5),
                                              color: Colors.grey))),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: titleWidth,
                                        child: Text('职位详情：',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenAdapter.size(28))),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: TextFormField(
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    100, 100, 100, 0.9),
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 1.0,
                                                fontSize:
                                                    ScreenAdapter.size(30)),
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 7,
                                            controller: _describeController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "",
                                                hintStyle: TextStyle(
                                                    fontSize:
                                                        ScreenAdapter.size(
                                                            30))),
                                            // 校验详情
                                            validator: (v) {
                                              if (v == '') {
                                                return null;
                                              }
                                              return 5 <= v.trim().length &&
                                                      v.trim().length <= 200
                                                  ? null
                                                  : "5-200字";
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: ScreenAdapter.setWidth(30)),
                      padding: EdgeInsets.only(top: 28.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                '发布',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenAdapter.size(30),
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Color(0xffff8080),
                              textTheme: ButtonTextTheme.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () {
                                if ((_formKey.currentState as FormState)
                                    .validate()) {

                                      print({
                                    'title': _titleController.text, // 标题
                                    'content': _describeController.text, // 内容
                                    'contact': _phoneController.text,     // 联系方式
                                    'start_salary':_startPriceController.text,    // 起始薪资
                                    'end_salary':_endPriceController.text   //最大薪资
                                  });
                                  FormData formData = FormData.fromMap({
                                    'title': _titleController.text, // 标题
                                    'content': _describeController.text, // 内容
                                    'contact': _phoneController.text,     // 联系方式
                                    'start_salary':_startPriceController.text,    // 起始薪资
                                    'end_salary':_endPriceController.text   //最大薪资
                                  });

                                 api.postData(context, 'add_recruit',formData: formData).then((val){
                                   if(val == null){
                                     return;
                                   }
                                  
                                   var response = json.decode(val.toString());
                                   print(response);
                                  //  Fluttertoast.showToast(msg: response['msg']);
                                    // Navigator.pop(context);
                                   alertDialog(context, '提示', '招聘发布成功，是否关闭本页面', (){
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                 });

                                } else {
                                  print('没通过');
                                }
                              },
                            ),
                          )
                        ],
                      ))
                    ],
                  ))),
            )));
  }
}
