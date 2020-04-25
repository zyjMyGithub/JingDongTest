import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jingdong_app/routers/application_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../routers/routers.dart';
import 'dart:convert';

//这里我们写一个滚动的轮播图 widget使用flutter_swiper来实现

class MySwiperWidget extends StatelessWidget {
  //首先我们要接收来时调用的数据，以便于知道我们要显示几张展示内容
  //我们的这个项目里面的首页数据{"code":"0","message":"success","data":{"slides":[{"image":"https://images.baixingliangfan.cn/advertesPicture/20200101/20200101143619_558.jpg","urlType":1,"goodsId":"/pages/groupBuy/pages/group-list/group-list"},{"image":"https://images.baixingliangfan.cn/advertesPicture/20200101/20200101143633_9256.jpg","urlType":1,"goodsId":"/pages/groupBuy/pages/group-list/group-list"}],"shopInfo":{"leaderImage":"https://images.baixingliangfan.cn/leaderImage/20191119/20191119110455_4059.jpg","leaderPhone":"15903935264"},"integralMallPic":{"PICTURE_ADDRESS":"https://images.baixingliangfan.cn/advertesPicture/20191021/20191021154502_1594.png","TO_PLACE":"1","urlType":0},"toShareCode":{"PICTURE_ADDRESS":"http://images.baixingliangfan.cn/advertesPicture/20180629/20180629125808_7351.png","TO_PLACE":"1","urlType":0},"recommend":[{"image":"https://images.baixingliangfan.cn/compressedPic/20190909174301_8250.jpg","mallPrice":328.00,"goodsName":"红花郎（10）53°500ml","goodsId":"00cee04d12474910bfeb7930f6251c22","price":458.00}
  final List datas;

  MySwiperWidget({this.datas});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(333), //这里是使用ScreenUtil来涉及UI显示的高度,
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          onTap: (index){
            //点击跳转到商品详情页面
            goGoodsDetail(context,datas[index]);
          },
          itemCount: datas.length,
          pagination: new SwiperPagination(), //轮播图上面的指示器
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              "${datas[index]['image']}",
              fit: BoxFit.fill,
            );
          },
          autoplay: true,
        ));
  }
}

//这里实现一个轮播图下面的GridView
class MyGridListView extends StatelessWidget {
  final List childItemData;

  //在初始化的时候将数据带过来
  MyGridListView({this.childItemData});

  //顶一个Item的展示的widget
  Widget _itemWidget(BuildContext context, item) {
    return InkWell(
      onTap: () {
        //点击操作

      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  GridView.count(
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 5,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 10.0,
        children: childItemData.map((item) {
          return _itemWidget(context, item);
        }).toList(),

    );
  }
}

//这里我们定义一个店长电话的组件
class LeaderPhone extends StatelessWidget {
  //这里要接收两个参数一个是店长图片的地址，一个是电话号码
  final String leaderImg;
  final String leaderPhoneCode;

  LeaderPhone({Key key, this.leaderImg, this.leaderPhoneCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          //点击拨打电话，或者跳转到网页
          _launchUrl();
        },
        child: Image.network(leaderImg),
      ),
    );
  }

  void _launchUrl() async {
    String url = "tel:" + leaderPhoneCode;
    if (await canLaunch(url)) {
      //判断是不是可以使用
      await launch(url);
    } else {
      throw "Url 不可以使用";
    }
  }
}

//这里我们实现一个首页的推荐列表控件
class RecommendWidget extends StatelessWidget {
  //接收传递的参数
  final List recommendData;

  RecommendWidget(this.recommendData);

