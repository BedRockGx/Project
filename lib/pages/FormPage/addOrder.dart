import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:project/plugins/Plugins.dart';
import 'package:city_pickers/city_pickers.dart'; // 省市区选择器

import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
// import 'package:project/plugins/SelectDate.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  TextEditingController _titleController = new TextEditingController(); // 标题
  TextEditingController _phoneController = new TextEditingController(); // 联系方法
  TextEditingController _cartnumController =
      new TextEditingController(); // 司机人数
  TextEditingController _priceController = new TextEditingController(); // 价钱
  // int _priceunitController = 1; // 价钱单位
  TextEditingController _addressdetailsController =
      new TextEditingController(); // 详情
  TextEditingController _detailsController = new TextEditingController(); // 详情
  var _startDate = null; // 开始时间
  var _endDate = null; // 结束时间
  var _unitamountController; // 时间差
  var totalPrice; // 总价

  DateTimePickerLocale _locale = DateTimePickerLocale.zh_cn;
  String _format = 'yyyy-MMMM-dd';
  DateTime _dateTime;

  var adCode,
      city,
      position_addr,
      province,
      county,
      lat,
      lng; // 城市编码，城市, 定位选择地址, 省份, 区， 纬度、经度

  var originalStartDate, originalEndDate; // 存储时间选择的DateTime格式的时间用来比较开始和结束是否一致

  bool visible = false;

  var api = new Api();

  GlobalKey _formKey = new GlobalKey<FormState>();

  final titleWidth = ScreenAdapter.setWidth(150);

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    // 防止用户一进来 没有允许定位，就来发布订单, 所以就新存储一波定位数据
    Plugins.getLocation(context, isAdd: true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _formKey = null;
    _titleController = null;
    _phoneController =null;
    _cartnumController =null;
    _priceController = null;
    _addressdetailsController = null;
    _detailsController = null;
    super.dispose();
  }

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
            child: Text('发布订单',style: TextStyle(fontSize: ScreenAdapter.size(35))),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Container(
              color: Color.fromRGBO(233, 233, 233, 0.5),
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: ScreenAdapter.setWidth(20)),
                      padding: EdgeInsets.all(ScreenAdapter.setWidth(30)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        key: _formKey, //设置globalKey，用于后面获取FormState
                        autovalidate: true, //开启自动校验
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: titleWidth,
                                    child: Text(
                                      '任务标题：',
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
                                            fontSize: ScreenAdapter.size(30)),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // labelText: "请输入标题",
                                            hintText: "请输入任务标题",
                                            hintStyle: TextStyle(
                                                fontSize:
                                                    ScreenAdapter.size(30))),
                                        validator: (v) {
                                          if (v == '') {
                                            return null;
                                          }
                                          return 0 <= v.trim().length &&
                                                  v.trim().length <= 30
                                              ? null
                                              : "最多30个字！";
                                        }),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  // color: Colors.green,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: ScreenAdapter.setWidth(0.5),
                                          color: Colors.grey))),
                            ),

                            // Container(
                            //   decoration: BoxDecoration(
                            //       border: Border(
                            //           bottom: BorderSide(
                            //               width: ScreenAdapter.setWidth(0.5),
                            //               color: Colors.grey))),
                            //   child: Row(
                            //     children: <Widget>[
                            //       Container(
                            //         width: titleWidth,
                            //         child: Text('内容：',
                            //             style: TextStyle(
                            //                 fontSize: ScreenAdapter.size(28))),
                            //       ),
                            //       Expanded(
                            //         flex: 1,
                            //         child: TextFormField(
                            //             style: TextStyle(
                            //                 color: Color.fromRGBO(
                            //                     100, 100, 100, 0.9),
                            //                 fontWeight: FontWeight.w500,
                            //                 letterSpacing: 1.0,
                            //                 fontSize: ScreenAdapter.size(30)),
                            //             keyboardType: TextInputType.multiline,
                            //             maxLines: 7,
                            //             controller: _detailsController,
                            //             decoration: InputDecoration(
                            //                 border: InputBorder.none,
                            //                 hintText: "请输入任务内容",
                            //                 hintStyle: TextStyle(
                            //                     fontSize:
                            //                         ScreenAdapter.size(30))),
                            //             // 校验详情
                            //             validator: (v) {
                            //               if (v == '') {
                            //                 return null;
                            //               }
                            //               return 0 <= v.trim().length &&
                            //                       v.trim().length <= 200
                            //                   ? null
                            //                   : "最多200字！";
                            //             }),
                            //       )
                            //     ],
                            //   ),
                            // ),

                            Container(
                              height: ScreenAdapter.setHeight(80),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: ScreenAdapter.setWidth(0.5),
                                            color: Colors.grey))),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: titleWidth,
                                      child: Text('单价：',
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenAdapter.size(28))),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          // Positioned(
                                          //   left: 0,
                                          //   bottom: ScreenAdapter.setHeight(20),
                                          //   child: Text('¥'),
                                          // ),
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
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    ScreenAdapter.size(30)),
                                            keyboardType: TextInputType.number,
                                            controller: _priceController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(
                                                  IconData(0xe618,
                                                      fontFamily: 'myIcon'),
                                                  size: ScreenAdapter.size(25),
                                                  color: Colors.grey,
                                                ),
                                                hintStyle: TextStyle(
                                                    fontSize:
                                                        ScreenAdapter.size(
                                                            30))),
                                              onChanged: (_){
                                                completePrice(_cartnumController.text, _priceController.text);
                                              },
                                          ),
                                          ),
                                           Expanded(
                                             flex: 5,
                                             child: Text(
                                              '元/人',
                                              style: TextStyle(
                                                color: Colors.grey, fontSize: ScreenAdapter.size(30)
                                              ),
                                            ),
                                           )
                                        ],
                                      ),
                                    )
                                  ],
                                )),

                            // InkWell(
                            //   child: Container(
                            //     height: ScreenAdapter.setHeight(80),
                            //     child: Align(
                            //         alignment: Alignment.centerLeft,
                            //         child: Row(
                            //           children: <Widget>[
                            //             Container(
                            //               width: titleWidth,
                            //               child: Text('开始时间：',
                            //                   style: TextStyle(
                            //                       fontSize:
                            //                           ScreenAdapter.size(28))),
                            //             ),
                            //             Expanded(
                            //               flex: 1,
                            //               child: Row(
                            //                 children: <Widget>[
                            //                   Icon(
                            //                     Icons.access_time,
                            //                     color: Colors.grey,
                            //                     size: ScreenAdapter.size(35),
                            //                   ),
                            //                   SizedBox(
                            //                     width:
                            //                         ScreenAdapter.setWidth(20),
                            //                   ),
                            //                   Text(
                            //                     _startDate == null
                            //                         ? '点击选择时间'
                            //                         : _startDate,
                            //                     style: TextStyle(
                            //                         color: Colors.grey,
                            //                         fontWeight: FontWeight.w500,
                            //                         fontSize:
                            //                             ScreenAdapter.size(30)),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             Container(
                            //               child: Icon(
                            //                 IconData(0xe623,
                            //                     fontFamily: 'myIcon'),
                            //                 color: Colors.grey,
                            //                 size: ScreenAdapter.size(25),
                            //               ),
                            //             )
                            //           ],
                            //         )),
                            //     decoration: BoxDecoration(
                            //         // color: Colors.green,
                            //         border: Border(
                            //             bottom: BorderSide(
                            //                 width: ScreenAdapter.setWidth(0.5),
                            //                 color: Colors.grey))),
                            //   ),
                            //   onTap: () {
                            //     DatePicker.showDatePicker(
                            //       context,
                            //       pickerTheme: DateTimePickerTheme(
                            //         showTitle: true,
                            //         confirm: Text('确定',
                            //             style: TextStyle(color: Colors.grey)),
                            //         cancel: Text('取消',
                            //             style: TextStyle(color: Colors.grey)),
                            //       ),
                            //       minDateTime: DateTime.now(),
                            //       maxDateTime: DateTime.now()
                            //           .add(new Duration(days: 360)),
                            //       initialDateTime: _dateTime,
                            //       dateFormat: _format,
                            //       locale: _locale,
                            //       onClose: () => print("----- onClose -----"),
                            //       onCancel: () => print('onCancel'),
                            //       onChange: (val, List<int> index) {
                            //         if (val == null) {
                            //           return null;
                            //         }
                            //         var startVal = val
                            //             .toString()
                            //             .substring(0, 10)
                            //             .split('-')
                            //             .join('/');
                            //         print(startVal);
                            //         setState(() {
                            //           originalStartDate = val
                            //               .toString()
                            //               .substring(0, 10)
                            //               .split('-');
                            //           _startDate = startVal;
                            //           _unitamountController =
                            //               Plugins.getDateDiff(
                            //                   _startDate, _endDate);
                            //         });
                            //       },
                            //       onConfirm: (val, List<int> index) {
                            //         if (val == null) {
                            //           return null;
                            //         }
                            //         var startVal = val
                            //             .toString()
                            //             .substring(0, 10)
                            //             .split('-')
                            //             .join('/');
                            //         print(startVal);
                            //         completePrice(_cartnumController.text, _priceController.text, _unitamountController);
                            //         setState(() {
                            //           originalStartDate = val
                            //               .toString()
                            //               .substring(0, 10)
                            //               .split('-');
                            //           _startDate = startVal;
                            //           _unitamountController =
                            //               Plugins.getDateDiff(
                            //                   _startDate, _endDate);
                            //         });
                            //       },
                            //     );
                            //   },
                            // ),

                            // InkWell(
                            //   child: Container(
                            //     height: ScreenAdapter.setHeight(80),
                            //     child: Align(
                            //         alignment: Alignment.centerLeft,
                            //         child: Row(
                            //           children: <Widget>[
                            //             Container(
                            //               width: titleWidth,
                            //               child: Text('结束时间：',
                            //                   style: TextStyle(
                            //                       fontSize:
                            //                           ScreenAdapter.size(28))),
                            //             ),
                            //             Expanded(
                            //               flex: 1,
                            //               child: Row(
                            //                 children: <Widget>[
                            //                   Icon(
                            //                     Icons.access_time,
                            //                     color: Colors.grey,
                            //                     size: ScreenAdapter.size(35),
                            //                   ),
                            //                   SizedBox(
                            //                     width:
                            //                         ScreenAdapter.setWidth(20),
                            //                   ),
                            //                   Text(
                            //                     _endDate == null
                            //                         ? '点击选择时间'
                            //                         : _endDate,
                            //                     style: TextStyle(
                            //                         color: Colors.grey,
                            //                         fontWeight: FontWeight.w500,
                            //                         fontSize:
                            //                             ScreenAdapter.size(30)),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             Container(
                            //               child: Icon(
                            //                 IconData(0xe623,
                            //                     fontFamily: 'myIcon'),
                            //                 color: Colors.grey,
                            //                 size: ScreenAdapter.size(25),
                            //               ),
                            //             )
                            //           ],
                            //         )),
                            //     decoration: BoxDecoration(
                            //         // color: Colors.green,
                            //         border: Border(
                            //             bottom: BorderSide(
                            //                 width: ScreenAdapter.setWidth(0.5),
                            //                 color: Colors.grey))),
                            //   ),
                            //   onTap: () {
                            //     DatePicker.showDatePicker(
                            //       context,
                            //       pickerTheme: DateTimePickerTheme(
                            //         showTitle: true,
                            //         confirm: Text('确定',
                            //             style: TextStyle(color: Colors.grey)),
                            //         cancel: Text('取消',
                            //             style: TextStyle(color: Colors.grey)),
                            //       ),
                            //       minDateTime: DateTime.now(),
                            //       maxDateTime: DateTime.now()
                            //           .add(new Duration(days: 360)),
                            //       initialDateTime: _dateTime,
                            //       dateFormat: _format,
                            //       locale: _locale,
                            //       onClose: () => print("----- onClose -----"),
                            //       onCancel: () => print('onCancel'),
                            //       onChange: (val, List<int> index) {
                            //         if (val == null) {
                            //           return null;
                            //         }
                            //         var endVal = val
                            //             .toString()
                            //             .substring(0, 10)
                            //             .split('-')
                            //             .join('/');
                            //         setState(() {
                            //           originalEndDate = val
                            //               .toString()
                            //               .substring(0, 10)
                            //               .split('-');
                            //           _endDate = endVal;
                            //           _unitamountController =
                            //               Plugins.getDateDiff(
                            //                   _startDate, _endDate);
                            //         });
                            //       },
                            //       onConfirm: (val, List<int> index) {
                            //         if (val == null) {
                            //           return null;
                            //         }
                            //         var endVal = val
                            //             .toString()
                            //             .substring(0, 10)
                            //             .split('-')
                            //             .join('/');
                            //             completePrice(_cartnumController.text, _priceController.text, _unitamountController);
                            //         setState(() {
                            //           originalEndDate = val
                            //               .toString()
                            //               .substring(0, 10)
                            //               .split('-');
                            //           _endDate = endVal;
                            //           _unitamountController =
                            //               Plugins.getDateDiff(
                            //                   _startDate, _endDate);
                            //         });
                            //       },
                            //     );
                            //   },
                            // ),

                            InkWell(
                              child: Container(
                                height: ScreenAdapter.setHeight(120),
                                padding: EdgeInsets.symmetric(vertical:ScreenAdapter.setHeight(10)),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: titleWidth,
                                          child: Text('工作地点：',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenAdapter.size(28))),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: ScreenAdapter.setHeight(80),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  IconData(0xe620,
                                                      fontFamily: 'myIcon'),
                                                  color: Colors.grey,
                                                  size: ScreenAdapter.size(35),
                                                ),
                                                SizedBox(
                                                  width:
                                                      ScreenAdapter.setWidth(20),
                                                ),
                                                Container(
                                                  width: ScreenAdapter.setWidth(400),
                                                  height: ScreenAdapter.setHeight(80),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                  position_addr == null
                                                      ? '点击选择地点'
                                                      : position_addr,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize:
                                                          ScreenAdapter.size(30)),
                                                ),
                                                )
                                              ],
                                            ),
                                          )
                                        ),
                                        Container(
                                          child: Icon(
                                            IconData(0xe623,
                                                fontFamily: 'myIcon'),
                                            color: Colors.grey,
                                            size: ScreenAdapter.size(25),
                                          ),
                                        )
                                      ],
                                    )),
                                decoration: BoxDecoration(
                                    // color: Colors.green,
                                    border: Border(
                                        bottom: BorderSide(
                                            width: ScreenAdapter.setWidth(0.5),
                                            color: Colors.grey))),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/search_map')
                                    .then((val) {
                                  if (val == null) {
                                    return;
                                  }
                                  lng = json.decode(val)['lng'];
                                  lat = json.decode(val)['lat'];
                                  province = json.decode(val)['province'];
                                  city = json.decode(val)['city'];
                                  county = json.decode(val)['county'];
                                  position_addr =
                                      json.decode(val)['position_addr'];
                                  adCode = json.decode(val)['adcode'];
                                });
                              },
                            ),

                            Container(
                              // height: ScreenAdapter.setHeight(80),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: ScreenAdapter.setWidth(0.5),
                                          color: Colors.grey))),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: titleWidth,
                                    child: Text('详细地址：',
                                        style: TextStyle(
                                            fontSize: ScreenAdapter.size(28))),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                100, 100, 100, 0.9),
                                            fontWeight: FontWeight.w500,
                                            fontSize: ScreenAdapter.size(30)),
                                        keyboardType: TextInputType.multiline,
                                        // maxLines: 4,
                                        controller: _addressdetailsController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "请输入任务的详细地址",
                                            hintStyle: TextStyle(
                                                fontSize:
                                                    ScreenAdapter.size(30),
                                                color: Colors.grey)),
                                        // 校验详情
                                        validator: (v) {
                                          if (v == '') {
                                            return null;
                                          }
                                          return 5 <= v.trim().length &&
                                                  v.trim().length <= 30
                                              ? null
                                              : "5-30字";
                                        }),
                                  )
                                ],
                              ),
                            ),

                            Container(
                              height: ScreenAdapter.setHeight(80),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: ScreenAdapter.setWidth(0.5),
                                            color: Colors.grey))),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: titleWidth,
                                      child: Text('雇佣人数：',
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
                                                keyboardType: TextInputType.number,
                                                controller: _cartnumController,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        100, 100, 100, 0.9),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: ScreenAdapter.size(30)),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                        fontSize:
                                                            ScreenAdapter.size(30),
                                                        color: Colors.grey)),
                                                onChanged: (_){
                                                  completePrice(_cartnumController.text, _priceController.text);
                                                },
                                                // 校验
                                                validator: (v) {
                                                  if (v == '') {
                                                    return null;
                                                  }
                                                  return int.parse(v) < 1
                                                      ? "最少为1人"
                                                      : null;
                                                }),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              // width: ScreenAdapter.setWidth(50),
                                              child: Text(
                                                '人',
                                                style: TextStyle(color: Colors.grey, fontSize: ScreenAdapter.size(30)),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),

                            // Container(
                            //   decoration: BoxDecoration(
                            //       border: Border(
                            //           bottom: BorderSide(
                            //               width: ScreenAdapter.setWidth(0.5),
                            //               color: Colors.grey))),
                            //   child: Row(
                            //     children: <Widget>[
                            //       Container(
                            //         width: titleWidth,
                            //         child: Text('手机号：'),
                            //       ),
                            //       Expanded(
                            //         flex: 1,
                            //         child: TextFormField(
                            //     inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],     // 只允许输入数字
                            //       style: TextStyle(
                            //           color: Color.fromRGBO(100, 100, 100, 0.9),
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: ScreenAdapter.size(30)),
                            //       controller: _phoneController,
                            //       keyboardType: TextInputType.phone,
                            //       decoration: InputDecoration(
                            //           border: InputBorder.none,
                            //           hintText: "请输入手机号",
                            //           hintStyle: TextStyle(
                            //               fontSize: ScreenAdapter.size(30), color: Colors.grey)),
                            //       // 校验手机号
                            //       validator: (v) {
                            //         if (v == '') {
                            //           return null;
                            //         }
                            //         return Plugins.isChinaPhoneLegal(v)
                            //             ? null
                            //             : "手机号不符合";
                            //       }),
                            //       )
                            //     ],
                            //   ),
                            // ),

                            // InkWell(
                            //   child: Container(
                            //     width: double.infinity,
                            //     height: ScreenAdapter.setHeight(80),
                            //     child: Align(
                            //       alignment: Alignment.centerLeft,
                            //       child: Text(
                            //         '选择省份城市以及您所在的区域',
                            //         style: TextStyle(
                            //             color: Color.fromRGBO(100, 100, 100, 0.9),
                            //             fontWeight: FontWeight.w500),
                            //       ),
                            //     ),
                            //     decoration: BoxDecoration(
                            //         // color: Colors.green,
                            //         border: Border(
                            //             bottom: BorderSide(
                            //                 width: ScreenAdapter.setWidth(2),
                            //                 color: Color.fromRGBO(
                            //                     150, 150, 150, 0.9)))),
                            //   ),
                            //   onTap: () {
                            //     selectProvinceCity();
                            //     // Navigator.pushNamed(context, '/search_map');
                            //   },
                            // ),

                            Container(
                              // 以月份计算
                              // child:_unitamountController is double ?  Text('工作天数：${_unitamountController}个月，总价：¥1500.00') : Text('工作天数：${_unitamountController == null ?  0  :_unitamountController }天，总价：¥1500.00'),
                              child: Text(
                                // 工作天数：${_unitamountController == null ? 0 : _unitamountController}天，
                                  '总价：${totalPrice != null ? totalPrice : 0}元', style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                              margin: EdgeInsets.all(20),
                              // color: Colors.orangeAccent,
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
                                      if (_unitamountController == 0) {
                                        Fluttertoast.showToast(msg: '请选择有效天数');
                                        return;
                                      }
                                  FormData formData = FormData.fromMap({
                                    'title': _titleController.text, // 标题
                                    'content': _detailsController.text, // 订单详情
                                    'start_date': _startDate, // 开始时间
                                    'end_date': _endDate, // 结束时间
                                    'driver_num':
                                        _cartnumController.text, // 司机人数
                                    'price': _priceController.text, // 价钱
                                    // 'unit_amount': _unitamountController,            // 时间差
                                    'addr':
                                        _addressdetailsController.text, // 详细地址
                                    "lat": lat, // 维度
                                    "lng": lng, // 经度
                                    "position_addr": position_addr, // 工作地址
                                    "city": city, // 城市
                                    "province": province, // 省份
                                    "county": county, // 区县
                                    "adcode": adCode // 城市编码
                                  });

                                  Map data = {
                                    'vip': false,
                                    'title': '发布订单',
                                    'price': totalPrice,
                                    'formData': formData
                                  };
                                  Navigator.pushNamed(context, '/pay',
                                      arguments: data);

                                  //验证通过提交数据
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
        )
      );
  }

  // 计算总价
  completePrice(driver_num, price) {
    driver_num == '' ? driver_num = '0' : driver_num = driver_num;
    price == '' ? price = '0' : price = price;
    setState(() {
      totalPrice = (int.parse(driver_num) * double.parse(price))
          .toStringAsFixed(2);
    });
  }

  // Android日历选择
  // Future<DateTime> showDatePicker1(context) {
  //   var date = DateTime.now();

  //   /*
  //     firstDate: new DateTime.now().subtract(new Duration(days: 30)), // 减 30 天
  //     lastDate: new DateTime.now().add(new Duration(days: 30)),       // 加 30 天
  //    */
  //   return showDatePicker(
  //     context: context,
  //     initialDate: date.add(new Duration(days: 1)),
  //     firstDate: date,
  //     locale: Locale('zh'),
  //     lastDate: date.add(
  //       //未来30天可选
  //       Duration(days: 360),
  //     ),
  //   );
  // }

  // IOS日历选择
  // Future<DateTime> showDatePicker2(bool isStartTime) {
  //   // Fluttertoast.showToast(
  //   //     msg: '滑动选择，取消滑动即可选择日期', toastLength: Toast.LENGTH_LONG);
  //   var date = DateTime.now();
  //   return showCupertinoModalPopup(
  //     context: context,
  //     builder: (ctx) {
  //       return SizedBox(
  //         height: 200,
  //         child: CupertinoDatePicker(
  //           mode: CupertinoDatePickerMode.date,
  //           minimumDate: date,
  //           maximumDate: date.add(
  //             Duration(days: 30),
  //           ),
  //           maximumYear: date.year + 1,
  //           onDateTimeChanged: (DateTime value) {
  //             if (isStartTime) {
  //               setState(() {
  //                 _startDate =
  //                     value.toString().substring(0, 10).split('-').join('/');
  //                 // 计算时间差
  //                 _unitamountController =
  //                     Plugins.getDateDiff(_startDate, _endDate);
  //               });
  //             } else {
  //               setState(() {
  //                 _endDate =
  //                     value.toString().substring(0, 10).split('-').join('/');
  //                 // 计算时间差
  //                 // _unitamountController =
  //                 //     Plugins.getDateDiff(_startDate, _endDate);
  //               });
  //             }
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // 选择省市区
  selectProvinceCity() async {
    Result result = await CityPickers.showCityPicker(
      context: context,
    );
  }
}
