import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jingdong_app/config/service_url.dart';
import 'package:jingdong_app/http/http_utils.dart';
import 'package:jingdong_app/model/category_goods_list_model_entity.dart';
import 'package:jingdong_app/model/category_model_entity.dart';
import 'package:jingdong_app/routers/application_router.dart';
import 'package:jingdong_app/routers/routers.dart';
import 'package:provide/provide.dart';
import '../provide/category_provide.dart';
import 'load_more_listview.dart';
import 'dart:convert';

//这里是我们拆分商品分类页面的组件

//1.首先我们拆分的是左侧的商品类别列表页面
class CategoryTypePage extends StatefulWidget {
  final List<CategoryModelData> datas;

  CategoryTypePage(this.datas);

  @override
  _CategoryTypePageState createState() => _CategoryTypePageState();
}

class _CategoryTypePageState extends State<CategoryTypePage>{
  var listIndex = 0; //索引
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black12,width: 0.5))),
      child: ListView.builder(
          itemCount: widget.datas.length,
          itemBuilder: (BuildContext context, int index) {
            return _goodsTypeItem(widget.datas[index], index);
          }),
    );
  }

  //既然左侧是个商品类别的列表，那我们先整一个列表的item
  Widget _goodsTypeItem(CategoryModelData item, int index){
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
        onTap: () {
          setState(() {
            listIndex = index;
          });
          //这里点击的时候就通知相应状态的改变
          Provide.value<CategoryLeftTypeProvide>(context)
              .setCategoryModelDataBxmallsubdtoList(item.bxMallSubDto);
          Provide.value<CategoryLeftTypeProvide>(context).setCurrentIndex(0);
          Provide.value<CategoryLeftTypeProvide>(context).setCategoryId(item.mallCategoryId);
          Provide.value<CategoryLeftTypeProvide>(context).pageIndex = 1;
          getMallGoods(context, "", 1);
        },
        child: Container(
            width: ScreenUtil().setWidth(180),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 18.0),
            decoration: BoxDecoration(
                color: isClick ? Colors.black12 : Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 0.5))),
            child: Text(
              item.mallCategoryName,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: isClick ? Colors.pink : Colors.black),
            )));
  }
}

//2.这里我们实现一个右侧的布局

class CategoryRightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 商品分类页面的右侧布局
    return Container(
      width: ScreenUtil().setWidth(570),
      child: Column(
        children: <Widget>[
          //首先是头部的导航
          CategoryRightPageHeader(),
          CategoryRightPageContent(),
        ],
      ),
    );
  }
}

class CategoryRightPageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12,width: 0.5)),color: Colors.white),
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(570),
        child: Provide<CategoryLeftTypeProvide>(
            builder: (context, child, categoryLeftTypeProvide) {
              try{
                if(categoryLeftTypeProvide.bxmallsubdtoList.length>0){
                  categoryLeftTypeProvide.scroController.jumpTo(0.0);
                }
              }catch(e){
                print("第一次进入页面初始化的时候会产生异常：${e.toString()}");
              }

          return ListView.builder(
              controller: categoryLeftTypeProvide.scroController,
              scrollDirection: Axis.horizontal, //水平滚动
              itemCount: categoryLeftTypeProvide.bxmallsubdtoList.length,
              itemBuilder: (context, index) {
                return _itemWidget(context,
                    categoryLeftTypeProvide.bxmallsubdtoList[index], index);
              });
        }));
  }

  Widget _itemWidget(
      BuildContext context, CategoryModelDataBxmallsubdto item, int index) {
    var isCheck = false;
    isCheck =
        Provide.value<CategoryLeftTypeProvide>(context).currentIndex == index ? true : false;
    return InkWell(
      onTap: () {
        Provide.value<CategoryLeftTypeProvide>(context).setCurrentIndex(index);
        Provide.value<CategoryLeftTypeProvide>(context).setCategorySubId(item.mallSubId);
        Provide.value<CategoryLeftTypeProvide>(context).pageIndex = 1;
        if(item.mallSubId==null){
          getMallGoods(context, "", 1);
        }else{
          getMallGoods(context, item.mallSubId, 1);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isCheck ? Colors.pink : Colors.black),
        ),
      ),
    );
  }
}

