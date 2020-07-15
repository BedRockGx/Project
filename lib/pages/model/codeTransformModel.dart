import 'package:amap_search_fluttify/amap_search_fluttify.dart';

class LocationTransformCode {
  
  LatLng latLng;

  LocationTransformCode({this.latLng});

  LocationTransformCode.fromJson(Map json){
    this.latLng = json['latLng'];
  }
}