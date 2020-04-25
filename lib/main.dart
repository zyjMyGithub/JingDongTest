import 'package:flutter/material.dart';
import 'package:jingdong_app/provide/cart_info_provide.dart';
import 'package:jingdong_app/provide/category_provide.dart';
import 'package:jingdong_app/provide/counter_provide.dart';
import 'package:jingdong_app/provide/goods_detail_provide.dart';
import 'package:jingdong_app/routers/application_router.dart';
import 'package:provide/provide.dart';
import 'package:fluro/fluro.dart';
import 'routers/routers.dart';
import 'index_page.dart';

//这里是我们APP应用的入口
void main(){
  //使用provide这个状态管理操作需要我们在程序的入口处做一些事情
  //1.实例化我们自定义的状态
  var counter = Counter();
  var categoryLeftTypeProvide = CategoryLeftTypeProvide();//
  var goodsDetailProvide = GoodsDetailProvide();//
  var cartInfoProvide = CartInfoProvide();//
  //2.其次是初始换一个providers对象进行操作 provide
  var providers = Providers();
  //3.将需要管理的自定义状态放入providers中,如果有多个依次添加即可
  providers..provide(Provider<Counter>.value(counter));
  //这里添加的就是category页面定义的category
  providers..provide(Provider<CategoryLeftTypeProvide>.value(categoryLeftTypeProvide));
  providers..provide(Provider<GoodsDetailProvide>.value(goodsDetailProvide));
  providers..provide(Provider<CartInfoProvide>.value(cartInfoProvide));
  //4.添加完成之后我们得使用
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //这里我们在build这里初始化fluor
    //------------------------
    final router = Router();
    Routers.configureRouters(router);
    ApplicationRouter.router = router;
    //------------------------
    return MaterialApp(
      title: "这是模拟一个类似京东APP的实例",
      onGenerateRoute: ApplicationRouter.router.generator,//这里不能少
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: IndexPage(),
    );
  }
}
