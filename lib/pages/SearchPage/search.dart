import 'package:flutter/material.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/ScreenAdapter.dart'; // 屏幕适配
import 'package:project/plugins/PublicStorage.dart'; // 本地存储搜索数据

import 'package:fluttertoast/fluttertoast.dart'; // 提示

import '../../config/api.dart';
import '../../plugins/Plugins.dart';
import 'asset.dart'; // 模拟数据

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // var _keywords = '';
  TextEditingController _keywords = TextEditingController();
  List _historyListData = [];
  var isSearch = false;

  // List data = ['lorem', 'loremasd', 'HelloWorld', '睡觉觉啊', '袭击我去呜呜呜', '上世纪'];

  @override
  void initState() {
    super.initState();
    this._getHistoryData();
  }

  // 获取本地存储
  _getHistoryData() async {
    var _historyListData = await PublicStorage.getHistoryList('searchList');
    // print('获取本地存储${_historyListData}');
    setState(() {
      this._historyListData = _historyListData;
    });
  }

  // 弹出框
  _alertDialog(keywords) async {
    var result = await showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示信息'),
            content: Text('您确定要删除这条记录吗？'),
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
                onPressed: () async {
                  // 异步删除
                  print(keywords);
                  await PublicStorage.replaceListHistoryData(
                      'searchList', keywords);
                  this._getHistoryData();
                  Navigator.pop(context, 'Ok');
                },
              )
            ],
          );
        });
  }

  _alertDeleteDialog() async {
    var result = await showDialog(
        barrierDismissible: false, // 表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示信息'),
            content: Text('您确定要删除全部记录吗？'),
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
                onPressed: () async {
                  // 异步删除
                  PublicStorage.removeHistoryData('searchList');
                  _getHistoryData();
                  Navigator.pop(context, 'Ok');
                },
              )
            ],
          );
        });
  }

  // 是否展示搜索推荐
  Widget _isShowRecommend() {
    // 如果没有数据，就返回推荐数组，如果有数据就返回数组当中查找到的
    final suggestionList = _keywords.text.isEmpty
        ? recentSuggest
        : searchList
            .where((input) => input.startsWith(_keywords.text))
            .toList();
    if (!isSearch) {
      // 没有输入搜索内容
      return Padding(
          padding: EdgeInsets.all(ScreenAdapter.setWidth(15)),
          child: ScrollConfiguration(
            behavior: OverScrollBehavior(),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '历史搜索',
                        style: TextStyle(
                            fontSize: ScreenAdapter.size(30),
                            color: Colors.grey),
                      ),
                    ),
                    IconButton(
                      icon: Icon(IconData(0xe61d, fontFamily: 'myIcon'),
                          color: Colors.grey, size: ScreenAdapter.size(35)),
                      onPressed: () {
                        _alertDeleteDialog();
                      },
                    )
                  ],
                ),
                Wrap(
                    children: _historyListData.map((value) {
                  return InkWell(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(233, 233, 233, 0.9),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(value, style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                    ),
                    onLongPress: () {
                      this._alertDialog("${value}");
                    },
                    onTap: () {
                      // print(value);
                      setState(() {
                        _keywords.text = value;
                        isSearch = true;
                        searchMetod();
                        print(_keywords.text);
                      });
                    },
                  );
                }).toList()),
                SizedBox(
                  height: ScreenAdapter.setHeight(20),
                ),
              ],
            ),
          ));
    } else {
      // 输入搜索内容时
      return ListView.builder(
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: ListTile(
                title: RichText(
                    text: TextSpan(
                        text: suggestionList[index]
                            .substring(0, _keywords.text.length),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: suggestionList[index]
                              .substring(_keywords.text.length),
                          style: TextStyle(color: Colors.grey))
                    ])),
              ),
              onTap: () {
                // print(suggestionList[index]);
                setState(() {
                  _keywords.text = suggestionList[index];
                  isSearch = true;
                  searchMetod();
                  print(_keywords.text);
                });
              },
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(IconData(0xe622, fontFamily: 'myIcon'),
                size: ScreenAdapter.size(40)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Container(
            // height: ScreenAdapter.setHeight(50),
            decoration: BoxDecoration(
                color: Color.fromRGBO(200, 200, 200, 0.3),
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.only(left: ScreenAdapter.setWidth(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 上下居中
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenAdapter.setWidth(10)),
                  child: Icon(
                    Icons.search,
                    size: ScreenAdapter.size(40),
                    color: Color.fromRGBO(200, 200, 200, 0.8),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _keywords,
                      autofocus: false,
                      // 去掉boder的默认边框
                      style: TextStyle(fontSize: ScreenAdapter.size(30)),
                      decoration: InputDecoration(
                          // icon: Icon(Icons.search),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: '请输入关键字',
                          hintStyle: TextStyle(fontSize: ScreenAdapter.size(30)),
                          contentPadding: EdgeInsets.fromLTRB(
                              0, 0, 0, ScreenAdapter.setHeight(20))),
                      onChanged: (value) {
                        if (value != '') {
                          setState(() {
                            isSearch = true;
                            this._keywords.text = value;
                          });
                        } else {
                          setState(() {
                            isSearch = false;
                          });
                        }
                        // 如果绑定了控制器，可利用此方法避免文本框的Bug
                        _keywords.selection = TextSelection.fromPosition(
                            TextPosition(offset: _keywords.text.length));
                      },
                    ))
              ],
            ),
          ),

          // Container(
          //     height: ScreenAdapter.setHeight(50),
          //     decoration: BoxDecoration(
          //         color: Color.fromRGBO(200, 200, 200, 0.3), borderRadius: BorderRadius.circular(30)),
          //     padding: EdgeInsets.only(left: 10),
          //     child: ),
          actions: <Widget>[
            InkWell(
                child: Container(
                  height: ScreenAdapter.setHeight(60),
                  width: ScreenAdapter.setWidth(80),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '搜索',
                        style: TextStyle(fontSize: ScreenAdapter.size(30)),
                      )
                    ],
                  ),
                ),
                onTap: searchMetod)
          ],
        ),
        body: _isShowRecommend());
  }

  searchMetod() async {
    if (isSearch) {
      // 等待本地存储
      await PublicStorage.setHistoryList('searchList', this._keywords.text,
          isSearch: true);
      // 本地存储过后，在搜索页面再一次获取一遍数据
      await this._getHistoryData();

      var adcode = await PublicStorage.getHistoryList('LocationCityCode');
      var now = new DateTime.now();
      Map arguments = {
        'keyword': this._keywords.text,
        'time': Plugins.stampTime(now),
        'pagesize': 8,
        'page': 1,
        'adcode': adcode[0]
      };
      print(arguments);
      Navigator.pushNamed(context, '/register', arguments: arguments);
    } else {
      Fluttertoast.showToast(msg: '请输入内容');
    }
  }
}
