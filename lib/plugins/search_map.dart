import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/plugins/Plugins.dart';

import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/PublicStorage.dart';

import 'package:project/pages/model/search_model.dart';
import 'package:provide/provide.dart';

import 'Behavior.dart';

/*
  周边地理位置筛选
 */

class SearchMap extends StatefulWidget {
  @override
  _SearchMapState createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  var city, address, latlng;
  TextEditingController _addressController = TextEditingController();
  List<LocationSearch> _poiTitleList = [];
  Location _location;

  @override
  void initState() {
    super.initState();
    // Plugins.getLocation(context).then((va){

    //   setState(() {
    //     isLocation = true;
    //   });
    // });
    _getLocation();
  }
  @override
  void dispose() { 
    _addressController = null;
    super.dispose();
  }

  // 获取本地存储的定位
  _getLocation() async {
    var a = await PublicStorage.getHistoryList('FixedCity');
    var b = await PublicStorage.getHistoryList('FixedAddress');
    // var c = await PublicStorage.getHistoryList("LocationCityCode");
    if (a.isNotEmpty && b.isNotEmpty) {
      setState(() {
        city = a[0];
        address = b[0];
        // cityCode = c[0];
        searchAddress(address: address);
      });
    } else {
      setState(() {
        city = '未定位';
      });
    }
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
          title: Text('选择地址',style: TextStyle(fontSize: ScreenAdapter.size(35))),
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
          color: Colors.white,
          child: ScrollConfiguration(
            behavior: OverScrollBehavior(),
            child: ListView(
              children: <Widget>[
                searchMap(), searchList()],
            ))),
        );
  }

  // 选择地址顶部搜索
  Widget searchMap() {
    return Container(
      padding: EdgeInsets.only(top:ScreenAdapter.setHeight(10)),
      child: Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: ScreenAdapter.setHeight(50),
            decoration: BoxDecoration(
                color: Color.fromRGBO(200, 200, 200, 0.3),
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.only(left: ScreenAdapter.setWidth(10)),
            margin: EdgeInsets.only(left: ScreenAdapter.setWidth(30)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // 上下居中
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenAdapter.setWidth(10)),
                  child: Icon(
                    Icons.search,
                    color: Color.fromRGBO(200, 200, 200, 0.8),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _addressController,
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
                        if (value == null) {
                                return;
                              }
                              if (city == '未定位' || address == null) {
                                Fluttertoast.showToast(msg: '请先允许定位再搜索');
                                return;
                              }
                              searchAddress();
                      },
                    ))
              ],
            ),
          ),
        ),
          InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(30), vertical: ScreenAdapter.setHeight(20)),
                child: Text(
                  '取消',
                  style: TextStyle(color: Color.fromRGBO(150, 150, 150, 0.9), fontSize: ScreenAdapter.size(30)),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              })
      ],
    ),
    );
    
  }
 
  // 城市选择
  selectProvinceCity() async {
    print('选择省市区');
    Result result = await CityPickers.showCitiesSelector(
        context: context,
        title: '城市选择',
        cityItemStyle: BaseStyle(fontSize: ScreenAdapter.size(30)));
    if (result == null) {
      return;
    }
    var cityObj = json.decode(result.toString());
    setState(() {
      city = cityObj['cityName'];
      // cityCode = cityObj['cityId'];
    });
  }

  // 周边地理建筑列表
  Widget searchList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(30), vertical: ScreenAdapter.setWidth(0)),
      // color: Color.fromRGBO(200, 200, 200, 0.3),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ScreenAdapter.setWidth(10))),
          child: Column(
              children: _poiTitleList.map((val) {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    // 如果搜索插件版本较低，只能通过方法手动计算出区县和城市编码
                    // var adCodeCounty = await Plugins.latlngTransformCode(Plugins.transformLaglng(val.latLng));

                    Map arr = {
                      "lat": val.latitude, // 维度
                      "lng": val.longitude, // 经度
                      "position_addr": val.title, // 工作地址
                      "city": val.cityName, // 城市
                      "province": val.provinceName, // 省份
                      "county": val.adName, // 区县
                      "adcode":
                          val.adCode.toString().substring(0, 4) + '00' // 城市编码
                      // "adcode":adCodeCounty['code']
                    };
                    print(arr);
                    var n = json.encode(arr);
                    Navigator.pop(context, n);
                  },
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            val.title,
                            style: TextStyle(fontSize: ScreenAdapter.size(30)),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: ScreenAdapter.setWidth(150),
                          // height: ScreenAdapter.setHeight(60),
                          alignment: Alignment.topCenter,
                          child: Text(
                            val.distance != null ? val.distance : 0,
                            // '18千米',
                            style: TextStyle(
                                fontSize: ScreenAdapter.size(25),
                                color: Color.fromRGBO(150, 150, 150, 0.9),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(val.address, style: TextStyle(fontSize: ScreenAdapter.size(30)),),
                  ),
                ),
                Divider(
                  height: ScreenAdapter.setHeight(0.5),
                )
              ],
            );
          }).toList())),
    );
  }

  // 搜索方法
  Future searchAddress({address}) async {
    _poiTitleList = [];
    var poiList;
    if (address == '' || address == null) {
      poiList = await AmapSearch.searchKeyword(
        _addressController.text,
        city: city,
      );
    } else {
      poiList = await AmapSearch.searchKeyword(
        address,
        city: city,
      );
    }
    print('---------------------搜索地址-------------------------');
    print(poiList[0].latLng.latitude);
    for (int i = 0; i < poiList.length; i++) {
      LocationSearch bean = LocationSearch();
      bean.title = await poiList[i].title;
      bean.address = await poiList[i].address;
      bean.cityName = await poiList[i].cityName;
      bean.latitude = await poiList[i].latLng.latitude;
      bean.longitude = await poiList[i].latLng.longitude;
      bean.provinceName = await poiList[i].provinceName;
      bean.adCode = await poiList[i].adCode;
      bean.adName = await poiList[i].adName;
      // bean.provinceName = await poiList[i];
      // 返回的数据中有 距离
      // bean.distance = await poiList[i].distance;
      // 自定义计算距离
      print('完事了吗？？？？');
      bean.distance = await Plugins.getdistance(context, bean.latitude, bean.longitude);
      setState(() {
        _poiTitleList.add(bean);
      });
      // print('获取到的地理信息');
      // print('1111111111111111111111');
      // _poiTitleList.map((val){
      //   print(val.latLng);
      // });
    }
  }
}
