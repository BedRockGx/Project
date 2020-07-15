import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/plugins/PublicStorage.dart';

class UserInfomation with ChangeNotifier{
  var city = '';                // 定位城市
  var address = '';             // 定位当前位置
  var select_city = '';         // 用户经过城市选择之后选择到的城市
  var latlng = null;            // 经纬度
  var province = '';            // 省份
  var cityCode = '';            // 城市编码
  var poiName = '';            // 定位当前位置的搜索条件
  var condition = 'refresh';                  // 任务大厅排序条件

  Timer _timer;
  int countdownTime = 60;       // 默认是从60开始倒计时

  var _token;                    // Token

  var isScocket = false;                // 是否可以进行socket通信

  get token => _token;

  // 存储定位城市
  setCity(val) async{
    this.city = val;
    notifyListeners();
  }

  setAddress(val) async {
    this.address = val;
    notifyListeners();
  }
  
  setLatLng(val) async {
    this.latlng = val;
    notifyListeners();
  }
  
  // 存储省份
  setProvince(val) async {
    this.province = val;
    notifyListeners();
  }

  // 存储选择的城市
  setSelectCity(val) async {
    this.select_city = val;
    notifyListeners();
  }

  // 存储城市编码
  setCityCode(val) {
    this.cityCode = val;
    notifyListeners();
  }
  
  // 存储搜索条件
  setPoiName(val){
    this.poiName = val;
    notifyListeners();
  }

  // 修改倒计时
  startCountdownTimer() {
    // 先自减一次，促使时间从59开始计算
    this.countdownTime--;

    const oneSec = const Duration(seconds: 1);
    var callback = (timer){
            if (this.countdownTime < 1) {
              _timer.cancel();
              this.countdownTime = 60;
            } else {
              
              this.countdownTime = this.countdownTime - 1; // 倒计时 自减
              
              notifyListeners();

            }
        };
    _timer = Timer.periodic(oneSec, callback);
  }
  // 存储token
  setToken(val){
    this._token = val;
    notifyListeners();
  }

  // 修改搜索条件
  setCondition(val){
    this.condition = val;
    notifyListeners();
  }

  // 是否可以通信
  setSocket(val){
    this.isScocket = val;
    notifyListeners();
  }
}