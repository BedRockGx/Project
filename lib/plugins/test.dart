 
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:developer';
import 'package:rxdart/rxdart.dart';

List<Map> arr = [
    {'cate':'颜色', 'list':['碳纤黑', '冰川蓝', '火焰红', '夏之密语']},
    {'cate':'版本', 'list':['6GB+64GB', '6GB+128GB', '8GB+128GB', '8GB+256GB']},
    {'cate':'购买方式', 'list':['官方标配']},
  ];
  List currentList = [];
void main(){
    // int a = 1576855458000;
    // print(a);
//     var now= DateTime.now();
// var a=now.millisecondsSinceEpoch;//时间戳
// print(a is int);
// print(DateTime.fromMillisecondsSinceEpoch(a));    //转为正常时间
    var now= DateTime.now();
    var a=now.millisecondsSinceEpoch;//时间戳
    print(a);
  // Object arr = {"name":"小明", "age":"12"};
  // print(arr);
    // Observable.fromIterable(array).map<String>((data) {
    //   return (data + 1).toString();
    // }).doOnListen(() {
    //   print("被监听");
    // }).listen((data) {
    //   print(data);
    // });

  // var cityCode = 370102;
  // print(cityCode.toString().substring(0, 4));
  
  // 字符串Map转为List，字符串Map转为Map

  // var jsonTxt1 = '{ "name": "John Smith", "email": "john@example.com"}';
  // Map<String, dynamic> user = convert.jsonDecode(jsonTxt1);
  // print(user is Map);
  // var jsonTxt2 = '["小明","韩梅梅","李华"]';
  // List nameList = convert.jsonDecode(jsonTxt2);
  // print(nameList);

  // for(var i = 0;i<arr.length;i++){
  //   // print(arr[i]['list']);
  //   for(var j = 0; j<arr[i]['list'].length;j++){
  //     if(j==0){
  //       currentList.add({
  //         'title':arr[i]['list'][j],
  //         'checked':true
  //       });
  //     }else{
  //       currentList.add({
  //         'title':arr[i]['list'][j],
  //         'checked':false
  //       });
  //     }
  //   }
  // }
  // print(currentList);
  // getDateDiff();
}

getDateDiff(){
  var d6 = new DateTime(2019, 06, 19);
  var d7 = new DateTime(2019, 06, 20,);
  var difference = d7.difference(d6);
  print([difference.inDays, difference.inHours,difference.inMinutes]);//d6与d7相差的天数与小时,分钟 [0, 22, 1370]
}

