import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:transparent_image/transparent_image.dart';

class VipUserList extends StatefulWidget {
  var arguments;
  VipUserList({this.arguments});

  @override
  _VipUserListState createState() => _VipUserListState();
}

class _VipUserListState extends State<VipUserList> {

  var api = new Api();
  var response;
  var base_url = 'https://flutter.ikuer.cn/';      // baserUrl接口

  @override
  void initState() { 
    super.initState();
    _getList();
  }



  _getList(){
    api.getData(context, 'vip_list').then((val){
      if(val == null){
        return;
      }
      
      setState(() {
        response = json.decode(val.toString());
      });
    });
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
          child: Text('群成员', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
        ),
        centerTitle: true,
        // backgroundColor: Colors.grey[200],
        elevation: 1.0,
      ),
      body: response == null ? Loading(text:'加载中'):
      Container(
          // color: Colors.white,
          margin: EdgeInsets.all(ScreenAdapter.setWidth(30)),
          child: widgetWrap()
      )
    );
  }

  Widget widgetWrap(){
    List<Widget> widgetList = [];

    for(var item in response){
      print(item);
      widgetList.add(
        Container(
                  width: ScreenAdapter.setWidth(105),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: ScreenAdapter.setWidth(95),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  fit: BoxFit.cover,
                                  image: '$base_url${item['head_pic']}'),
                            )),
                      ),
                      SizedBox(
                        height: ScreenAdapter.setHeight(5)
                      ),
                      Text('${item['nickname']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey,fontSize: ScreenAdapter.size(25)))
                    ],
                  ),
                )
     
      );
    }


    return Wrap(
              spacing: ScreenAdapter.setWidth(40), // 主轴(水平)方向间距
              runSpacing: ScreenAdapter.setHeight(10), // 纵轴（垂直）方向间距
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: widgetList
            );
  }
}
