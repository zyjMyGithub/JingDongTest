import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import '../default_page.dart';
import 'handlers.dart';

//这里我们先进行路由的基础配置
class Routers {
  //路由的配置类
  //首先需要配置路径
  static String root = "/"; //根路径
  static String goodsDetail = "/goodsDetail"; //配置的商品详情路径

  //下面定义一个静态的配置处理方法
  static void configureRouters(Router router) {//路由配置
    //1.首先配置一个找不到路由的处理
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        return DefaultPage();//跳转到一个制定页面
      },
    );
    //这里我们需要传递两个值，一个是配置路由的路径，一个是配置跳转路由的Handler
    router.define(goodsDetail, handler: goodsDetailHandler);
  }
}
