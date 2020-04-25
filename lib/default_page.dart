import 'package:flutter/material.dart';

//这里定义默认页面，当路由跳转出错的时候跳转这个友好的提示页面

class DefaultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("很高兴见到您"),),
      body: Center(
        child: Text("抱歉未找到您想要的页面，请逛逛其他页面！",style: TextStyle(color: Colors.pink,fontSize: 28),),
      ),
    );
  }
}
