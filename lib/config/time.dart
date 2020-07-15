import 'dart:async';

void main(){
  int count = 0;
  const period = const Duration(seconds: 1);
  // print('currentTime='+DateTime.now().toString());
  Timer.periodic(period, (timer) {
    //到时回调
    // print('afterTimer'+DateTime.now().toString());
    count++;
    print(count);
    if (count >= 5) {
      // //取消定时器，避免无限回调
      // timer.cancel();
      // timer = null;
      print('到5了');
      count = 0;
    }
  });
}