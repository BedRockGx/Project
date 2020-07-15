import 'package:flutter/material.dart';
import 'package:project/plugins/Behavior.dart';
import 'package:project/plugins/ScreenAdapter.dart';

class ArticleDetailsPage extends StatelessWidget {
  final arguments;
  ArticleDetailsPage(this.arguments, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('传过来的Id：${arguments}');
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            padding: EdgeInsets.all(10),
            child: ScrollConfiguration(
              behavior: OverScrollBehavior(),
              child: ListView(
                children: <Widget>[
                  Container(
                      // color: Colors.blue,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '习近平和彭丽媛设宴欢迎出席第二届中国国际进口博览会的各国贵宾',
                        style: TextStyle(
                            fontSize: ScreenAdapter.size(40),
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: ScreenAdapter.setHeight(10),
                      ),
                      Text(
                        '2019-11-08',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )),
                  Divider(),
                  Container(
                    margin: EdgeInsets.only(top: ScreenAdapter.setHeight(15)),
                    height: ScreenAdapter.setHeight(350),
                    child: Image.network(
                        'http://www.gov.cn/xinwen/2019-11/03/5448083/images/c432a5db703d4d5983f5431c6c118807.jpg',
                        fit: BoxFit.cover),
                  ),
                  Container(
                    child: Text(
                      '埃里克森的加拉可视对讲卡德加阿喀琉斯大,流口水的骄傲流口水的骄傲是考虑。到结案率可视对讲爱丽丝肯德,基拉克丝的记录卡数据的埃里克森的加拉可视对讲卡德加阿喀琉斯大流口水的骄傲流口水的骄傲是考虑到结案率可视对讲爱丽丝肯德基拉克丝的记录卡数据的分割线——）——记录卡数据的埃里克森的加拉可视对讲卡德加阿喀琉斯大流口水的骄傲流口水的骄傲是考虑到结案率可视对讲爱丽丝肯德基拉记录卡数据的埃里克森的加拉可视对讲卡德加阿喀琉斯大流口水的骄傲流口水的骄傲是考虑到结案率可视对讲爱丽丝肯德基拉',
                      style: TextStyle(
                          fontSize: ScreenAdapter.size(32), letterSpacing: 0.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenAdapter.setHeight(15)),
                    height: ScreenAdapter.setHeight(350),
                    child: Image.network(
                        'http://www.xinhuanet.com/politics/titlepic/112399/1123992813_1547534111323_title0h.jpg',
                        fit: BoxFit.cover),
                  ),
                  Container(
                    child: Text(
                      '埃里克森的加拉可视对讲卡德加阿喀琉斯大,流口水的骄傲流口水的骄傲是考虑。到结案率可视对讲爱丽丝肯德,基拉克丝的记录卡数据的埃里克森的加拉可视对讲卡德加阿喀琉斯大流口水的骄傲流口水的骄傲是考虑到结案率可视对讲爱丽丝肯德基拉克丝的记录卡数据的分割线——）——记录卡数据的埃里克森的加拉可视对讲卡德加阿喀琉斯大流口水的骄傲流口水的骄傲是考虑到结案率可视对讲爱丽丝肯德基拉记录卡数据的埃里克森的加拉可视对讲卡德加阿喀琉斯大流口水的骄傲流口水的骄傲是考虑到结案率可视对讲爱丽丝肯德基拉',
                      style: TextStyle(fontSize: ScreenAdapter.size(32)),
                    ),
                  ),
                ],
              ),
            )));
  }
}
