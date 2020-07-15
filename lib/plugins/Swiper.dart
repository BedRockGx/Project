import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
// import 'package:transparent_image/transparent_image.dart';

class SwiperWidget extends StatelessWidget {

  final List swiperDataList;
  // 接收参数
  SwiperWidget({Key key, this.swiperDataList}):super(key:key);

  @override
  Widget build(BuildContext context) {
    final rpx = MediaQuery.of(context).size.width / 750;
    return  
    Container(
      height: 350 * rpx,
      width: ScreenUtil().setWidth(750),
      margin: EdgeInsets.only(top:ScreenAdapter.setHeight(10)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(ScreenAdapter.setWidth(0)),
          child: Swiper(
            itemBuilder: (BuildContext context, int index){
              return  InkWell(
                onTap: () async {
                  var url = swiperDataList[index]['url'];
                  Navigator.pushNamed(context, '/webpage', arguments: url);
                    // if (await canLaunch(url)) {
                    //   await launch(url);
                    // } else {
                    //   throw 'Could not launch $url';
                    // }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(30)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ScreenAdapter.setWidth(30)),
                    child: FadeInImage.assetNetwork(
                        placeholder: "assets/images/swiper_loading.gif",
                        image: "https://flutter.ikuer.cn${swiperDataList[index]['img']}",
                        fit: BoxFit.cover,
                        // placeholderScale:0.5,
                        // imageScale:0.5,

                      ),
                  ),
                ),
              );
            },
            itemCount: swiperDataList.length,       // 数量
            pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                color: Color.fromRGBO(200, 200, 200, 0.5),
                size: 6.0,
                activeSize: 10.0
              )
            ),     //小圆点控制器
            autoplay: true,     //自动播放
          ),
        ),
    );
  }
}

