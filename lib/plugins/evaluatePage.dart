import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/RadiusImage.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:spon_rating_bar/spon_rating_bar.dart';
import 'package:transparent_image/transparent_image.dart';

import 'PublicStorage.dart';

class EvaluatePage extends StatefulWidget {
  final arguments;
  EvaluatePage(this.arguments);
  @override
  _EvaluatePageState createState() => _EvaluatePageState(arguments);
}

class _EvaluatePageState extends State<EvaluatePage> {
  var arguments;
  _EvaluatePageState(this.arguments);

  TextEditingController _textController;
  String ratingValue = '10' ;
  var userInfo;
  
  var api = new Api();
  var response;
  var base_url = 'https://flutter.ikuer.cn/'; 

  @override
  void initState() { 
    super.initState();
    print('传进来的参数${arguments}');
    _textController = TextEditingController();
    _getUserImage();
  }
  _getUserImage(){
    print(arguments['id']);
    api.getData(context, 'userImage', formData:{'user_id':arguments['user_id']}).then((val){
      print('返回:$val');
      if(val == null){
        return;
      }
      setState(() {
        response = json.decode(val.toString());
      });
      print(response['head_pic']);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
        title: Text('评价',style: TextStyle(fontSize: ScreenAdapter.size(35))),
        centerTitle: true,
        elevation: 1,
      ),
      body: response == null ? 
       Loading(text: '加载中',):
       ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          color:Colors.white,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(ScreenAdapter.setWidth(40)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: ScreenAdapter.setWidth(100),
                        child: AspectRatio(
                          aspectRatio: 1/1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: '$base_url${response['head_pic']}'),
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: Container(
                      //     child: Text('${arguments['nickname']}'),
                      //   ),
                      // )
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('评分：'),
                              Container(
                                // margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20)),
                                child: Row(
                                  children: <Widget>[
                                    SponRatingWidget(
                                      value: 10,
                                      size: ScreenAdapter.size(30),
                                      padding: 10,
                                      nomalImage: 'assets/images/star_nomal.png',
                                      selectImage: 'assets/images/star.png',
                                      selectAble: true,
                                      onRatingUpdate: (value) {
                                      
                                      setState(() {
                                        ratingValue = value;
                                      });
                                    },
                                    maxRating: 10,
                                    count: 5,
                                    ),
                                    Text(value())
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(40)),
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(40)),
                  child: Text('评价内容', style: TextStyle(fontSize: ScreenAdapter.size(30))),
                ),
                Container(
                  color: Colors.white60,
                  padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(40)),
                  child: TextField(
                    controller: _textController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: '请输入评价内容',
                      hintStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: ScreenAdapter.size(30)
                      ),
                      border: InputBorder.none
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenAdapter.setHeight(100),
                ),
                Container(
                  padding: EdgeInsets.all(ScreenAdapter.setWidth(30)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: ScreenAdapter.setHeight(60),
                          child: RaisedButton(
                            onPressed: (){
                              Map formData = {'apply_id':arguments['id'], 'mark':ratingValue, 'comment':_textController.text};
              
                              if(arguments['isDivider']){
                                print(formData);
                                api.postData(context, 'appraise', formData: formData).then((val){
                                  if(val == null){
                                    return null;
                                  }
                                  var response = json.decode(val.toString());
                                  Fluttertoast.showToast(msg: response['msg']);
                                  Navigator.pop(context);
                                });
                              }else{
                                print(formData);
                                api.postData(context, 'userAppraise', formData: formData).then((val){
                                  print('返回值：$val');
                                  if(val == null){
                                    return null;
                                  }
                                  var response = json.decode(val.toString());
                                  Fluttertoast.showToast(msg: response['msg']);
                                  Navigator.pop(context);
                                });
                              }
                            },
                            color: Color(0xffff8080),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Text('发表评价'),
                          ),
                        )
                      )
                    ],
                  ),
                )
                
              ],
            ),
          )
        ),
      )
    );
  }


  
  String value() {
    if(ratingValue == null) {
      return ' 10 分';
    }else {
      return '   $ratingValue  分';
    }
  }
}