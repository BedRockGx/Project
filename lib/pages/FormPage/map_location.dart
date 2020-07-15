// import 'package:flutter/material.dart';
// import 'package:amap_map_fluttify/amap_map_fluttify.dart';              // 地图
// import 'package:amap_location_fluttify/amap_location_fluttify.dart';    // 定位
// import 'package:permission_handler/permission_handler.dart'; // 权限申请
// import 'package:project/plugins/Plugins.dart'; // 公用方法(申请定位)

// import 'package:project/plugins/map_plugins.dart';                      // 地图封装控件


// final _assetsIcon = Uri.parse('images/test_icon.png');

// class MapLocation extends StatefulWidget {
//   @override
//   _MapLocationState createState() => _MapLocationState();
// }

// class _MapLocationState extends State<MapLocation> {

//   Location _location;
//   AmapController _controller;
//   bool _selected = false;

//   var longitude;        // 经度
//   var latitude;         // 维度
//   var new_location;


//   @override
//   void initState() { 
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           children: <Widget>[

//             Flexible(
//             flex: 1,
//             child: AmapView(
//               onMapCreated: (controller) async {
//                 _controller = controller;
//                 if (await requestPermission()) {
//                   await controller.showMyLocation(false);
//                 }
//               },
//             ),
//           ),
//             SwitchListTile(
//               title: Text('是否显示定位'),
//               value: _selected,
//               onChanged: (selected) {
//                 print(selected);
//                 setState(() {
//                   _selected = selected;
//                   _controller?.showMyLocation(selected);
//                 });
//               },
//             ),
//             DiscreteSetting(
//                   head: '设置地图中心点',
//                   options: ['当前定位', '北京', '上海'],
//                   onSelected: (value) {
//                     print('经度${longitude}');
//                     print('维度${latitude}');
//                     switch (value) {
//                       case '当前定位':
//                         _controller?.setCenterCoordinate(
//                           latitude,
//                           longitude,
//                           animated: false,
//                         );
//                         _controller?.showMyLocation(
//                           true,
//                         );
//                         break;
//                       case '北京':
//                         _controller?.setCenterCoordinate(
//                           39.90960,
//                           116.397228,
//                           animated: true,
//                         );
//                         break;
//                       case '上海':
//                         _controller?.setCenterCoordinate(31.22, 121.48);
//                         break;
//                     }
//                   },
//                 ),
//                 RaisedButton(
//               child: Text('获取连续定位'),
//               onPressed: () async {
//                 if (await requestPermission()) {
//                   AmapLocation.startLocation(
//                     once: false,
//                     locationChanged: (location) async{
//                       _location =location;
//                       var a = await _location.address;
//                       var b = await _location.longitude;
//                       var c = await _location.latitude;
                    
//                      setState(() {
//                       new_location = a;
//                       longitude = b;
//                       latitude = c;
//                      });

//                       print('位置:${new_location}');
//                       print('经度${longitude}');
//                       print('维度${latitude}');
                      
//                       _controller?.setCenterCoordinate(
//                           latitude,
//                           longitude,
//                           animated: false,
//                         );
//                         _controller?.showMyLocation(
//                           true,
//                         );
//                     },
//                   );
//                 }
//               },
//             ),
//             RaisedButton(
//               child: Text('获取单次定位'),
//               onPressed: () async {
//                 if (await requestPermission()) {
//                   AmapLocation.startLocation(
//                     once: true,
//                     locationChanged: (location) async {
                      
//                       _location =location;
//                       var a = await _location.address;
//                       var b = await _location.longitude;
//                       var c = await _location.latitude;
                    
//                      setState(() {
//                       new_location = a;
//                       longitude = b;
//                       latitude = c;
//                      });

//                       print('位置:${new_location}');
//                       print('经度${longitude}');
//                       print('维度${latitude}');

//                       // _controller?.showMyLocation(
//                       //     true,
//                       //   );

                     
//                     },
//                   );
//                 }
//               },
//             ),
//             RaisedButton(
//               child: Text('停止定位'),
//               onPressed: () async {
//                 if (await requestPermission()) {
//                   await AmapLocation.stopLocation();
//                 }
//               },
//             ),
//             if (_location != null)
//               FutureBuilder<String>(
//                 initialData: '',
//                 future: _location.address,
//                 builder: (_, ss){
//                   return Center(child: Text('address: ${ss.data}' ?? ''));
//                 }
                    
//               ),
//             if (_location != null)
//               FutureBuilder<String>(
//                 initialData: '',
//                 future: _location.country,
//                 builder: (_, ss) =>
//                     Center(child: Text('country: ${ss.data}' ?? '')),
//               ),
//             if (_location != null)
//               FutureBuilder<String>(
//                 initialData: '',
//                 future: _location.province,
//                 builder: (_, ss) =>
//                     Center(child: Text('province: ${ss.data}' ?? '')),
//               ),
//             if (_location != null)
//               FutureBuilder<String>(
//                 initialData: '',
//                 future: _location.city,
//                 builder: (_, ss) =>
//                     Center(child: Text('city: ${ss.data}' ?? '')),
//               ),
//             if (_location != null)
//               FutureBuilder<String>(
//                 initialData: '',
//                 future: _location.district,
//                 builder: (_, ss) =>
//                     Center(child: Text('district: ${ss.data}' ?? '')),
//               ),
//             if (_location != null)
//               FutureBuilder<String>(
//                 initialData: '',
//                 future: _location.poiName,
//                 builder: (_, ss) =>
//                     Center(child: Text('poiName: ${ss.data}' ?? '')),
//               ),
//             if (_location != null)
//               FutureBuilder<String>(
//                 initialData: '',
//                 future: _location.street,
//                 builder: (_, ss) =>
//                     Center(child: Text('street: ${ss.data}' ?? '')),
//               ),
//             if (_location != null)
//               FutureBuilder<String>(
//                 initialData: '',
//                 future: _location.aoiName,
//                 builder: (_, ss) =>
//                     Center(child: Text('aoiName: ${ss.data}' ?? '')),
//               ),
//             if (_location != null)
//               FutureBuilder<double>(
//                 initialData: 0.0,
//                 future: _location.latitude,
//                 builder: (_, ss) =>
//                     Center(child: Text('latitude: ${ss.data}' ?? '')),
//               ),
//             if (_location != null)
//               FutureBuilder<double>(
//                 initialData: 0.0,
//                 future: _location.longitude,
//                 builder: (_, ss) =>
//                     Center(child: Text('longitude: ${ss.data}' ?? '')),
//               ),
//             if (_location != null)
//               FutureBuilder<double>(
//                 initialData: 0.0,
//                 future: _location.altitude,
//                 builder: (_, ss) =>
//                     Center(child: Text('altitude: ${ss.data}' ?? '')),
//               ),
//           ],
//         ),
//       ),
//     );
//   }



 
// }