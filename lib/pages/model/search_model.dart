

import 'package:amap_search_fluttify/amap_search_fluttify.dart';

class LocationSearch {
  String title;
  String address;
  double latitude;
  double longitude;
  String distance;
  String cityName;
  String provinceName;
  String adCode;
  String adName;

  LocationSearch({this.title, this.address, this.distance, this.latitude, this.longitude, this.cityName, this.provinceName,this.adName, this.adCode});

  LocationSearch.fromJson(Map json){
    this.title = json['title'];
    this.address = json['price'];
    this.distance = json['distance'];
    this.latitude = json['latLng'];
    this.longitude = json['longitude'];
    this.cityName = json['cityName'];
    this.provinceName = json['provinceName'];
    this.adCode = json['adCode'];
    this.adName = json['adName'];
  }
}

