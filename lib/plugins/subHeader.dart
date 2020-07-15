import 'package:flutter/material.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/appBar.dart';
import 'package:project/provide/userinformation.dart';
import 'package:provide/provide.dart';
import 'package:project/pages/EventBus/bus.dart';

// 顶部筛选控件
class SubHeaderWidget extends StatefulWidget {
  @override
  _SubHeaderWidgetState createState() => _SubHeaderWidgetState();
}

class _SubHeaderWidgetState extends State<SubHeaderWidget> {

  List _subHeaderList = [
    {'id':'1', 'title':'综合', 'condition':'refresh', 'Selection':true},
    {'id':'2', 'title':'信誉', 'condition':'reputation', 'Selection':false},
    {'id':'3', 'title':'价格', 'condition':'price', 'Selection':false},
    {'id':'4', 'title':'距离', 'condition':'distance', 'Selection':false},
  ];
  var _selectHeaderId = 'refresh';

  @override
  Widget build(BuildContext context) {
    
    return Positioned(
      top: ScreenAdapter.setHeight(43),
      // width: ScreenAdapter.setWidth(750),
      // height: ScreenAdapter.setHeight(210),
       width: ScreenAdapter.setWidth(750),
      // height: 120.0,
      child: Column(
        children: <Widget>[
          appBar(context),
          Container(
          width: ScreenAdapter.setWidth(750),
          // height: ScreenAdapter.setHeight(200),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: Color.fromRGBO(233, 233, 233, 0.5)))),
          child: Row(
            children: _subHeaderList.map((val){
              return Expanded(
                      flex: 1,
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, ScreenAdapter.setHeight(20),
                              0, ScreenAdapter.setHeight(20)),
                          // color:Colors.red,
                          child: Text(
                            '${val['title']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ScreenAdapter.size(30),
                              color:val['condition'] == _selectHeaderId ? Colors.red:Colors.black),
                          ),
                        ),
                        onTap:(){
                          setState(() {
                            _selectHeaderId = val['condition'];
                          });
                          setSearch(context, val['condition']);
                          eventBus.fire(OrderHallRefresh('刷新'));
                        }
                      ),
                    );
            }).toList(),
          )),
        ],
      )
    );
}


// 设置搜索条件
setSearch(context, n){
  Provide.value<UserInfomation>(context).setCondition(n);
}
  
}
