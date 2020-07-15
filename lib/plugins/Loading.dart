import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  String text;
  Color colors;
  Color textColors;
  Loading({this.text, this.colors = Colors.grey, this.textColors = Colors.black});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitFadingCircle(
          color: colors,
          size: 50.0,
          // controller: AnimationController(vsync: context, duration: const Duration(milliseconds: 1200)),
        ),
        Text('${text}', style: TextStyle(color: textColors),)
      ],
    ));
  }
}
