class DriverInfoModel {
  int driverStatus;
  DriverInfoItem data;

  DriverInfoModel({this.driverStatus, this.data});

  DriverInfoModel.fromJson(Map<String, dynamic> json) {
    driverStatus = json['driver_status'];
    data = json['data'] != null ? new DriverInfoItem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_status'] = this.driverStatus;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DriverInfoItem {
  int isDriver;
  String idCard;
  String realName;
  String birthday;
  int sex;
  String firstReceiveTime;
  String startTime;
  String endTime;
  String carType;
  String licenseImg;

  DriverInfoItem(
      {this.isDriver,
      this.idCard,
      this.realName,
      this.birthday,
      this.sex,
      this.firstReceiveTime,
      this.startTime,
      this.endTime,
      this.carType,
      this.licenseImg});

  DriverInfoItem.fromJson(Map<String, dynamic> json) {
    isDriver = json['is_driver'];
    idCard = json['id_card'];
    realName = json['real_name'];
    birthday = json['birthday'];
    sex = json['sex'];
    firstReceiveTime = json['first_receive_time'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    carType = json['car_type'];
    licenseImg = json['license_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_driver'] = this.isDriver;
    data['id_card'] = this.idCard;
    data['real_name'] = this.realName;
    data['birthday'] = this.birthday;
    data['sex'] = this.sex;
    data['first_receive_time'] = this.firstReceiveTime;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['car_type'] = this.carType;
    data['license_img'] = this.licenseImg;
    return data;
  }
}