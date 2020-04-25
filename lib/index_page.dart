import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'pages/home_page.dart';
import 'pages/category_page.dart';
import 'pages/cart_page.dart';
import 'pages/member_page.dart';
import 'package:dio/dio.dart';

//这是我们程序的首页

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  //  1.首先我们需要在下面有四个tab的切换按钮
  //BottomNavigationBarItem
  List<BottomNavigationBarItem> bottomTabItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
    BottomNavigationBarItem(icon: Icon(Icons.search), title: Text("分类")),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart), title: Text("购物车")),
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle), title: Text("个人中心")),
  ];
  List<Widget> pages = List();
  int currentIndex = 0;
  Widget currentPage;

  @override
  void initState() {
    pages
      ..add(HomePage())
      ..add(CategoryPage())
      ..add(CartPage())
      ..add(MemberPage());
    currentIndex = 0;
    currentPage = pages[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //这里我们适配一下这个banner在不同屏幕上的显示，可以使用集成的flutter_screenutil插件
    //首先需要初始化这个插件
    //设置字体大小根据系统的“字体大小”辅助选项来进行缩放,默认为false
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomTabItems,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
            currentPage = pages[index];
          });
        },
      ),
      body: IndexedStack(
        index:currentIndex ,
        children: pages,
      ),
    );
  }
}
