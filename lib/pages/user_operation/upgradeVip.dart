import 'package:flutter/material.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/ScreenAdapter.dart';

class UpgradeVip extends StatefulWidget {
  @override
  _UpgradeVipState createState() => _UpgradeVipState();
}

class _UpgradeVipState extends State<UpgradeVip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.navigate_before,size:ScreenAdapter.size(70), color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ) ,
        backgroundColor: Colors.black,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Container(
          color:Color.fromRGBO(233, 233, 233, 0.7),
          child: Stack(
            children: <Widget>[
              ScrollConfiguration(
          behavior: OverScrollBehavior(),
          child: ListView(
                children: <Widget>[
                  Container(
                    height: ScreenAdapter.setHeight(300),
                    child:Stack(
                      children: <Widget>[
                        Container(
                          height: ScreenAdapter.setHeight(230),
                          color: Colors.black,
                          padding: EdgeInsets.only(bottom: ScreenAdapter.setHeight(50)),
                          child:Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('升级', style: TextStyle(color: Color.fromRGBO(255,208,178, 1), fontSize: ScreenAdapter.size(50),fontWeight: FontWeight.bold)),
                              Container(
                                width: ScreenAdapter.setWidth(150),
                                height: ScreenAdapter.setHeight(120),
                                margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(10)),
                                child: Image.asset('assets/images/shoppingVip.png',fit: BoxFit.contain,),
                              ),
                              Text('提升接单效率', style: TextStyle(color: Color.fromRGBO(255,208,178, 1), fontSize: ScreenAdapter.size(50),fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: ScreenAdapter.setHeight(0),
                          child: Center(
                            child: Container(
                              width: ScreenAdapter.getScreenWidth(),
                              height: ScreenAdapter.setHeight(150),
                              padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20)),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255,208,178, 1),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: ListTile(
                                  title: Text('VIP会员', style: TextStyle(color: Color.fromRGBO(79, 49, 12, 1), fontSize: ScreenAdapter.size(45), fontWeight: FontWeight.bold)),
                                  subtitle: Text('尊享特权，更快速的接单', style: TextStyle(color: Color.fromRGBO(79, 49, 12, 1)),),
                                  trailing: InkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(30), vertical: ScreenAdapter.setWidth(15)),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: Text('立即开通',style: TextStyle(color:Color.fromRGBO(255,208,178, 1) ),),
                                    ),
                                    onTap: (){
                                      Map data = {
                                        'vip':true,
                                        'title':'充值余额,升级VIP',
                                        'price':8000
                                      };
                                      Navigator.pushNamed(context, '/pay',arguments: data );
                                    },
                                  )
                                ),
                              ),
                            ),
                          )
                        )
                      ],
                    )
                  ),
                  
                  Container(
                    margin: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                    padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20),vertical: ScreenAdapter.setHeight(20)),
                    // height: ScreenAdapter.setHeight(200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: ScreenAdapter.setWidth(80),
                              height: ScreenAdapter.setHeight(80),
                              margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(10)),
                              child: Image.asset('assets/images/shoppingVip.png',fit: BoxFit.contain,),
                            ),
                            Text('特权须知', style: TextStyle(color: Color.fromRGBO(229, 180, 148, 0.7), fontSize: ScreenAdapter.size(40), fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Text('1.每月交易额值达到8000元即可成为会员', style: TextStyle(fontSize: ScreenAdapter.size(35), color: Colors.redAccent)),
                        Text('2.充值成功后，将会以余额的形式暂存在平台，发布订单，将扣除余额', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
                        Text('3.保持活跃', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                    padding: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20), vertical: ScreenAdapter.setHeight(20)),
                    // height: ScreenAdapter.setHeight(280),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: ScreenAdapter.setWidth(80),
                              height: ScreenAdapter.setHeight(80),
                              margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(10)),
                              child: Image.asset('assets/images/shoppingVip.png',fit: BoxFit.contain,),
                            ),
                            Text('专属特权', style: TextStyle(color: Color.fromRGBO(229, 180, 148, 0.7), fontSize: ScreenAdapter.size(40), fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Text('1.优先推送消息', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
                        Text('2.尊贵身份标识', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
                        Text('3.可接VIP专属单', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
                        Text('4.可进入专属VIP群', style: TextStyle(fontSize: ScreenAdapter.size(35)),),
                      ],
                    ),
                  ),
                ],
              ),
          ),
              
              Positioned(
                bottom: 0,
                child: Container(
                  width: ScreenAdapter.setWidth(750),
                  height: ScreenAdapter.setHeight(100),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black,
                          height: ScreenAdapter.setHeight(100),
                          child: Text('8000元',style: TextStyle(color: Color.fromRGBO(255, 185, 139, 1), fontSize: ScreenAdapter.size(40), fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: ScreenAdapter.setWidth(250),
                        height: ScreenAdapter.setHeight(100),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color.fromRGBO(229, 166, 125, 1), Color.fromRGBO(247, 207, 187, 1)]),
                        ),
                        child: InkWell(
                          child: Text('立即充值', style: TextStyle(color: Color.fromRGBO(79, 49, 12, 1), fontSize: ScreenAdapter.size(30), fontWeight: FontWeight.bold),),
                          onTap: (){
                            Map data = {
                              'vip':true,
                              'title':'充值余额,升级VIP',
                              'price':8000
                            };
                            Navigator.pushNamed(context, '/pay',arguments: data );
                          },
                        )
                      )
                    
                    ],
                  )
                ),
              )
            ],
          )
        ),
      )
    );
  }
}