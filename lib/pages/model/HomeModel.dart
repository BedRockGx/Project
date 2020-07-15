// {
//   "img":"http://img2.imgtn.bdimg.com/it/u=1953606852,863263430&fm=26&gp=0.jpg",
//   "title":"你好，我是刘昊然司机，我会开汽车，火车，飞机",
//   "price":160,
//   "rommond":16  
// },
// {
//   "img":"http://img2.imgtn.bdimg.com/it/u=1953606852,863263430&fm=26&gp=0.jpg",
//   "title":"你好，我是刘昊然司机，我会开汽车，火车，飞机",
//   "price":160,
//   "rommond":16  
// },
// {
//   "img":"http://img2.imgtn.bdimg.com/it/u=1953606852,863263430&fm=26&gp=0.jpg",
//   "title":"你好，我是刘昊然司机，我会开汽车，火车，飞机",
//   "price":160,
//   "rommond":16  
// }

class HomeModel {

  String img;
  String title;
  int price;
  int rommond;

  HomeModel({this.img, this.title, this.price, this.rommond});

  HomeModel.fromJson(Map json){
    this.img = json['img'];
    this.title = json['title'];
    this.price = json['price'];
    this.rommond = json['rommond'];
  }
}