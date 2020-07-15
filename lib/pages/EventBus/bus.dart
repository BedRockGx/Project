import 'package:event_bus/event_bus.dart';

// Bus初始化
EventBus eventBus = EventBus();

class OrderHallRefresh{
  String val;

  OrderHallRefresh(str){
    this.val = str;
  }
}

class LocationOver{
  String val;

  LocationOver(str){
    this.val = str;
  }
}

class NetWorkOver{
  String val;

  NetWorkOver(str){
    this.val = str;
  }
}