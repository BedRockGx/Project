import 'dart:async';
import 'dart:io';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // 轻提示
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_picker/image_picker.dart'; // 选择图片
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart'; // 权限申请
import 'package:fluttertoast/fluttertoast.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart'; // 获取距离
import 'package:project/pages/EventBus/bus.dart';
import 'package:provide/provide.dart';
import 'package:project/provide/userinformation.dart'; // 用户地理信息
import 'package:project/plugins/PublicStorage.dart'; // 公用本地存储
import 'package:rxdart/rxdart.dart';
import 'package:ota_update/ota_update.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_video_compress/flutter_video_compress.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:uuid/uuid.dart';
// import 'package:path/path.dart' as p;


// 公用 的方法

class Plugins {


  // // 打开User页面的侧边栏
  // static final GlobalKey<ScaffoldState> scaffoldKey  = new GlobalKey<ScaffoldState>();
  // static var drawerBool = false;

  // // 打开侧边栏
  // static openEndDrawer(){
  //   drawerBool = true;
  //   scaffoldKey.currentState.openEndDrawer();
  // }

  // // 关闭侧边栏
  // static openDrawer(){
  //   drawerBool = false;
  //   scaffoldKey.currentState.openDrawer();
  // }

  static final ImagePicker _picker = ImagePicker();


  ///大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
  /// 此方法中前三位格式有：
  /// 13+任意数 * 15+除4的任意数 * 18+除1和4的任意数 * 17+除9的任意数 * 147
  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  // 获取地理定位
  static Future getLocation(context, {isAdd = false}) async {
    Location _location;
    var city, address, latitude, longitude,  province, poiName, cityCode;

    if (await requestPermission()) {
      final location = await AmapLocation.fetchLocation();
      _location = location;
          city = await _location.city;
          address = await _location.address;
          latitude = await _location.latLng.latitude;
          longitude = await _location.latLng.longitude;
          province = await _location.province;
          cityCode = await _location.adCode;
          poiName = await _location.poiName;
          
          // print(city);
          // print(address);
          // print(province);
          // print(latlng.toString().substring(7, latlng.toString().lastIndexOf('}')).split(','));

          // 将经纬度重组
          var new_latlng = [latitude, longitude];
          // 将区编码转为城市编码
          var new_CityCode = cityCode.toString().substring(0, 4) + '00';
          // print('---------------获取Code-----------------');
          // print(new_CityCode);
          if(isAdd){
            // 固定存储定位的一些信息，用于搜索查询
            PublicStorage.setHistoryList('FixedCity', city);                 
            PublicStorage.setHistoryList('FixedAddress', address);                 
            PublicStorage.setHistoryList('FixedLatLng', new_latlng);
            return ;
          }
          
          // 状态管理
          Provide.value<UserInfomation>(context).setCity(city);
          Provide.value<UserInfomation>(context).setAddress(address);
          // Provide.value<UserInfomation>(context).setLatLng(latlng);
          Provide.value<UserInfomation>(context).setProvince(province);
          Provide.value<UserInfomation>(context).setCityCode(new_CityCode);
          Provide.value<UserInfomation>(context).setCityCode(poiName);
          // 本地存储
          PublicStorage.setHistoryList('LocationCity', city);
          PublicStorage.setHistoryList('LocationAddress', address);
          PublicStorage.setHistoryList('LocationLatLng', new_latlng);
          PublicStorage.setHistoryList('LocationProvince', province);
          PublicStorage.setHistoryList('LocationCityCode', new_CityCode);
          PublicStorage.setHistoryList('LocationPoiName', poiName);
          
          //触发刷新订单列表
          eventBus.fire(LocationOver('刷新'));
               

    }
   
  }

  // 地址转坐标
  static Future codeTransformLatlng(String city, {int type}) async {
    var geocodeList = await AmapSearch.searchGeocode(
      '政府',
      city:city
    );
    
    if(geocodeList.isEmpty){
      Fluttertoast.showToast(msg: '抱歉，该地区无法查到，请联系管理员!');
      return;
    }
    print(await geocodeList[0].latLng);

    List tranformLatlng;
    // Observable.fromIterable(geocodeList)
    //     .asyncMap((it) => it.toFutureString()).toList()
    //     .then((it){
    //       print('输出了！！！！');
    //       print(it);
    //       var a = it[0].toString().substring(it[0].toString().lastIndexOf('{lat'));
    //       var b = a.substring(0, a.lastIndexOf('}'));
    //       var c = b.substring(b.indexOf('{')+1, b.lastIndexOf('}'));

    //       tranformLatlng = c.split(',');

    //       /*
    //           0：存储定位选择的经纬度
    //           1：存储发布订单选择的经纬度
    //       */
    //       switch (type) {
    //         case 0:
    //             PublicStorage.setHistoryList('LocationLatLng', tranformLatlng);
    //             // 利用EventBus触发加载订单大厅数据方法
    //           break;
    //         case 1:
    //             PublicStorage.setHistoryList('addLatlng', tranformLatlng);
    //             break;
    //         default:
    //       }
          
    //     });  
  }

