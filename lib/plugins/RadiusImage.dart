import 'package:flutter/material.dart';
import 'package:project/plugins/ScreenAdapter.dart';

class ImageRadius extends StatelessWidget {
  String imgUrl;
  double imgWidth;
  double imgHeight;
  bool isAssets;
  ImageRadius(this.imgUrl, this.imgWidth, this.imgHeight, {this.isAssets = false});
  @override
  Widget build(BuildContext context) {
    return Container(
            width: ScreenAdapter.setWidth(imgWidth),
            height: ScreenAdapter.setHeight(imgHeight),
            child: FittedBox(
              child: CircleAvatar(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2,color: Colors.white),
                    borderRadius: BorderRadius.circular(40)
                  ),
                ),
                backgroundImage: isAssets ? AssetImage(imgUrl) : NetworkImage(imgUrl),
                radius: 40.0,
              ),
            ),
          );
  }
}

