import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/plugins/ScreenAdapter.dart';

class TiPayPage extends StatefulWidget {
  Map data;
  TiPayPage(this.data);
  @override
  _TiPayPageState createState() => _TiPayPageState();
}

class _TiPayPageState extends State<TiPayPage> {

  TextEditingController _numberController = TextEditingController();
  bool judgeTi = false;             // 是否可以支付
  bool exceed = true;               // 是否超出余额
  int payType = 1;                 // 支付类型
  int price = 0;
  
  @override
  void initState() { 
    super.initState();
    price = widget.data['price'];
    print(widget.data);
  }
  

  @override
  Widget build(BuildContext context) {
    // print(_numberController.text == '');
   
    
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(IconData(0xe622, fontFamily: 'myIcon'), size: ScreenAdapter.size(40),), onPressed: ()=>Navigator.pop(context),),
          title: Container(
            child:  Text('${widget.data['title']}',style: TextStyle(fontSize: ScreenAdapter.size(35))),
          ),
          centerTitle: true,
          elevation: 1,
        ),
      body: SingleChildScrollView(
        child:
        Container(
          color: Color.fromRGBO(233, 233, 233, 0.5),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                // height: ScreenAdapter.setHeight(510),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: <Widget>[
                    !widget.data['isChong'] ? Container(
                      padding: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                      color: Color.fromRGBO(233, 233, 233, 0.2),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            child: payType == 1 ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('到账支付宝', style: TextStyle(fontWeight: FontWeight.bold),),
                                Container(
                                  width: ScreenAdapter.setWidth(50),
                                  height: ScreenAdapter.setHeight(50),
                                  child: Image.asset('assets/images/ZhiFuBao.png',fit: BoxFit.contain,),
                                ),
                              ],
                            )
                            :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('到账微信', style: TextStyle(fontWeight: FontWeight.bold),),
                                Container(
                                  width: ScreenAdapter.setWidth(50),
                                  height: ScreenAdapter.setHeight(50),
                                  child: Image.asset('assets/images/WeChatPay.png',fit: BoxFit.contain,),
                                ),
                              ],
                            ),
                            onTap: (){
                              showPayDialog();
                            },
                          ),
                          Text('2小时内到账',style: TextStyle(color: Colors.black38,fontSize: ScreenAdapter.size(20)),)
                        ],
                      ),
                    )
                    :
                    Text(''),
                    Container(
                      padding: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                      margin: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${widget.data['title']}金额', style: TextStyle(fontWeight: FontWeight.bold),),
                          Container(
                            padding: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                            child: Row(
                              children: <Widget>[
                                Text('¥', style: TextStyle(fontSize: ScreenAdapter.size(70), fontWeight: FontWeight.bold),),
                                SizedBox(width: ScreenAdapter.setWidth(20),),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: _numberController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: ScreenAdapter.size(70)
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none
                                    ),
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(RegExp(
                                          "[0-9.]")), //只能输入汉字或者字母或数字
                                    ],
                                    onChanged: (val){
                                      // 不允许输入两次小数点
                                      var n = val.split('.').length-1;
                                      if(n>1){
                                        Fluttertoast.showToast(msg: '输入有误',gravity:ToastGravity.CENTER, backgroundColor: Colors.red, textColor: Colors.white);
                                        setState(() {
                                          this.judgeTi = false;
                                        });
                                        return;
                                      }
                                      // 不能以小数点开头
                                      var m = val.split('.');
                                      print(m[0]);
                                      if(m[0] == ''){
                                        Fluttertoast.showToast(msg: '输入有误，不能以空格或者小数点开头',gravity:ToastGravity.CENTER, backgroundColor: Colors.red, textColor: Colors.white);
                                        setState(() {
                                          this.judgeTi = false;
                                        });
                                        return;
                                      }
                                      // 判断是否可提现
                                      if(_numberController.text!='' && double.parse(_numberController.text) is double){
                                        setState(() {
                                          this.judgeTi = true;
                                        });
                                      }else{
                                        setState(() {
                                          this.judgeTi = false;
                                        });
                                      }
                                      if(!widget.data['isChong']){
                                        // 判断金额是否超出
                                        if(double.parse(_numberController.text) > price){
                                          setState(() {
                                            exceed = false;
                                            this.judgeTi = false;
                                          });
                                        }else{
                                          setState(() {
                                            exceed = true;
                                            this.judgeTi = true;
                                          });
                                        }
                                      }
                                      
                                    },
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              border:Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.black38
                                )
                              )
                            ),
                          ),
                          SizedBox(height: ScreenAdapter.setHeight(20),),
                          !exceed ?
                          Text('输入金额超出余额', style: TextStyle(color: Colors.red),)
                          :
                          !widget.data['isChong'] ?  Row(
                              children:[
                                Text(
                                   '当前余额${stampPrice(price)}元,',
                                  style: TextStyle(color: Colors.black45)
                                ),
                                InkWell(
                                  child: Text(
                                  '全部提现',
                                  style: TextStyle(color:Colors.blue)
                                ),
                                  onTap: (){
                                    setState(() {
                                      _numberController.text = price.toString();
                                      this.judgeTi = true;
                                    });
                                  },
                                )
                              ]
                            ):Text(''),
                          Container(
                            padding: EdgeInsets.all(ScreenAdapter.setWidth(20)),
                            width: double.infinity,
                            height: ScreenAdapter.setHeight(110),
                            child: RaisedButton(
                              color: Color(0xffff8080),
                              textColor: Colors.white,
                              child: Text('${widget.data['title']}'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              onPressed: (){
                                print(_numberController.text);
                                if(!judgeTi){
                                  Fluttertoast.showToast(msg: '请填写正确金额');
                                  return;
                                }
                                if(widget.data['isChong']){
                                  Map data = {
                                      'vip':true,
                                      'title':'充值余额,升级VIP',
                                      'price':_numberController.text,
                                    };
                                  Navigator.pushNamed(context, '/pay', arguments: data);
                                }else{
                                  Map data = {
                                    'vip':false,
                                    'title':'${widget.data['title']}',
                                    'price':_numberController.text,
                                  };
                                  Navigator.pushNamed(context, '/pay', arguments: data);
                                }
                              }
                            )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      
      
      )
      
    );
  }

  showPayDialog(){
    showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          title: Text('选择到账方式'),
          children: <Widget>[
            SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Text('支付宝', style: TextStyle(fontWeight: FontWeight.bold),),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20)),
                      width: ScreenAdapter.setWidth(50),
                      height: ScreenAdapter.setHeight(50),
                      child: Image.asset('assets/images/ZhiFuBao.png',fit: BoxFit.contain,),
                    ),
                ],
              ),
              onPressed: (){
                setState(() {
                  payType = 1;
                });
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Text('微信', style: TextStyle(fontWeight: FontWeight.bold),),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.setWidth(20)),
                      width: ScreenAdapter.setWidth(50),
                      height: ScreenAdapter.setHeight(50),
                      child: Image.asset('assets/images/WeChatPay.png',fit: BoxFit.contain,),
                    ),
                ],
              ),
              onPressed: (){
                setState(() {
                  payType = 2;
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  stampPrice(price){
    return price.toStringAsFixed(2);
  }
}