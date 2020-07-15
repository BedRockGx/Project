class FormModel {
  String lat;
  String lng;
  String title;
  String city;
  String provinceName;
  String districtName;
  String cityCode;

  FormModel({this.lat, this.lng, this.title, this.city, this.provinceName, this.districtName, this.cityCode});

  FormModel.fromJson(Map json){
    this.lat = json['lat'];
    this.lng = json['lng'];
    this.title = json['title'];
    this.city = json['city'];
    this.provinceName = json['provinceName'];
    this.districtName = json['districtName'];
    this.cityCode = json['cityCode'];
  }
}