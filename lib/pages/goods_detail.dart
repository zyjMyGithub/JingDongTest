import 'package:flutter/material.dart';
import 'package:jingdong_app/provide/goods_detail_provide.dart';
import 'package:jingdong_app/widget/widget_goods_detail.dart';
import 'package:provide/provide.dart';

//这里是商品的详情页面
 class GoodsDetailPage extends StatelessWidget {
   final String id;
   final String name;
   GoodsDetailPage(this.id,this.name);
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text("商品详情页面"),),
       body:FutureBuilder(
           future: _getDetailData(context,id),
           builder: (context,snapshot){
             if(snapshot.hasData){
               return GoodsDetailWidget();
             }else{
               return Center(child: Text('加载中........'),);
             }
           }
       ),
     );
   }

   Future<String> _getDetailData(context,String id)async{
     Provide.value<GoodsDetailProvide>(context).getGoodsDetailInfoData(id);
     return "end";
   }
 }
 