import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/plugins/ScreenAdapter.dart';

class WalletPage extends StatefulWidget {
  Map arguments;
  WalletPage(this.arguments);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'),color: Colors.white, size: ScreenAdapter.size(40)), onPressed: ()=>Navigator.pop(context),),
          title: Container(
            child:  Text('钱包', style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.size(35)),),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(IconData(0xe621, fontFamily: 'myIcon'),color: Colors.white, size: ScreenAdapter.size(40),),
              onPressed: (){
                Navigator.pushNamed(context, '/bill');
              },
            )
          ],
          elevation: 0,
      ),
      body:
      // Text('哈哈哈')
      ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          color: Color.fromRGBO(233, 233, 233, 0.7),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(ScreenAdapter.size(40)),
                width: double.infinity,
                height: ScreenAdapter.setHeight(350),
                color:Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('余额（元）', style: TextStyle(color: Colors.white),),
                    Expanded(
                      flex: 1,
                      child: Container(
                      alignment: Alignment.centerLeft,
                        child: Text('${stampPrice(widget.arguments['price'])}', style: TextStyle(color: Colors.white, fontSize: widget.arguments['price'].toString().length > 5 ?ScreenAdapter.size(100) : ScreenAdapter.size(150)), ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    walletButton(0xe61a, Colors.blue, '充值', (){
                      Map data = {
                        'title':'充值',
                        'isChong':true,
                        'isVip':widget.arguments['isVip']
                      };
                      print(data);
                      Navigator.pushNamed(context, '/ti_pay', arguments: data);
                    }),
                    Container(
                      width: double.infinity,
                      height: ScreenAdapter.setHeight(0.5),
                      color: Colors.grey,
                    ),
                    walletButton(0xe619, Colors.orange, '提现', (){
                      Fluttertoast.showToast(msg: '功能暂时没有实现！');
                      // Map data = {
                      //   'title':'提现',
                      //   'isChong':false,
                      //   'price':widget.arguments['price']
                      // };
                      // Navigator.pushNamed(context, '/ti_pay', arguments: data);
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenAdapter.setHeight(50),
              ),
              walletButton(0xe61e, Color(0xffEC6618), 'VIP', (){
                 Navigator.pushNamed(context, '/upgrade_vip');
              }),
            ],
          ),
        ),
      )
   
    );
  }

  Widget walletButton(icon,Color iconColor, String title, Function fn){
    return InkWell(
      onTap:fn,
      child: Container(
              color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical:ScreenAdapter.setHeight(20), horizontal: ScreenAdapter.setWidth(30)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenAdapter.setWidth(50),
                          child: Icon(IconData(icon, fontFamily: 'myIcon'), color: iconColor,size: ScreenAdapter.size(35),)
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left:ScreenAdapter.setWidth(15)),
                            child: Text('$title', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
                          ),
                        ),
                        Container(
                          child: Icon(IconData(0xe623, fontFamily: 'myIcon'), color: Colors.grey, size: ScreenAdapter.size(30),),
                        ),
                      ],
                    ),
                  ),
    );
  }
  // 计算钱的单位
  completePrice(price){
    print(price);
    if(price > 1000){
      return price.toString() + '千';
    }
  }

  // 保留两位
  stampPrice(price){
    return price.toStringAsFixed(2);
  }
}