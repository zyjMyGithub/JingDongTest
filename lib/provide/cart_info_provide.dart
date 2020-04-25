import 'package:flutter/material.dart';
import 'package:jingdong_app/model/cart_info_model_entity.dart';
import 'package:jingdong_app/utils/contents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//这里是购物车的相关操作逻辑

class CartInfoProvide with ChangeNotifier {
  List<CartInfoModelEntity> dataList = [];
  String cartString = "[]";
  bool isSelectAll = true;
  double allPrice = 0.0;
  int allCount = 0;

  saveCartGoodsInfo(goodsId, goodsName, count, price, images) async {
    //1.得到sharepreference的实例
    //这里和Android的sharePreference的操作类似
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString(Contents.cartInfoKey);
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    //获得存储的数据后再存入之前我们先判断添加的商品是不是已经存在，如果存在的话就是将count++如果不存在就添加一个商品
    //声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false; //默认为没有
    for (int i = 0; i < tempList.length; i++) {
      if (goodsId == tempList[i]["goodsId"]) {
        tempList[i]['count'] = tempList[i]['count'] + 1;
        isHave = true;
        break;
      }
    }
    if (!isHave) {
      //说明没有添加过相关商品
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isCheck': true,
      };
      tempList.add(newGoods);
    }
    tempList.forEach((item) {
      dataList.add(CartInfoModelEntity.fromJson(item));
    });
    //把字符串进行encode操作，
    cartString = json.encode(tempList).toString();
    print(cartString);
    print(dataList.toString());
    await prefs.setString(Contents.cartInfoKey, cartString); //进行持久化
    await getCartGoodsInfo();
  }

  //获取购物车数据
  getCartGoodsInfo() async {
    dataList.clear();
    allPrice = 0;
    allCount =0;
    isSelectAll =true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString(Contents.cartInfoKey);
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    tempList.forEach((item) {
      if(item['isCheck']==false){
        isSelectAll = false;
      }else{
        allPrice+=item['count']*item['price'];
        allCount+=item['count'];
      }
      dataList.add(CartInfoModelEntity.fromJson(item));
    });
    notifyListeners();
  }

  //清空购物车数据
  clearCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Contents.cartInfoKey);
    await getCartGoodsInfo();
  }

  //删除购物车对应的商品
  removeGoodsById(CartInfoModelEntity item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (dataList.length == 0) {
      await getCartGoodsInfo();
    }
    dataList.remove(item);
    cartString = jsonEncode(dataList).toString();
    await prefs.setString(Contents.cartInfoKey, cartString);
    await getCartGoodsInfo();
  }

  //勾选商品的操作
  selectGoods(CartInfoModelEntity item)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (dataList.length == 0) {
      await getCartGoodsInfo();
    }
//    dataList[dataList.indexOf(item)].isCheck = item.isCheck;
    cartString = jsonEncode(dataList).toString();
    await prefs.setString(Contents.cartInfoKey, cartString);
    await getCartGoodsInfo();
  }
  //全选商品的操作
  selectAllGoods()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (dataList.length == 0) {
      await getCartGoodsInfo();
    }
    dataList.forEach((item){
      item.isCheck = isSelectAll;
    });
    cartString = jsonEncode(dataList).toString();
    await prefs.setString(Contents.cartInfoKey, cartString);
    await getCartGoodsInfo();
  }
  //点击加减商品操作
  reduceOrAddGoods(CartInfoModelEntity item,String tag)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (dataList.length == 0) {
      await getCartGoodsInfo();
    }
    if(tag =="add"){
      item.count++;
    }else if(tag =="reduce"){
      if(item.count>1){
        item.count--;
      }
    }
    cartString = jsonEncode(dataList).toString();
    await prefs.setString(Contents.cartInfoKey, cartString);
    await getCartGoodsInfo();
  }
}
