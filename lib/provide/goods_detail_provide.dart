import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jingdong_app/config/service_url.dart';
import 'package:jingdong_app/http/http_utils.dart';
import 'package:jingdong_app/model/goods_detail_info_entity.dart';

//这里是商品详情的provide，这里我们在这里进行数据的获取，以便于进行业务分离

class GoodsDetailProvide with ChangeNotifier {
  //先创建一个变量，便于后面我们通过provide进行获取
  GoodsDetailInfoData goodsDetailInfoData;

  getGoodsDetailInfoData(String id) {
    HttpApi.getInstance().postRequest(servicePath["getGoodDetailById"],
        postData: {"goodId": "$id"}).then((val) {
      var response = jsonDecode(val.toString());
      goodsDetailInfoData = GoodsDetailInfoEntity.fromJson(response).data;
      notifyListeners();
    });
  }

  //这里创建一个变量，来区分用户是点击了详情还是评论
  bool isCheckLeft = true;
  setIsLeft(bool check) {
    isCheckLeft = check;
    notifyListeners();
  }
}
