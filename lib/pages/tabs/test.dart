import 'dart:async';
// import 'package:flutter/material.dart';


void main(){
  //---------------------------- 倒计时--------------------------------
  // Timer timer;
  // int countdownTime = 15;       // 默认是从60开始倒计时

  // const oneSec = Duration(seconds:1);

  // var callback = (time){
    
  //    if (countdownTime < 1) {
  //       // timer.cancel();
  //       print('发送心跳');
  //       countdownTime = 15;
  //     } else {
  //       countdownTime--; // 倒计时 自减
  //       print(countdownTime);
  //     }
      
  // };

  // timer = Timer.periodic(oneSec, callback);
  

  // List<Map> students = [
    
  //   { 'name': 'tom', 'age': 16 },
  //   { 'name': 'jack', 'age': 18 },
  //   { 'name': 'lucy', 'age': 20 },
  //   { 'name': 'mk', 'age': 20 },
    
  // ];
  // var n = students.removeAt(1);
  // print(n);
  // print(students);
  // var testArr = students[0];
  // print(testArr);

  // List numbers = [2, 8, 5, 1, 7, 3];

  // Map ab = { 'name': 'tom', 'age': 25 };

  // // for(var i = 0; i<students.length; i++){
  // //   if(students[i]['name'] == 'toms'){
  // //     students[i]['age'] = 100;
  // //   }else{
  // //     print('到我这里了！！');
  // //     students..insert(students.length, {'name':'tomes', 'age':200});
  // //     break;
  // //   }
  // // }
  // // print(students);

  // // print(DateTime.now());

  // var hasData = students[0].any((v){
  //   // 如果有就返回true，如果没有返回false
  //   return v['name'] == 'toms';
  // });
  // print(hasData);
  // var ba = numbers.contains(5);
  testFn();
}

  A(){

  }

  B(){

  }

  C(){

  }

  D(){

  }

Map router1 = {
  '/aaa':(context) => A(),
  '/bbb':(context) => B()
};

Map router2 = {
  '/ccc':(context) => C(),
  '/ddd':(context) => D()
};

testFn(){
 for(var i = 0; i<router2.keys.toList().length; i++){
  //  print(router2.keys.toList()[i]);
    // print(router2[router2.keys.toList()[i]]);
    router1.addAll({router2.keys.toList()[i]:router2[router2.keys.toList()[i]]});
 }
 print(router1);

}
