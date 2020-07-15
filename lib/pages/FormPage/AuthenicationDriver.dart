import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/pages/model/DriverInfo_model.dart';

class AuthenicationDriver extends StatefulWidget {
  @override
  _AuthenicationDriverState createState() => _AuthenicationDriverState();
}

class _AuthenicationDriverState extends State<AuthenicationDriver> {
  TextEditingController _real_name = TextEditingController(); // 姓名
  TextEditingController _id_card = TextEditingController(); // 身份证号
  String _sex = '1'; // 性别
  TextEditingController _car_type = TextEditingController(); // 驾驶类型
  //生日、首次领取时间、开始日期、结束日期、驾驶证照片
  var _birthday = '请选择';
  var _first_receive_time = '请选择';
  var _start_time = '请选择';
  var _end_time = '请选择';
  var _license_img; // 服务器返回图片
  var _croppFile; // 本地图片展示
  var data;
  var status = 4;

  var api = new Api();
  var base_url = 'https://flutter.ikuer.cn/';

  DateTimePickerLocale _locale = DateTimePickerLocale.zh_cn;
  String _format = 'yyyy-MMMM-dd';
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() {
    api.getData(context, 'driverAuth').then((val) {
      if (val == null) {
        return;
      }
      var response = json.decode(val.toString());
      setState(() {
        status = response['driver_status'];
      });
      if (status == 1) {
        var modelContent = DriverInfoModel.fromJson(response); // 利用Model数据类型
        setState(() {
          data = modelContent.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(IconData(0xe622, fontFamily: 'myIcon'),
                size: ScreenAdapter.size(40)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('认证司机',style: TextStyle(fontSize: ScreenAdapter.size(35))),
          centerTitle: true,
          elevation: 1,
          actions: <Widget>[
            status == 0
                ? InkWell(
                    child: Container(
                      height: ScreenAdapter.setHeight(60),
                      width: ScreenAdapter.setWidth(80),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '提交',
                            style: TextStyle(fontSize: ScreenAdapter.size(30)),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      FormData formData = FormData.fromMap({
                        'id_card': _id_card.text,
                        'real_name': _real_name.text,
                        'birthday': _birthday,
                        'sex': _sex,
                        'first_receive_time': _first_receive_time,
                        'start_time': _start_time,
                        'end_time': _end_time,
                        'car_type': _car_type.text,
                        'license_img': _license_img
                      });

                      api
                          .postData(context, 'postAuth', formData: formData)
                          .then((val) {
                        if (val == null) {
                          return;
                        }
                        var response = json.decode(val.toString());
                        _alertDialog(context, response['msg'], () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                        // Fluttertoast.showToast(msg: response);
                      });
                    })
                : Text('')
          ],
        ),
        body: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Container(
                color: Color.fromRGBO(233, 233, 233, 0.7),
                child: StatusWidget())));
  }

  Widget StatusWidget() {
    switch (status) {
      case 0:
        return Form();
        break;
      case 1:
        return showForm();
        break;
      case 2:
        return Center(
          child: Container(
            margin: EdgeInsets.only(bottom: ScreenAdapter.setHeight(200)),
            child: Text('您的司机信息正在审核中，请耐心等待……'),
          ),
        );
        break;
      default:
        return Loading(text: '加载中');
        break;
    }
  }

  Widget Form() {
    return ScrollConfiguration(
        behavior: OverScrollBehavior(),
        child: ListView(
          children: <Widget>[
            FormWidget('1.真实姓名', controller: _real_name),
            Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenAdapter.setWidth(20),
                    vertical: ScreenAdapter.setHeight(10)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '2.身份证号',
                        style: TextStyle(
                            fontSize: ScreenAdapter.size(30),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: TextField(
                        controller: _id_card,
                        keyboardType: TextInputType.number,
                        maxLength: 18,
                        decoration: InputDecoration(
                            hintText: '请输入',
                            border: InputBorder.none,
                            hintStyle: TextStyle()),
                      ),
                    )
                  ],
                )),
            Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenAdapter.setWidth(20),
                    vertical: ScreenAdapter.setHeight(10)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '3.生日',
                        style: TextStyle(
                            fontSize: ScreenAdapter.size(30),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        height: ScreenAdapter.setHeight(80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${_birthday}',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenAdapter.size(32)),
                            ),
                            Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          pickerTheme: DateTimePickerTheme(
                            showTitle: true,
                            confirm: Text('确定',
                                style: TextStyle(color: Colors.grey)),
                            cancel: Text('取消',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          minDateTime: DateTime.parse('1970-01-01'),
                          maxDateTime: DateTime.now(),
                          initialDateTime: _dateTime,
                          dateFormat: _format,
                          locale: _locale,
                          onClose: () => print("----- onClose -----"),
                          onCancel: () => print('onCancel'),
                          onChange: (val, List<int> index) {
                            if (val == null) {
                              return null;
                            }
                            setState(() {
                              _birthday = val
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')
                                  .join('/');
                            });
                          },
                          onConfirm: (val, List<int> index) {
                            if (val == null) {
                              return null;
                            }
                            setState(() {
                              _birthday = val
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')
                                  .join('/');
                            });
                          },
                        );
                      },
                    )
                  ],
                )),
            FormRadioWidget(),
            Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenAdapter.setWidth(20),
                    vertical: ScreenAdapter.setHeight(10)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '5.首次领取时间',
                        style: TextStyle(
                            fontSize: ScreenAdapter.size(30),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        height: ScreenAdapter.setHeight(80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${_first_receive_time}',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenAdapter.size(32)),
                            ),
                            Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          pickerTheme: DateTimePickerTheme(
                            showTitle: true,
                            confirm: Text('确定',
                                style: TextStyle(color: Colors.grey)),
                            cancel: Text('取消',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          minDateTime: DateTime.parse('1970-01-01'),
                          maxDateTime: DateTime.now(),
                          initialDateTime: _dateTime,
                          dateFormat: _format,
                          locale: _locale,
                          onClose: () => print("----- onClose -----"),
                          onCancel: () => print('onCancel'),
                          onChange: (val, List<int> index) {
                            if (val == null) {
                              return null;
                            }
                            setState(() {
                              _first_receive_time = val
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')
                                  .join('/');
                            });
                          },
                          onConfirm: (val, List<int> index) {
                            if (val == null) {
                              return null;
                            }
                            setState(() {
                              _first_receive_time = val
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')
                                  .join('/');
                            });
                          },
                        );
                      },
                    )
                  ],
                )),
            Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenAdapter.setWidth(20),
                    vertical: ScreenAdapter.setHeight(10)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '6.开始时间',
                        style: TextStyle(
                            fontSize: ScreenAdapter.size(30),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        height: ScreenAdapter.setHeight(80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${_start_time}',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenAdapter.size(32)),
                            ),
                            Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          pickerTheme: DateTimePickerTheme(
                            showTitle: true,
                            confirm: Text('确定',
                                style: TextStyle(color: Colors.grey)),
                            cancel: Text('取消',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          minDateTime: DateTime.parse('1970-01-01'),
                          maxDateTime: DateTime.now(),
                          initialDateTime: _dateTime,
                          dateFormat: _format,
                          locale: _locale,
                          onClose: () => print("----- onClose -----"),
                          onCancel: () => print('onCancel'),
                          onChange: (val, List<int> index) {
                            if (val == null) {
                              return null;
                            }
                            setState(() {
                              _start_time = val
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')
                                  .join('/');
                            });
                          },
                          onConfirm: (val, List<int> index) {
                            if (val == null) {
                              return null;
                            }
                            setState(() {
                              _start_time = val
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')
                                  .join('/');
                            });
                          },
                        );
                      },
                    )
                  ],
                )),
            Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenAdapter.setWidth(20),
                    vertical: ScreenAdapter.setHeight(10)),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '7.结束时间',
                        style: TextStyle(
                            fontSize: ScreenAdapter.size(30),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        height: ScreenAdapter.setHeight(80),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${_end_time}',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenAdapter.size(32)),
                            ),
                            Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          pickerTheme: DateTimePickerTheme(
                            showTitle: true,
                            confirm: Text('确定',
                                style: TextStyle(color: Colors.grey)),
                            cancel: Text('取消',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          minDateTime: DateTime.parse('1970-01-01'),
                          maxDateTime:
                              DateTime.now().add(new Duration(days: 360 * 10)),
                          initialDateTime: _dateTime,
                          dateFormat: _format,
                          locale: _locale,
                          onClose: () => print("----- onClose -----"),
                          onCancel: () => print('onCancel'),
                          onChange: (val, List<int> index) {
                            if (val == null) {
                              return null;
                            }
                            setState(() {
                              _end_time = val
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')
                                  .join('/');
                            });
                          },
                          onConfirm: (val, List<int> index) {
                            if (val == null) {
                              return null;
                            }
                            setState(() {
                              _end_time = val
                                  .toString()
                                  .substring(0, 10)
                                  .split('-')
                                  .join('/');
                            });
                          },
                        );
                      },
                    )
                  ],
                )),
            FormWidget('8.驾驶车型', controller: _car_type),
            FormFileWidget()
          ],
        ));
  }

  Widget showForm() {
    return Container(
      padding: EdgeInsets.all(ScreenAdapter.setWidth(30)),
      child:ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child:  ListView(
        children: <Widget>[
          showFormWidget('真实姓名：', data.realName),
          showFormWidget('身份证号：', data.idCard),
          showFormWidget('出生年月：', Plugins.timeStamp(int.parse(data.birthday))),
          showFormWidget('性别：', data.sex == 1 ? '男' : '女'),
          showFormWidget(
              '初次领取时间：', Plugins.timeStamp(int.parse(data.firstReceiveTime))),
          showFormWidget(
              '驾驶证开始日期：', Plugins.timeStamp(int.parse(data.startTime))),
          showFormWidget(
              '驾驶证过期日期：', Plugins.timeStamp(int.parse(data.endTime))),
          showFormWidget('准驾车型：', data.carType),
          Container(
              margin: EdgeInsets.all(ScreenAdapter.setWidth(15)),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: ScreenAdapter.setWidth(230),
                        // color: Colors.red,
                        child: Text('驾驶证照片：'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenAdapter.setHeight(30),
                  ),
                  Image.network('$base_url${data.licenseImg}',
                      fit: BoxFit.contain),
                  Divider()
                ],
              ))
        ],
      ),
    
        )
      
    );
  }

  //表单输入
  Widget FormWidget(String title,
      {TextEditingController controller,
      String hintText = '请输入',
      inputType = TextInputType.text}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenAdapter.setWidth(20),
            vertical: ScreenAdapter.setHeight(10)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                '${title}',
                style: TextStyle(
                    fontSize: ScreenAdapter.size(30),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: TextField(
                controller: controller,
                keyboardType: inputType,
                decoration: InputDecoration(
                    hintText: '请输入',
                    border: InputBorder.none,
                    hintStyle: TextStyle()),
              ),
            )
          ],
        ));
  }

  //表单展示
  Widget showFormWidget(String title, String content) {
    return Container(
        margin: EdgeInsets.all(ScreenAdapter.setWidth(15)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: ScreenAdapter.setWidth(230),
                  // color: Colors.red,
                  child: Text('$title'),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '$content',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              ],
            ),
            Divider()
          ],
        ));
  }

  // 单选框
  Widget FormRadioWidget() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenAdapter.setWidth(20),
            vertical: ScreenAdapter.setHeight(20)),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '4.性别：',
              style: TextStyle(
                  fontSize: ScreenAdapter.size(30),
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Text('男：'),
                Radio(
                  value: '1',
                  groupValue: _sex,
                  onChanged: (val) {
                    setState(() {
                      _sex = val;
                    });
                  },
                ),
                Text('女：'),
                Radio(
                  value: '0',
                  groupValue: _sex,
                  onChanged: (val) {
                    setState(() {
                      _sex = val;
                    });
                  },
                )
              ],
            )
          ],
        ));
  }

  // 上传图片
  Widget FormFileWidget() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(10)),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenAdapter.setWidth(20),
            vertical: ScreenAdapter.setHeight(20)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '9.上传驾驶证',
                  style: TextStyle(
                      fontSize: ScreenAdapter.size(30),
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  child: Icon(Icons.linked_camera),
                  onTap: () async {
                    var imgurl = await Plugins.takePhoto();
                    if (imgurl != null) {
                      var croppFile =
                          await Plugins.cropImage(context, imgurl.path, true);
                      setState(() {
                        _croppFile = croppFile;
                      });
                      api
                          .postData(context, 'uploadFile',
                              formData: await FormData1(croppFile.path))
                          .then((val) {
                        var response = json.decode(val.toString());
                        setState(() {
                          _license_img = response['file_path'];
                        });
                      });
                    }
                  },
                )
              ],
            ),
            Divider(),
            _license_img == null
                ? InkWell(
                    child: Container(
                      width: ScreenAdapter.setWidth(200),
                      height: ScreenAdapter.setHeight(180),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Icon(Icons.add),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: ScreenAdapter.setWidth(1),
                              color: Colors.black54)),
                    ),
                    onTap: () async {
                      var imgurl = await Plugins.openGallery();
                      if (imgurl != null) {
                        var croppFile =
                            await Plugins.cropImage(context, imgurl.path, true);
                        setState(() {
                          _croppFile = croppFile;
                        });
                        api
                            .postData(context, 'uploadFile',
                                formData: await FormData1(croppFile.path))
                            .then((val) {
                          var response = json.decode(val.toString());
                          setState(() {
                            _license_img = response['file_path'];
                          });
                        });
                      }
                    },
                  )
                : Stack(
                    children: <Widget>[
                      Container(
                        // child: Image.network('${_license_img}',fit:BoxFit.cover)
                        child: Image.file(_croppFile),
                      ),
                      Positioned(
                          right: 0,
                          top: 0,
                          child: InkWell(
                            child: Container(
                              width: ScreenAdapter.setWidth(50),
                              height: ScreenAdapter.setHeight(50),
                              decoration: BoxDecoration(
                                  // border: Border.all(width: ScreenAdapter.setWidth(1))
                                  ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                            onTap: () {
                              showisDeleteDialog();
                            },
                          ))
                    ],
                  )
          ],
        ));
  }

  showisDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('确认删除？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  setState(() {
                    _license_img = null;
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
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
                child: Text('取消'),
                onPressed: () {
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(child: Text('确定'), onPressed: fn)
            ],
          );
        });
  }

  // dio上传文件FormData格式
  Future<FormData> FormData1(fileUrl) async {
    return FormData.fromMap({"file": await MultipartFile.fromFile(fileUrl)});
  }
}
