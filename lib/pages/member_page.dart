import 'package:flutter/material.dart';
import 'package:jingdong_app/provide/counter_provide.dart';
import 'package:provide/provide.dart';

//这个是我的个人中心的页面

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      //这里我们也获取一下counter状态的值，看看是不是在应用中保持一致
      child: Provide<Counter>(
        builder: (context,child,counter){
          return Text("${counter.value}",style: Theme.of(context).textTheme.display1,);
        },
      ),
    );
  }
}