  //1.首先实现一个推荐标题
  Widget _recommendTitle() {
    return Container(
      alignment: Alignment.centerLeft, //内部控件的对齐方式,居中靠左
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
      decoration: BoxDecoration(
        //整一个盒子装饰器，来修饰Container包裹的内容
        color: Colors.white,
        border: Border(
            //添加边框
            bottom: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: Text(
        "商品推荐",
        style: TextStyle(
          color: Colors.pink,
        ),
      ),
    );
  }

  //2.实现一个左右可滑动的推荐商品列表，因此实现前我们先实现一个Item
  Widget _listViewItem(BuildContext context,item) {
    return InkWell(
      onTap: (){
        //点击跳转到商品详情页面
        goGoodsDetail(context,item);
      },
        child:Container(
      padding: EdgeInsets.all(8.0),
      width: ScreenUtil().setWidth(250),
      height: ScreenUtil().setHeight(330),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(color: Colors.black12, width: 0.5),
            bottom: BorderSide(color: Colors.black12, width: 0.5),
          )),
      child: Column(
        children: <Widget>[
          Image.network(item['image']),
          Text("￥${item['mallPrice']}"),
          Text(
            "￥${item['price']}",
            style: TextStyle(
                decoration: TextDecoration.lineThrough, color: Colors.grey),
          )
        ],
      ),
    ));
  }

  //3.接下来就是滑动的列表
  Widget _horizontalListView() {
    return Container(
        height: ScreenUtil().setHeight(330),
        child: ListView.builder(
            scrollDirection: Axis.horizontal, //设置水平滚动
            itemCount: recommendData.length,
            itemBuilder: (context, index) {
              return _listViewItem(context,recommendData[index]);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(391),
      margin: EdgeInsets.only(top: 10.0), //距离顶部的间距
      child: Column(
        children: <Widget>[_recommendTitle(), _horizontalListView()],
      ),
    );
  }
}

//接下来我们实现推荐楼层,显示实现楼层的title
class FloorTitle extends StatelessWidget {
  final String titleImag;

  FloorTitle(this.titleImag);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(titleImag),
    );
  }
}

//接下来我们实现推荐楼层,显示实现楼层的内容
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent(this.floorGoodsList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _floorItem(context,floorGoodsList[0]),
              Column(
                children: <Widget>[
                  _floorItem(context,floorGoodsList[1]),
                  _floorItem(context,floorGoodsList[2]),
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[
              _floorItem(context,floorGoodsList[3]),
              _floorItem(context,floorGoodsList[4]),
            ],
          )
        ],
      ),
    );
  }

  //编写每个楼层的item
  Widget _floorItem(BuildContext context,Map goods) {
    return Container(
        width: ScreenUtil().setWidth(375),
        child: InkWell(
          onTap: () {
            //点击跳转
            //点击跳转到商品详情页面
            goGoodsDetail(context,goods);
          },
          child: Image.network(goods['image']),
        ));
  }
}

//接下来实现热推商品的布局展示，这里我们采用流布局wrap()
//1.首先实现热推的title
class HotGoodsTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Colors.black12, width: 0.5))),
      child: Text(
        "火爆专区",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

//2.实现热推商品的内容
class HotGoods extends StatelessWidget {
  final List<Widget> hotGoods;
  HotGoods(this.hotGoods);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 2,
      children: hotGoods,
    );
  }
}

//3.这里实现一下每个热销商品的widget
class HotGoodsItem extends StatelessWidget {
  final Map val;
  HotGoodsItem(this.val);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        //点击跳转到商品详情页面
        goGoodsDetail(context,val);
      },
      child: Container(
      width: ScreenUtil().setWidth(372),
      color: Colors.white,
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.only(bottom: 3.0),
      child: Column(
        children: <Widget>[
          Image.network(
            val['image'],
            fit: BoxFit.fitWidth,
          ),
          Text(
            val['name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
            TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('￥${val['mallPrice']}'),
              Text(
                '￥${val['price']}',
                style: TextStyle(color:Colors.black26,decoration: TextDecoration.lineThrough),
              )
            ],
          )
        ],
      ),
    ),);
  }
}
void goGoodsDetail(BuildContext context,val) {
  //点击跳转到商品详情页面
  var informationString = {
    "id":"${val['goodsId']}",
    "name":"${val['name']}"
  };
  String jsonString = jsonEncode(informationString);
  var jsons = jsonEncode(Utf8Encoder().convert(jsonString));
  ApplicationRouter.router.navigateTo(context,Routers.goodsDetail+"?informationString=$jsons",transition: TransitionType.cupertinoFullScreenDialog,);
}
