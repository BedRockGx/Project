import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/config/api.dart';
import 'package:project/config/api_url.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/Plugins.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/currencyAppBar.dart';
import 'package:project/provide/SocketProvide.dart';
import 'package:provide/provide.dart';
import 'package:transparent_image/transparent_image.dart';

class RecruitDetails extends StatefulWidget {
  Map arguments;
  RecruitDetails(this.arguments);
  @override
  _RecruitDetailsState createState() => _RecruitDetailsState();
}

class _RecruitDetailsState extends State<RecruitDetails> {
  var api = new Api();
  var response;

  @override
  void initState() {
    if (widget.arguments['Hall']) {
      _getHallData();
    } else {
      _getMyData();
    }
    super.initState();
  }

  _getHallData() {
    print(111);
    print('招聘详情：${widget.arguments['id']}');
    api.getData(context, 'detail_recruit',
        formData: {'id': widget.arguments['id']}).then((val) {
      if (val == null) {
        return;
      }

      setState(() {
        response = json.decode(val.toString());
      });
    });
  }

  _getMyData() {
    api.getData(context, 'my_detail_recruit',
        formData: {'id': widget.arguments['id']}).then((val) {
      if (val == null) {
        return;
      }

      setState(() {
        response = json.decode(val.toString());
      });

      print('22222有返回吗！！！！！！');
      print(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currencyAppBar('招聘详情', context),
      body: response == null
          ? Loading(text: '加载中')
          : Container(
              color: Colors.white,
              padding: EdgeInsets.all(ScreenAdapter.setWidth(30)),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            '${response['title']}',
                            style: TextStyle(
                              fontSize: ScreenAdapter.size(35),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: ScreenAdapter.setWidth(50)),
                        child: Text(
                          '${response['start_salary']}k-${response['end_salary']}k',
                          style: TextStyle(color: Colors.red,fontSize: ScreenAdapter.size(35),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenAdapter.setHeight(10),
                  ),
                  widget.arguments['Hall']
                      ? Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: ScreenAdapter.setWidth(70),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image:
                                              '$base_url${response['head_pic']}'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenAdapter.setWidth(10),
                                ),
                                Text(
                                  '${response['nickname']}',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: ScreenAdapter.size(30)),
                                )
                              ],
                            ),
                            SizedBox(
                              height: ScreenAdapter.setHeight(20),
                            ),
                          ],
                        )
                      : Text(''),
                  
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('职位详情',
                        style: TextStyle(fontSize: ScreenAdapter.size(30))),
                  ),
                  SizedBox(
                    height: ScreenAdapter.setHeight(20),
                  ),
                  Container(
                    height: ScreenAdapter.setHeight(200),
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${response['content']}',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenAdapter.size(27)),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: ScreenAdapter.setWidth(170),
                        child: Text('联系方式：',style: TextStyle(fontSize: ScreenAdapter.size(30))),
                      ),
                      Container(
                        child: Text(
                          '${response['contact']}',
                          style: TextStyle(color: Colors.black54, fontSize: ScreenAdapter.size(30)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenAdapter.setHeight(40),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: ScreenAdapter.setWidth(170),
                        child: Text('发布时间：',style: TextStyle(fontSize: ScreenAdapter.size(30))),
                      ),
                      Container(
                        child: Text(
                          '${Plugins.timeStamp(int.parse(response['release_time']))}',
                          style: TextStyle(color: Colors.black54, fontSize: ScreenAdapter.size(30)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenAdapter.setHeight(50),
                  ),
                  widget.arguments['Hall']
                      ? Container(
                          padding: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: ScreenAdapter.setHeight(70),
                                    child: RaisedButton(
                                      
                                      onPressed: () {
                                        Map arguments = {
                                          'nickname':response['nickname'],
                                          'head_pic':response['head_pic'],
                                          'recv_id':response['user_id'],
                                          'isVip':false
                                        };
                                        // print(arguments);
                                        Navigator.pushNamed(context, '/chatPage', arguments: arguments).then((val){
                                          Provide.value<SocketProvider>(context).clearRecords();
                                        });
                                      },
                                      color: Color(0xffff8080),
                                      textColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Text('立即沟通', style: TextStyle(fontSize: ScreenAdapter.size(30),)),
                                    ),
                                  ))
                            ],
                          ),
                        )
                      : Text('')
                ],
              ),
            ),
    );
  }
}
