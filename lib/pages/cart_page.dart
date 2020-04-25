import 'package:flutter/material.dart';
import 'package:jingdong_app/widget/widget_cart_page.dart';

//这个是购物车的页面

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("购物车"),),
      body: CartGoodsList(),
    );
  }
}
