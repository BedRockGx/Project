import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/config/api.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/plugins/alertDialog.dart';
import 'package:tobias/tobias.dart';


class PayPage extends StatefulWidget {
  Map data;
  PayPage(this.data);
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {

  int groupValue=1;
  var payInfo;

  var api = new Api();

  @override
  void initState() { 
    super.initState();
    print('传入参数');
    print(widget.data);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
          title: Container(
            child:  Text(widget.data['vip'] ? '确认支付': '确认发布',style: TextStyle(fontSize: ScreenAdapter.size(35))),
          ),
          centerTitle: true,
          elevation: 1,
        ),
      body: Stack(
        children: <Widget>[
          Container(
        padding: EdgeInsets.all(ScreenAdapter.setWidth(30)),
        child: ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child: ListView(
          children: <Widget>[
            // ListTile(
            //   leading: widget.data['vip'] ? 
            //   Container(
            //     width: ScreenAdapter.setWidth(80),
            //     height: ScreenAdapter.setHeight(80),
            //     child: Image.asset('assets/images/payVip.png',fit: BoxFit.contain,),
            //   )
            //   :
            //   Container(
            //     width: ScreenAdapter.setWidth(80),
            //     height: ScreenAdapter.setHeight(80),
            //     child: Image.asset('assets/images/Recharge.png',fit: BoxFit.contain,),
            //   ),
            //   title: Text('${widget.data['title']}', style: TextStyle(fontSize: ScreenAdapter.size(25)),),
            //   trailing: Text('${widget.data['price']}元', style: TextStyle(color: Colors.grey)),
            // ),
            // Divider(),
            ListTile(
              leading: Text('需支付:'),
              trailing: Text('${widget.data['price']}元', style: TextStyle(color: Colors.redAccent),),
            ),
            // Divider(),
            SizedBox(height: ScreenAdapter.setHeight(50),),
            widget.data['vip'] ? 
            Column(
              children: <Widget>[
                ListTile(
                  leading: Text('选择支付方式'),
                ),
                // Divider(),
                  ListTile(
                    leading:  Container(
                      width: ScreenAdapter.setWidth(80),
                      height: ScreenAdapter.setHeight(80),
                      child: Image.asset('assets/images/ZhiFuBao.png',fit: BoxFit.contain,),
                    ),
                    title: Text('支付宝支付'),
                    trailing: groupValue==1 ? Icon(Icons.check_circle, color: Colors.blue,) : Icon(Icons.panorama_fish_eye),
                    onTap: (){
                      setState(() {
                        groupValue = 1;
                      });
                    },
                  ),
                  // Divider(),
                  // ListTile(
                  //   leading:  Container(
                  //     width: ScreenAdapter.setWidth(80),
                  //     height: ScreenAdapter.setHeight(80),
                  //     child: Image.asset('assets/images/WeChatPay.png',fit: BoxFit.contain,),
                  //   ),
                  //   title: Text('微信支付'),
                  //   trailing: groupValue==2 ? Icon(Icons.check_circle, color: Colors.blue,) : Icon(Icons.panorama_fish_eye),
                  //   onTap: (){
                  //     setState(() {
                  //       groupValue = 2;
                  //     });
                  //   },
                  // ),
              ],
            )
            :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Text('支付方式'),
                ),
                // Divider(),
                  ListTile(
                    leading:  Container(
                      width: ScreenAdapter.setWidth(80),
                      height: ScreenAdapter.setHeight(80),
                      child: Image.asset('assets/images/walletPay.png',fit: BoxFit.contain,),
                    ),
                    title: Text('钱包支付'),
                    trailing: Icon(Icons.check_circle, color: Colors.blue,)
                  ),
              ],
            )
          ],
        ),
      )
        
      ),
      Positioned(
        bottom: 20,
        width: ScreenAdapter.setWidth(750),
        height: ScreenAdapter.setHeight(80),
        child: InkWell(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal:ScreenAdapter.setWidth(60)),
            alignment: Alignment.center,
            width: ScreenAdapter.setWidth(750),
            // height: ScreenAdapter.setHeight(50),
            decoration: BoxDecoration(
              color: Color(0xffff8080),
              borderRadius: BorderRadius.circular(50)
            ),
            child: Text(widget.data['vip'] ? '确认支付': '确认发布', style: TextStyle(color: Colors.white),)
          ),
          onTap: (){
            if(widget.data['vip']){
              print('调用支付宝和微信接口');
              api.postData(context, 'aliPay', formData: {"total_amount":'${widget.data['price']}'}).then((val){
                if(val == null){
                  return ;
                }
                print(json.decode(val.toString()));
                var response = json.decode(val.toString());
                setState(() {
                  payInfo = response['order_info'];
                });
                ali_pay();
              });
            }else{
              api.postData(context, 'addOrder',formData: widget.data['formData']).then((val) {
                // print();
                if(val == null ){
                  return ;
                }
                var msg =json.decode(val.toString());
                // Fluttertoast.showToast( msg: msg['msg']);
                alertDialog(context, '提示',  '发布成功！是否关闭当前页面？', (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
                    
              });
            }
          },
        )
      )
        ],
      )
    );
  }


  ali_pay()  async {
    print(payInfo);
    var payResult = await aliPay(payInfo);
      print("--->$payResult");
  }
}