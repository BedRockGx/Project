import 'package:flutter/material.dart';

// 将页面的业务逻辑 分到当前dart文件中

// ChangeNotifier 不限制类的获取，谁都可以获取当前类
class Useridentity with ChangeNotifier {
  /*
      用户身份
        0:雇主
        1:司机
      是否认证了司机
  */

  int _identity = 0;
  bool _isCart = false;
  bool _isShowBackgroundImage = false;

  int get getIdentity=>_identity;
  bool get getisCart=>_isCart;
  bool get getisShowBackgroundImage => _isShowBackgroundImage;

  void modifyindentity(val){
    this._identity = val;
    notifyListeners();
  }

  void modifyIsCart(val){
    this._isCart = val;
    notifyListeners();
  }

  void modifyShowBackgroundImage(val){
    this._isShowBackgroundImage = val;
    notifyListeners();
  }
}
