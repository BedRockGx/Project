
// 插件功能：指定时分秒倒计时

// 使用方法
// new OnsaleTimer(
// 	end_time: '2019-11-18 09:00:00',
// 	padding: new EdgeInsets.only(),
//     color: Colors.transparent,
//     style: new TextStyle(fontSize: 28, color: Color(0xffff1568), fontFamily: 'pfsemibold'),
//     mstyle: new TextStyle(fontSize: 28, color: Color(0xffff1568), fontFamily: 'pfsemibold'),
//     radius: 0,
// )

// 参数
// end_time：倒计时截止时间
// padding：时、分、秒区块的内边距
// color：时、分、秒区块的颜色
// style：时、分、秒的字体样式
// mstyle：‘：’的字体样式
// radius：时、分、秒区块的圆角角度



import 'package:flutter/material.dart';

class OnsaleTimer extends StatefulWidget {

  final String end_time;
  final Color color;
  final EdgeInsets padding;
  final TextStyle style, mstyle;
  final double radius;

  OnsaleTimer({
    @required
    this.end_time,
    @required
    this.color,
    @required
    this.style,
    @required
    this.radius,
    @required
    this.mstyle,
    @required
    this.padding,
  });

  _OnsaleTimerState createState() => new _OnsaleTimerState();

}

class _OnsaleTimerState extends State<OnsaleTimer> with TickerProviderStateMixin {

  Duration _duration;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime end = DateTime.parse(widget.end_time);
    DateTime now = DateTime.now();
    _duration = end.difference(now);
    //新增判断过期
    if(_duration < Duration.zero) _duration = Duration.zero;
    print(_duration);
    _animationController = AnimationController(vsync: this, duration: _duration);
    _animationController.reverse(from: _animationController.value == 0.0 ? 1.0 : _animationController.value);
  }

  String get hoursString {
    Duration duration = _animationController.duration * _animationController.value;
    return '${(duration.inHours).toString().padLeft(2, '0')}';
  }

  String get minutesString {
    Duration duration = _animationController.duration * _animationController.value;
    return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
  }

  String get secondsString {
    Duration duration = _animationController.duration * _animationController.value;
    return '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
              padding: widget.padding,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                color: widget.color
              ),
              child: new Text(hoursString, style: widget.style,),
            ),
            new Text(':', style: widget.mstyle,),
            new Container(
              padding: widget.padding,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                color: widget.color
              ),
              child: new Text(minutesString, style: widget.style,),
            ),
            new Text(':', style: widget.mstyle,),
            new Container(
              padding: widget.padding,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                color: widget.color
              ),
              child: new Text(secondsString, style: widget.style,),
            )
          ],
        );
      },
    );
  }
}
