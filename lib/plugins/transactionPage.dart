import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Loading.dart';
import 'package:project/plugins/ScreenAdapter.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {

  var api = new Api();
  var response;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData(){
    api.getData(context, 'month_limit').then((val){
      print('返回信息');
        if(val ==null){
          return;
        }
        
        setState(() {
          response = json.decode(val.toString());
        });
        print(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2196F3),
        leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40), color: Colors.white,), onPressed: ()=>Navigator.pop(context),),
        title: Text('月交易额', style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(35)),),
        centerTitle: true,
        elevation: 0,
      ),
      body: response == null ? 
      Center(
        child: CircularProgressIndicator(),
      ):
      Container(
        color: Color(0xff2196F3),
        // width: 750 * rpx,
        // height: ScreenAdapter.setHeight(650),
        height: 680 * rpx,
        // padding: EdgeInsets.all(ScreenAdapter.setWidth(20)),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical:ScreenAdapter.setHeight(20)),
              child: Text('本月交易额',style: TextStyle(color: Colors.white),),
            ),
            circularWidget(context),
            Container(
              margin: EdgeInsets.symmetric(vertical: ScreenAdapter.setHeight(20)),
              padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(100)),
              child: Divider(color: Colors.white,),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(30),),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Text('总交易笔数',  style: TextStyle(color: Colors.white)),
                        Text('${response['employer_order_num']}',  style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(35), fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Container(
                    width: ScreenAdapter.setWidth(1),
                    height: ScreenAdapter.setHeight(70),
                    color: Colors.white,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Text('个人信誉度', style: TextStyle(color: Colors.white),),
                        Text('${response['employer_reputation']}%', style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(35), fontWeight: FontWeight.bold))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Widget circularWidget(context){
    final rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      margin: EdgeInsets.symmetric(vertical:ScreenAdapter.setHeight(10)),
      height: 360 * rpx,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,left: ScreenAdapter.setWidth(200),
            child: Container(
              width: ScreenAdapter.setWidth(360),
              child: AspectRatio(
                aspectRatio: 1/1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(180),
                  child: Container(
                    width: ScreenAdapter.setWidth(300),
                    padding: EdgeInsets.all(6),
                    color: Color.fromRGBO(35, 134, 217, 1),
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(180),
                        child: Container(
                          width: ScreenAdapter.setWidth(290),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(width:ScreenAdapter.setWidth(5),color:Colors.white),
                            borderRadius: BorderRadius.circular(150),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1/1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(160),
                              child: Container(
                                alignment: Alignment.center,
                                color: Color.fromRGBO(129, 198, 255, 1),
                                child: Text('${transformPrice(response['month_pay'])}',style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(70)),),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ),
          
        ],
      ),
    );
  }

  transformPrice(n){
    if(n != null){
      return n.toStringAsFixed(2);
    }
  }


}