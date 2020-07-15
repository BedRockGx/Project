import 'package:flutter/material.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/ScreenAdapter.dart';
import 'package:project/pages/EventBus/bus.dart';

class MessageListPage extends StatefulWidget {
  final arguments;
  MessageListPage(this.arguments);
  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              IconData(0xe622, fontFamily: 'myIcon'),
              size: ScreenAdapter.size(40),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Container(
            child: Text(
              '消息(3)',
            ),
          ),
          centerTitle: true,
          elevation: 10,
        ),
        body: Container(
            color: Color.fromRGBO(233, 232, 233, 0.9),
            child: ScrollConfiguration(
              behavior: OverScrollBehavior(),
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: <Widget>[
                        // socketTitle('消息', Icons.message),
                        CardWidget(context)
                        // socketInformation()
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}

// 消息类型
Widget socketTitle(String title, icon) {
  return Container(
    margin: EdgeInsets.all(ScreenAdapter.setWidth(7)),
    padding: EdgeInsets.all(ScreenAdapter.setWidth(10)),
    child: Row(
      children: <Widget>[
        Icon(icon, color: Color.fromRGBO(200, 200, 200, 1)),
        SizedBox(
          width: ScreenAdapter.setWidth(20),
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: ScreenAdapter.size(30),
              color: Color.fromRGBO(200, 200, 200, 1)),
        )
      ],
    ),
  );
}

// Card消息列表
Widget CardWidget(context) {
  List<Map> messageData = [
    {
      'username': '马云',
      'img':
          'https://gss0.bdstatic.com/-4o3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=0003b03088b1cb133e693b15e56f3173/0bd162d9f2d3572c257447038f13632763d0c35f.jpg',
      'message': '在吗？我不想要阿里了，给你了，给我个准信',
      'time': '16:34',
      'isNew': true
    },
    {
      'username': '王健林',
      'img':
          'https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/70e53284e7e606e1bc9a230047e0c39b_342_194.jpg',
      'message': '我错了，我当初就应该听你的选择，现在我负债，真的很难受，你能帮帮我嘛',
      'time': '12:05',
      'isNew': false
    },
    {
      'username': '李彦宏',
      'img':
          'https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/baike/pic/item/2f738bd4b31c8701928251782d7f9e2f0708ff7c.jpg',
      'message': '关于公司转让合同事情，我这边已经办好了，老板，你还有什么吩咐的吗',
      'time': '2019/11/09',
      'isNew': true,
    },
    {
      'username': '马化腾',
      'img':
          'https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=6894791,377714950&fm=85&app=52&f=JPEG?w=121&h=75&s=8E9B834D6E134DD4022261B30300C04A',
      'message': '大哥，腾讯有您的存在，真是蓬荜生辉啊，你啥时候回来啊',
      'time': '16:34',
      'isNew': false
    },
    {
      'username': '雷军',
      'img':
          'https://ss1.bdstatic.com/6OF1bjeh1BF3odCf/it/u=2830014756,2720188277&fm=74&app=80&f=JPEG&size=f121,140?sec=1880279984&t=a4b65f189e2a899d5ea6a1ce96d6af37',
      'message': '对不起之前是我有眼不识泰山，我想加入你们',
      'time': '2019/11/05',
      'isNew': false
    },
    {
      'username': '柳传志',
      'img':
          'https://ss0.bdstatic.com/6Ox1bjeh1BF3odCf/it/u=1870688149,1160460193&fm=74&app=80&f=JPEG&size=f121,140?sec=1880279984&t=b6ac84101979a58e5a0168e0c2f4bd5a',
      'message': '小弟不才，怎敢让您在我这里学习呢',
      'time': '2019/11/02',
      'isNew': false
    },
  ];

  return Container(
    child: Column(
        children: messageData.map((value) {
      return InkWell(
        child: Card(
          elevation: 0.5,
          shape: const RoundedRectangleBorder(
            //形状
            //修改圆角
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
          child: ListTile(
            dense: true,
            leading: AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(value['img'], fit: BoxFit.cover)),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(value['username'], style: TextStyle(fontSize: 20.0)),
                Text(value['time'],
                    style:
                        TextStyle(fontSize: 10.0, fontWeight: FontWeight.w300)),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: ScreenAdapter.setWidth(450),
                  child: Text(
                    value['message'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                value['isNew']
                    ? ClipOval(
                        child: Container(
                            width: ScreenAdapter.setWidth(35),
                            height: ScreenAdapter.setHeight(30),
                            color: Colors.redAccent,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '10',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      )
                    : Text('')
              ],
            ),
          ),
        ),
        onTap: () {
          print(value['username']);
          Navigator.pushNamed(context, '/chatPage');
        },
      );
    }).toList()),
  );
}

// Card官方消息
Widget CardCustomerServiceWidget() {
  return Container(
      child: Card(
    elevation: 0,
    child: ListTile(
      dense: true,
      leading: Container(
        width: ScreenAdapter.setWidth(100),
        height: ScreenAdapter.setHeight(80),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
                'https://ss0.bdstatic.com/6Ox1bjeh1BF3odCf/it/u=1238416336,2316303066&fm=74&app=80&f=JPEG&size=f121,121?sec=1880279984&t=0902247d162479f35d9445269958e5b8',
                fit: BoxFit.cover)),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('App客服', style: TextStyle(fontSize: 20.0)),
          Text('10:00',
              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w300)),
        ],
      ),
      subtitle: Text(
        '恭喜你获得满199减100，购品质沙龙的骄傲是降低为',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ));
}

