import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jingdong_app/model/goods_detail_info_entity.dart';
import 'package:jingdong_app/provide/cart_info_provide.dart';
import 'package:jingdong_app/provide/goods_detail_provide.dart';
import 'package:provide/provide.dart';
import 'package:fluttertoast/fluttertoast.dart';

//这里是详情页面的布局组件

class GoodsDetailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<GoodsDetailProvide>(
      builder: (context, child, goodsDetailProvide) {
        if (goodsDetailProvide.goodsDetailInfoData != null) {
          var goodsInfo = goodsDetailProvide.goodsDetailInfoData.goodInfo;
          var goodsDetail =
              goodsDetailProvide.goodsDetailInfoData.goodInfo.goodsDetail;
          return Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: ListView(
                    children: <Widget>[
                      _topImage(goodsInfo.image1),
                      _goodsNameAndPrice(
                          goodsInfo.goodsName,
                          goodsInfo.goodsSerialNumber,
                          goodsInfo.presentPrice,
                          goodsInfo.oriPrice),
                      _detailsExplain(),
                      GoodsDetailTabBar(),
                      _detailWebView(context, goodsDetail),
                    ],
                  )),
              _detailBottomWidget(context, goodsInfo)
            ],
          );
        } else {
          return Center(
            child: Text('加载中........'),
          );
        }
      },
    );
  }

  //1.顶部的商品展示图
  Widget _topImage(String url) {
    return Container(
      alignment: Alignment.center,
      child: Image.network(
        url,
        width: ScreenUtil().setWidth(740),
      ),
    );
  }

  //2.商品展示图下面的商品名称和价格
  Widget _goodsNameAndPrice(name, num, presentPrice, oriPrice) {
    return Container(
      color: Colors.white,
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            maxLines: 1,
            style: TextStyle(fontSize: ScreenUtil().setSp(30)),
          ),
          Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Text('编号:$num', style: TextStyle(color: Colors.black26))),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Text(
                  '￥$presentPrice',
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: ScreenUtil().setSp(40),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    '市场价:￥$oriPrice',
                    style: TextStyle(
                        color: Colors.black38,
                        decoration: TextDecoration.lineThrough),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //3.商品说明组件
  Widget _detailsExplain() {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        width: ScreenUtil().setWidth(750),
        padding: EdgeInsets.all(10.0),
        child: Text(
          '说明：> 急速送达 > 正品保证',
          style: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(30)),
        ));
  }

  //添加一个webview
  Widget _detailWebView(BuildContext context, goodsDetail) {
    if (Provide.value<GoodsDetailProvide>(context).isCheckLeft) {
      return goodsDetail != ""
          ? Container(
              child: Html(
                data: goodsDetail,
              ),
            )
          : Container(
              width: ScreenUtil().setWidth(750),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text('暂时没有数据'));
    } else {
      return Container(
          width: ScreenUtil().setWidth(750),
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Text('暂时没有数据'));
    }
  }

  //添加一个购物车相关操作底栏
  Widget _detailBottomWidget(
      BuildContext context, GoodsDetailInfoDataGoodinfo goodsInfo) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(80),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  //点击跳转到购物车
                },
                child: Container(
                  width: ScreenUtil().setWidth(110),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 25,
                    color: Colors.red,
                  ),
                ),
              ),
              Provide<CartInfoProvide>(
                builder: (context, child, val) {
                  int goodsCount =
                      Provide.value<CartInfoProvide>(context).allCount;
                  return Positioned(
                    top: 0,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Text(
                        '$goodsCount',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(22)),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          InkWell(
            onTap: () {
              _addGoodsToCart(context, goodsInfo);
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              color: Colors.green,
              child: Text(
                '加入购物车',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              //点击立即购买，此处我们可以先模仿一下清空购物车操作
              _clearCart(context);
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              color: Colors.red,
              child: Text(
                '马上购买',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//4.商品详情和评论的切换
class GoodsDetailTabBar extends StatefulWidget {
  @override
  _GoodsDetailTabBarState createState() => _GoodsDetailTabBarState();
}

class _GoodsDetailTabBarState extends State<GoodsDetailTabBar>
    with SingleTickerProviderStateMixin {
  List<Widget> tabs = [
    Tab(
      text: "详情",
    ),
    Tab(
      text: "评论",
    ),
  ];
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10.0),
      child: TabBar(
          controller: _tabController,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          onTap: (index) {
            if (index == 0) {
              Provide.value<GoodsDetailProvide>(context).setIsLeft(true);
            } else {
              Provide.value<GoodsDetailProvide>(context).setIsLeft(false);
            }
          },
          tabs: tabs),
    );
  }
}

//添加购物车操作
void _addGoodsToCart(
    BuildContext context, GoodsDetailInfoDataGoodinfo goodsInfo) {
  Provide.value<CartInfoProvide>(context).saveCartGoodsInfo(goodsInfo.goodsId,
      goodsInfo.goodsName, 1, goodsInfo.presentPrice, goodsInfo.image1);
  Fluttertoast.showToast(
      msg: "添加成功",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.pink,
      textColor: Colors.white,
      fontSize: 16.0);
}

//清空购物车操作
void _clearCart(BuildContext context) {
  Provide.value<CartInfoProvide>(context).clearCartInfo();
  Fluttertoast.showToast(
      msg: "清空成功",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.pink,
      textColor: Colors.white,
      fontSize: 16.0);
}