  // 坐标转地址
  static Future latlngTransformCode(List latlng) async {
    var district,adcode;
    var reGeocodeList = await AmapSearch.searchReGeocode(
                LatLng(
                  double.parse(latlng[0]),
                  double.parse(latlng[1]),
                ),
                radius: 200.0,
              );
      district = await reGeocodeList.districtName;
      adcode = await reGeocodeList.aoiList;
      var newcode = await adcode[0].adcode;
      Map arr = {
        'district':district,
        'code':newcode.toString().substring(0, 4) + '00'
      };
      print(arr);
      // return arr; 
  }


// 将接口返回经纬度转为Dart可用数组
  static transformLaglng(val){
    print(val);
    List latlng = [];
    var ex = val.toString().substring(7, val.toString().lastIndexOf('}')).split(',');
    latlng.add(ex[0].toString().substring(5));
    latlng.add(ex[1].toString().substring(5));
    return latlng;
  }

  // 计算两经纬度之间的距离
  static getdistance(context, latitude, longitude) async {
    var mylatlng = await PublicStorage.getHistoryList('FixedLatLng');
    var city = await PublicStorage.getHistoryList('LocationCity');
    List searchList = [];
    print(mylatlng);
    // searchList =transformLaglng(str);
        // str.toString().substring(7, str.toString().lastIndexOf('}')).split(',');
    
    final result = await AmapService.calculateDistance(
      LatLng(
        mylatlng[0][0],
        mylatlng[0][1]
      ),
      LatLng(
        latitude,
        longitude
        // double.parse(latitude),
        // double.parse(longitude),
      ),
    );

    
    if (result.round() > 1000) {
      return (result.round() / 1000).toStringAsFixed(2) + '千米';
    } else {
      return result.round().toString() + '米';
    }
  }

  // 定位导航
  static gaodeMap(lat, lng){
    AmapService.navigateDrive(LatLng(lat, lng)).catchError((val){
      Fluttertoast.showToast(msg: '对不起，您的手机没有安装高德地图');
    });
  }


//获取版本号
  static getPackageInfo(context) async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    
    // print("App名称:${appName}");

    // print("包名:${packageName}");

    // print("version:${version}");
    
    // print("打包次数:${buildNumber}");
    
