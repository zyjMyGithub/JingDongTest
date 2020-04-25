import 'package:flutter/material.dart';

//这里我们实现一个计数器状态的管理
class Counter with ChangeNotifier{//ChangeNotifier 不需要管理听众

  //这里我们实现一个业务功能就是将一个值++
  int value = 0;
  increment(){
    value++;//将value的值++
    //做完上述操作后我们要通知需要改变状态的地方
    notifyListeners();
  }
}