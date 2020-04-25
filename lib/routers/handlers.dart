import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:jingdong_app/pages/goods_detail.dart';
import 'dart:convert';


//这个文件都是我们定义跳转的handler

Handler goodsDetailHandler = Handler(
  handlerFunc: (BuildContext context,Map<String,List<String>> params){
    var informationString =params['informationString'].first;
    var list = List<int>();
    ///字符串解码
    jsonDecode(informationString).forEach(list.add);
    final String value = Utf8Decoder().convert(list);
    var mapValue = json.decode(value);
    var id =mapValue['id'];
    var name =mapValue['name'];
    return GoodsDetailPage(id,name);
  },
);