    return version;
  }

  //获取路径
  static getAppPath() async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    var directory = await getExternalStorageDirectory();

    
    String storageDirectory=directory.path;


    // print("临时目录:${tempPath}");

    // print("安装目录:${appDocPath}");

    // print("存储卡目录:${storageDirectory}");
  }

  //下载并打开文件
  static downLoad(appUrl)async {
     Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
    if (Platform.isIOS){
      String url = 'itms-apps://itunes.apple.com/cn/app/id414478124?mt=8'; //到时候换成自己的应用的地址
      // 通过url_launcher插件来跳转AppStore
      // if (await canLaunch(url)){
      //   await launch(url);
      // }else {
      //   throw 'Could not launch $url';
      // }
    }else if (Platform.isAndroid){
      String url = appUrl;
      try {
        OtaUpdate().execute(url).listen(
              (OtaEvent event) {
            switch(event.status){
              case OtaStatus.DOWNLOADING: // 下载中
                // setState(() {
                //   progress = '下载进度:${event.value}%';
                // });
                break;
              case OtaStatus.INSTALLING: //安装中
                  print('-----安装中----');
                  //这里的这个Apk文件名可以写，也可以不写
                  //不写的话会出现让你选择用浏览器打开，点击取消就好了，写了后会直接打开当前目录下的Apk文件，名字随便定就可以
                  print('$appDocPath');
                  OpenFile.open("${appDocPath}/new.apk");
                  // OpenFile.open("$appDocPath");
                break;
              case OtaStatus.PERMISSION_NOT_GRANTED_ERROR: // 权限错误
                print('更新失败，请稍后再试');
                Fluttertoast.showToast(msg: '更新失败，请稍后再试！');
                break;
              default: // 其他问题
                break;
            }
          },
        );
      } catch (e) {
        print('更新失败，请稍后再试');
      }
    }
  }
  
  // 弹出更新dialog
  static showUpdateDialog(context, appUrl) async{

    showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
            key: Key("AssetDialog"),
            image: Image.asset(
              'assets/images/update.gif',
              fit: BoxFit.cover,
            ),
            title: Text(
              '更新APP提示!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22.0, fontWeight: FontWeight.w600),
            ),
            entryAnimation: EntryAnimation.BOTTOM,
            description: Text(
              '发现新的版本，新版本修复了如下bug 是否更新!',
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            buttonCancelText: Text('heihei', style: TextStyle(color: Colors.white),),
            buttonOkText: Text('立即下载', style: TextStyle(color: Colors.white),),
            onOkButtonPressed: () {
              Navigator.pop(context,'Ok');
              Plugins.downLoad(appUrl);
              Fluttertoast.showToast(msg: '已经进入后台下载，任务栏可查看下载进度');
            },
          )
          );

   
    
  }

  // 计算两个时间之间的相差天数
  static getDateDiff(sDate1, sDate2) {
    if (sDate1 == null || sDate2 == null) {
      return 0;
    }
    var a = sDate1.toString().split('/');
    var b = sDate2.toString().split('/');
    var startDate =
        new DateTime(int.parse(a[0]), int.parse(a[1]), int.parse(a[2]));
    var endDate =
        new DateTime(int.parse(b[0]), int.parse(b[1]), int.parse(b[2]));
    var difference = endDate.difference(startDate);

    if (difference.inDays < 0) {
      // Fluttertoast.showToast(
      //     msg: '工作天数最少为当天，请选择有效天数', backgroundColor: Colors.red);
          return 0;
    }
    return difference.inDays+1;
    // 以月份来计算天数
    // var n;
    // if (difference.inDays > 30) {
    //   n = (difference.inDays / 30).toStringAsFixed(1);
    //   // print(double.parse(n) is double);
    //   return double.parse(n);
    // } else {
    //   n = difference.inDays;
    //   return n;
    // }
    //  print(n is String);
    // return int.parse(n)  ;
  }

  /*拍照*/
  static takePhoto() async {
    // var image = await ImagePicker.pickImage(source: ImageSource.camera);
    // return image;
    try{
      var image = await _picker.getImage(source: ImageSource.camera);
      return image;
    }catch(e){
      print('拍照出现错误:'+e);
    }
  }

  /*相册*/
  static openGallery() async {
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // return image;
    try{
      var image = await _picker.getImage(source: ImageSource.gallery);
      return image;
    }catch(e){
      print('照片选择出现错误:'+e);
    }
  }

  /*选取视频*/
  static getVideo() async {
    // var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    // return video;
    final PickedFile file = await _picker.getVideo(
          source: ImageSource.gallery, maxDuration: const Duration(seconds: 10));
          
    return file;
  }

  /*拍摄视频*/
  static takeVideo() async {
    // var video = await ImagePicker.pickVideo(source: ImageSource.camera);
    // // print('拍摄视频：' + image.toString());
    // return video;
    var video = await _picker.getVideo(source: ImageSource.camera);
    // print('拍摄视频：' + image.toString());
    return video;
  }

  /*裁剪图片 https://pub.dev/packages/image_cropper#-readme-tab-*/
  static Future cropImage(context, file, isForm) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: file,
      cropStyle:isForm ? CropStyle.rectangle : CropStyle.circle,
      aspectRatio: CropAspectRatio(ratioX: 8, ratioY: 8),
      compressQuality:0,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: '图片裁剪',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          hideBottomControls:true,
          
          lockAspectRatio: false),
    );
    if (croppedFile != null) {
      print(croppedFile);
      return croppedFile;
    }
  }

  // 时间戳转换成日期格式时间
  static  timeStamp(int time) {
      var newtime = DateTime.fromMillisecondsSinceEpoch(time * 1000).toString().split(' ');
      
      return newtime[0];
  }

  // 时间戳转换成日期格式时间
  static  datetimeStamp( time) {
      var newtime = DateTime.fromMillisecondsSinceEpoch(time * 1000).toString().split(' ');
      var newtime1 = newtime[1].substring(0, 5);
      var sec = '${newtime[0]}  $newtime1';
      return sec;
  }
  
  // 返回时分
  static hourtimeStamp(time){
    var newtime = time.toString().split(' ');
    return newtime[1].substring(0, 5);
  }

  // socket消息判断返回时间
  static dateTimeSocket(int time){
    var newtime = DateTime.fromMillisecondsSinceEpoch(time * 1000).toString().split(' ');
    var nowtime = DateTime.now().toString().split(' ');
    // print(nowtime);
    // nowtime.weekday;
    var a = nowtime[0].toString().split('-');
    var b = newtime[0].toString().split('-');
    // print(a);
    // print(b);
    var startDate = new DateTime(int.parse(a[0]), int.parse(a[1]), int.parse(a[2]));
    var endDate = new DateTime(int.parse(b[0]), int.parse(b[1]), int.parse(b[2]));
    var difference = endDate.difference(startDate);
    // print(difference.inDays);

    switch (difference.inDays) {
      case 0:
        var newtime1 = newtime[1].substring(0, 5);
        return newtime1;
        break;
      case -1:
        return '昨天';
      default:
        return newtime[0];
    }

    // return '123';
  }

  
  

  // 时间转换为时间戳
  static stampTime(DateTime now) {
    print('---------------------转换时间戳----------------------');
    print(now.millisecondsSinceEpoch);
    return now.millisecondsSinceEpoch.toString().substring(0, 10);
  }

}

// 通知用户需要定位
Future<bool> requestPermission() async {

  if (Platform.isAndroid) {
      // 检查当前权限状态。
      var permission = Permission.location;
      PermissionStatus _permissionStatus = await permission.status;

      if (_permissionStatus != PermissionStatus.granted) {
        // 没有权限，发起请求权限
        _permissionStatus = await permission.request();
        return _permissionStatus == PermissionStatus.granted;
      } else {
        return true;
      }
    } else {
      return true;
    }
}

