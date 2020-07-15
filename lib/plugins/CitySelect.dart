// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:azlistview/azlistview.dart';
// import 'package:lpinyin/lpinyin.dart';
// import 'package:project/pages/model/city_model.dart';

// import 'package:provide/provide.dart';
// import 'package:project/provide/userinformation.dart';
// import 'package:project/plugins/PublicStorage.dart';

// /*
//   城市筛选列表

//  */

// class CitySelectRoute extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return new _CitySelectRouteState();
//   }
// }

// class _CitySelectRouteState extends State<CitySelectRoute> {
//   List<CityInfo> _cityList = List();
//   List<CityInfo> _hotCityList = List();

//   int _suspensionHeight = 40;
//   int _itemHeight = 50;
//   String _suspensionTag = "";

//   String city;

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//     _getLocation();
//   }

//   _getLocation() async {
//     var a = await PublicStorage.getHistoryList('LocationCity');
//     setState(() {
//       city = a[0];
//     });
//     print(city);
//   }

//   // 热门城市
//   void loadData() async {
//     _hotCityList.add(CityInfo(name: "北京市", tagIndex: "★"));
//     _hotCityList.add(CityInfo(name: "广州市", tagIndex: "★"));
//     _hotCityList.add(CityInfo(name: "深圳市", tagIndex: "★"));
//     _hotCityList.add(CityInfo(name: "上海市", tagIndex: "★"));
//     _hotCityList.add(CityInfo(name: "沈阳市", tagIndex: "★"));

//     //加载城市列表
//     rootBundle.loadString('assets/data/china.json').then((value) {
//       Map countyMap = json.decode(value);
//       List list = countyMap['china'];
//       list.forEach((value) {
//         _cityList.add(CityInfo(name: value['name']));
//       });
//       _handleList(_cityList);
//       setState(() {
//         _suspensionTag = _hotCityList[0].getSuspensionTag();
//       });
//     });
//   }

//   //根据A-Z排序
//   void _handleList(List<CityInfo> list) {
//     if (list == null || list.isEmpty) return;
//     for (int i = 0, length = list.length; i < length; i++) {
//       String pinyin = PinyinHelper.getPinyinE(list[i].name);
//       String tag = pinyin.substring(0, 1).toUpperCase();
//       list[i].namePinyin = pinyin;
//       if (RegExp("[A-Z]").hasMatch(tag)) {
//         list[i].tagIndex = tag;
//       } else {
//         list[i].tagIndex = "#";
//       }
//     }
//     SuspensionUtil.sortListBySuspensionTag(_cityList);
//   }

//   // 选择城市
//   void _onSusTagChanged(String tag) {
//     setState(() {
//       _suspensionTag = tag;
//     });
//   }

//   Widget _buildSusWidget(String susTag) {
//     susTag = (susTag == "★" ? "热门城市" : susTag);
//     return Container(
//       height: _suspensionHeight.toDouble(),
//       padding: const EdgeInsets.only(left: 15.0),
//       color: Color(0xfff3f4f5),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         '$susTag',
//         softWrap: false,
//         style: TextStyle(
//           fontSize: 14.0,
//           color: Color(0xff999999),
//         ),
//       ),
//     );
//   }


//   // 渲染城市列表
//   Widget _buildListItem(CityInfo model) {
//     String susTag = model.getSuspensionTag();
//     susTag = (susTag == "★" ? "热门城市" : susTag);
//     return Column(
//       children: <Widget>[
//         Offstage(
//           offstage: model.isShowSuspension != true,
//           child: _buildSusWidget(susTag),
//         ),
//         SizedBox(
//           height: _itemHeight.toDouble(),
//           child: ListTile(
//             title: Text(model.name),
//             onTap: () {
//               print("OnItemClick: $model");
//               print('选择的城市：${model.name}');
//               Provide.value<UserInfomation>(context).setSelectCity(model.name);
//               Navigator.pop(context, model.name);
//             },
//           ),
//         )
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('城市选择'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Container(
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.only(left: 15.0),
//               height: 50.0,
//               child: Text("当前城市: ${city}"),
//             ),
//             Expanded(
//                 flex: 1,
//                 child: AzListView(
//                   data: _cityList,
//                   topData: _hotCityList,
//                   itemBuilder: (context, model) => _buildListItem(model),
//                   suspensionWidget: _buildSusWidget(_suspensionTag),
//                   isUseRealIndex: true,
//                   itemHeight: _itemHeight,
//                   suspensionHeight: _suspensionHeight,
//                   onSusTagChanged: _onSusTagChanged,
//                   //showCenterTip: false,
//                 )),
//           ],
//         )
//       );
//   }
// }
