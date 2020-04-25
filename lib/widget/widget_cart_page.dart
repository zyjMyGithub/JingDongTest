import 'package:flutter/material.dart';
import 'package:jingdong_app/model/cart_info_model_entity.dart';
import 'package:jingdong_app/provide/cart_info_provide.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//这进行购物车的布局

class CartGoodsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<CartInfoModelEntity> dataList =
        Provide.value<CartInfoProvide>(context).dataList;
    return FutureBuilder(
      future: _getCartGoodsList(context), //获取数据
      builder: (context, aSnap) {
        if (aSnap.hasData) {
          return Provide<CartInfoProvide>(
            builder: (context, child, val) {
              return Column(
                children: <Widget>[
                  Expanded(
                      flex: 1, //这里是分配布局所占的权重
                      child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            return _goodsCartItem(context,dataList[index]);
                          })),
                  _cartGoodsBottomWidget(context)
                ],
              );
            },
          );
        } else {
          return Center(
            child: Text("加载中...."),
          );
        }
      },
    );
  }

  //这里我们获取缓存的购物车数据
  Future<String> _getCartGoodsList(context) async {
    Provide.value<CartInfoProvide>(context).getCartGoodsInfo();
    return "end";
  }

  //下面是购物车列表的item
  Widget _goodsCartItem(BuildContext context,CartInfoModelEntity item) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          ),
      child: Row(
        children: <Widget>[
          //里面拆分一下几块
          //1.左侧的checkbox
          _cartCheckBt(context,item),
          _cartGoodsImage(item),
          _cartGoodsInfo(item),
          _cartPriceAndDeleteIcon(context,item),
        ],
      ),
    );
  }

  //1.左侧的checkbox
  Widget _cartCheckBt(BuildContext context,CartInfoModelEntity item) {
    return Container(
      child: Checkbox(
          value: item.isCheck,
          activeColor: Colors.pink, //选中时的颜色
          onChanged: (val) {
            //点击操作
            item.isCheck = val;
            Provide.value<CartInfoProvide>(context).selectGoods(item);
          }),
    );
  }

  //右侧的图片
  Widget _cartGoodsImage(CartInfoModelEntity item) {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 0.5)),
      child: Image.network(item.images),
    );
  }

  //接下来是图片右侧的商品信息
  Widget _cartGoodsInfo(CartInfoModelEntity item) {
    return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.only(left: 5.0),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //商品的名称
              Container(
                height: ScreenUtil().setHeight(65),
                child: Text(
                  item.goodsName,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              ),
              //商品数量的加减操作
              AddAndReduceWidget(item)
            ],
          ),
        ));
  }

  //接下来是最右侧的商品价格和删除按钮
  Widget _cartPriceAndDeleteIcon(BuildContext context,CartInfoModelEntity item) {
    return Container(
      margin: EdgeInsets.only(left: 8.0),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Text('￥${item.price}',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(28),
                  )),
          InkWell(
            onTap: () {
              //点击删除商品
              Provide.value<CartInfoProvide>(context).removeGoodsById(item);
            },
            child: Container(
              margin: EdgeInsets.only(top: 5.0),
              child:Icon(
              Icons.delete_outline,
              color: Colors.black12,
              size: 30,
            ),
          ))
        ],
      ),
    );
  }

  //制作底部结算栏
  Widget _cartGoodsBottomWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      child: Row(
        children: <Widget>[
          _selectAllBtn(context),
          _allPriceArea(context),
          _goButton(context)
        ],
      ),
    );
  }

//全选按钮
  Widget _selectAllBtn(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: Provide.value<CartInfoProvide>(context).isSelectAll,
            activeColor: Colors.pink,
            onChanged: (bool val) {
              Provide.value<CartInfoProvide>(context).isSelectAll = val;
              Provide.value<CartInfoProvide>(context).selectAllGoods();
            },
          ),
          Text('全选')
        ],
      ),
    );
  }

  // 合计区域
  Widget _allPriceArea(BuildContext context){
    return Expanded(
      flex: 1,
        child:Container(
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                    '合计:',
                    style:TextStyle(
                        fontSize: ScreenUtil().setSp(36)
                    )
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${Provide.value<CartInfoProvide>(context).allPrice}',
                    style:TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: Colors.red,
                    )
                ),

              )
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              '满10元免配送费，预购免配送费',
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: ScreenUtil().setSp(22)
              ),
            ),
          )
        ],
      ),
    ));
  }

  //结算按钮
  Widget _goButton(BuildContext context){
    return Container(
      width: ScreenUtil().setWidth(160),
      padding: EdgeInsets.only(left: 10),
      child:InkWell(
        onTap: (){},
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(3.0)
          ),
          child: Text(
            '结算(${Provide.value<CartInfoProvide>(context).allCount})',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ) ,
    );
  }
}

//这个是自定义个商品加减操作的widget
class AddAndReduceWidget extends StatelessWidget {
  final CartInfoModelEntity item;
  AddAndReduceWidget(this.item);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(165),
      margin: EdgeInsets.only(top: 10.0),//操作按钮距离顶部的距离
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12,width: 0.5)
      ),
      child: Row(
        children: <Widget>[
          //减按钮
          _reduceBtn(context,item),
          //数值显示
          _countArea(context,item),
          //加法操作
          _addBtn(context,item)
        ],
      ),
    );
  }
  // 减少按钮
  Widget _reduceBtn(BuildContext context,CartInfoModelEntity item){
    return InkWell(
      onTap: (){
      Provide.value<CartInfoProvide>(context).reduceOrAddGoods(item, "reduce");
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,

        decoration: BoxDecoration(
            color: Colors.white,
            border:Border(
                right:BorderSide(width:0.5,color:Colors.black12)
            )
        ),
        child: Text('-'),
      ),
    );
  }

  //中间数量显示区域
  Widget _countArea(BuildContext context,CartInfoModelEntity item){
    return Container(
      width: ScreenUtil().setWidth(70),
      height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text("${item.count}"),
    );
  }
  // 增加按钮
  Widget _addBtn(BuildContext context,CartInfoModelEntity item){
    return InkWell(
      onTap: (){
        Provide.value<CartInfoProvide>(context).reduceOrAddGoods(item, "add");
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border:Border(
                left:BorderSide(width:0.5,color:Colors.black12)
            )
        ),
        child: Text('+'),
      ),
    );
  }
}