//这里实现的是右侧导航下面的内容
class CategoryRightPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      ScrollController scrollController = ScrollController();
    return Expanded(
        child: Container(
      width: ScreenUtil().setWidth(570),
      child: Provide<CategoryLeftTypeProvide>(builder: (context, child, category) {
        if (category.datas.length > 0) {
          try{
            if( Provide.value<CategoryLeftTypeProvide>(context).pageIndex==1){
              scrollController.jumpTo(0.0);
            }
          }catch(e){
            print("第一次进入页面初始化的时候会产生异常：${e.toString()}");
          }
         
          return PullToRefreshListView.separated(
            controller: scrollController,
            separatorView: LineView(height: 0.5),
            itemCount: category.datas.length,
            itemBuilder: (context, index) {
              return _itemWidget(context,category.datas[index]);
            },
            onRefresh: () async {
              //下拉刷新
              Provide.value<CategoryLeftTypeProvide>(context).pageIndex =1;
               getMallGoods(context, category.categorySubId, 1);
            },
            onMoreRefresh: () async {
              //上拉加载更多
              Provide.value<CategoryLeftTypeProvide>(context).pageIndex++;
              getMallGoods(context, category.categorySubId, Provide.value<CategoryLeftTypeProvide>(context).pageIndex);
            },
            hasMore: category.hasMore,
          );
        } else {
          return Center(
            child: Text("暂无数据"),
          );
        }
      }),
    ));
  }

  Widget _itemWidget(BuildContext context,CategoryGoodsListModelData item) {
    return InkWell(
        onTap: () {
          goGoodsDetail(context,item);
        },
        child: Container(
          width: ScreenUtil().setWidth(568),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black12,width: 0.5))
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(190),
                child: Image.network(item.image),
              ),
              Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(5.0),
                      width: ScreenUtil().setWidth(358),
                      child: Text(
                        item.goodsName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      )),
                  Container(
                    width: ScreenUtil().setWidth(358),
                    padding: EdgeInsets.all(5.0),
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '价格:￥${item.presentPrice}',
                          style: TextStyle(
                              color: Colors.pink,
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                        Text(
                          '￥${item.oriPrice}',
                          style: TextStyle(
                              color: Colors.black26,
                              decoration: TextDecoration.lineThrough),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

void getMallGoods(BuildContext context, String categorySubId, int page) {
  var postData = {
    'categoryId': Provide.value<CategoryLeftTypeProvide>(context).categoryId,
    'categorySubId': categorySubId,
    'page': page
  };
  HttpApi.getInstance()
      .postRequest(servicePath['getMallGoods'], postData: postData)
      .then((val) {
    var data = json.decode(val.toString());
    var bean = CategoryGoodsListModelEntity.fromJson(data);
    if(bean.data==null){
      Provide.value<CategoryLeftTypeProvide>(context).hasMore = false;
      Provide.value<CategoryLeftTypeProvide>(context)
          .setCategoryGoodsListModelData([],page);
    }else{
      if(bean.data.length<10){
        Provide.value<CategoryLeftTypeProvide>(context).hasMore = false;
      }else{
        Provide.value<CategoryLeftTypeProvide>(context).hasMore = true;
      }
      Provide.value<CategoryLeftTypeProvide>(context)
          .setCategoryGoodsListModelData(bean.data,page);
    }

  });
}
//跳转到商品详情页面
void goGoodsDetail(BuildContext context,CategoryGoodsListModelData val) {
  //点击跳转到商品详情页面
  var informationString = {
    "id":"${val.goodsId}",
    "name":"${val.goodsName}"
  };
  String jsonString = jsonEncode(informationString);
  var jsons = jsonEncode(Utf8Encoder().convert(jsonString));
  ApplicationRouter.router.navigateTo(context,Routers.goodsDetail+"?informationString=$jsons",transition: TransitionType.cupertinoFullScreenDialog,);
}