// 自定义消息列表
Widget socketInformation() {
  List<Map> messageData = [
    {
      'username': '马云',
      'img':
          'https://gss0.bdstatic.com/-4o3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=0003b03088b1cb133e693b15e56f3173/0bd162d9f2d3572c257447038f13632763d0c35f.jpg',
      'message': '在吗？我不想要阿里了，给你了，给我个准信',
      'time': '16:34'
    },
    {
      'username': '王健林',
      'img':
          'https://ss0.bdstatic.com/-0U0bnSm1A5BphGlnYG/tam-ogel/70e53284e7e606e1bc9a230047e0c39b_342_194.jpg',
      'message': '我错了，我当初就应该听你的选择，现在我负债，真的很难受，你能帮帮我嘛',
      'time': '12:05'
    },
    {
      'username': '李彦宏',
      'img':
          'https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/baike/pic/item/2f738bd4b31c8701928251782d7f9e2f0708ff7c.jpg',
      'message': '关于公司转让合同事情，我这边已经办好了，老板，你还有什么吩咐的吗',
      'time': '2019/11/09'
    },
    {
      'username': '马化腾',
      'img':
          'https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=6894791,377714950&fm=85&app=52&f=JPEG?w=121&h=75&s=8E9B834D6E134DD4022261B30300C04A',
      'message': '大哥，腾讯有您的存在，真是蓬荜生辉啊，你啥时候回来啊',
      'time': '16:34'
    },
    {
      'username': '雷军',
      'img':
          'https://ss1.bdstatic.com/6OF1bjeh1BF3odCf/it/u=2830014756,2720188277&fm=74&app=80&f=JPEG&size=f121,140?sec=1880279984&t=a4b65f189e2a899d5ea6a1ce96d6af37',
      'message': '对不起之前是我有眼不识泰山，我想加入你们',
      'time': '2019/11/05'
    },
    {
      'username': '柳传志',
      'img':
          'https://ss0.bdstatic.com/6Ox1bjeh1BF3odCf/it/u=1870688149,1160460193&fm=74&app=80&f=JPEG&size=f121,140?sec=1880279984&t=b6ac84101979a58e5a0168e0c2f4bd5a',
      'message': '小弟不才，怎敢让您在我这里学习呢',
      'time': '2019/11/02'
    },
  ];

  if (messageData != null) {
    print(messageData is List);
    return Container(
      child: Column(
          children: messageData.map((value) {
        return Container(
          margin: EdgeInsets.all(ScreenAdapter.setWidth(7)),
          padding: EdgeInsets.all(ScreenAdapter.setWidth(10)),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  height: ScreenAdapter.setHeight(80),
                  // color: Colors.red,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(value['img'], fit: BoxFit.cover)),
                ),
              ),
              Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.only(left: ScreenAdapter.setWidth(20)),
                    height: ScreenAdapter.setHeight(80),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              value['username'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(value['time'],
                                style: TextStyle(
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: ScreenAdapter.setWidth(500),
                              child: Text(value['message'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.grey)),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        );
      }).toList()),
    );
  }
}

// 自定义官方消息
Widget CustomerService() {
  return Container(
    margin: EdgeInsets.all(ScreenAdapter.setWidth(7)),
    padding: EdgeInsets.all(ScreenAdapter.setWidth(10)),
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            height: ScreenAdapter.setHeight(80),
            // color: Colors.red,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                    'https://ss0.bdstatic.com/6Ox1bjeh1BF3odCf/it/u=1238416336,2316303066&fm=74&app=80&f=JPEG&size=f121,121?sec=1880279984&t=0902247d162479f35d9445269958e5b8',
                    fit: BoxFit.cover)),
          ),
        ),
        Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.only(left: ScreenAdapter.setWidth(20)),
              height: ScreenAdapter.setHeight(80),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'APP客服',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('10:00',
                          style: TextStyle(
                            color: Colors.grey,
                          ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: ScreenAdapter.setWidth(500),
                        child: Text('恭喜你获得满199减100，购品质沙龙的骄傲是降低为',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.grey)),
                      )
                    ],
                  )
                ],
              ),
            )),
      ],
    ),
  );
}
