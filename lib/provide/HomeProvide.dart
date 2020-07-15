import 'package:flutter/material.dart';
import 'package:project/config/api.dart';

// 当前Provide 存放用户操作的全局变量
class HomeProvide with  ChangeNotifier{
  
  bool visible;                   // 是否显示
  var condition = 'all';                  // 个人中心的雇主身份全部任务查询条件
  var conditionDivider = 'all';                  // 个人中心的司机身份全部任务查询条件
  

  setVisible(val){
    this.visible = val;
    notifyListeners();
  }

  // 用户身份修改搜索条件
  setCondition(val){
    this.condition = val;
    notifyListeners();
  }

  // 司机身份修改搜索条件
  setConditionDivider(val){
    this.conditionDivider = val;
    notifyListeners();
  }
  
}