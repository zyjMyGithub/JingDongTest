import 'package:flutter/material.dart';
import 'package:jingdong_app/config/service_url.dart';
import 'package:jingdong_app/http/http_utils.dart';
import 'package:jingdong_app/model/category_model_entity.dart';
import 'package:jingdong_app/provide/category_provide.dart';
import 'dart:convert';

import 'package:jingdong_app/widget/widget_category_page.dart';
import 'package:provide/provide.dart';

//这个是分类的页面展示

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<CategoryModelData> datas =[];
  @override
  void initState() {
    HttpApi.getInstance().postRequest(servicePath['categoryContent']).then((val){
        var data=json.decode(val.toString());
      setState(() {
        datas =CategoryModelEntity.fromJson(data).data;
        //这里获取数据后，要将第一个选中的数据回填上去
        Provide.value<CategoryLeftTypeProvide>(context).setCategoryId(datas[0].mallCategoryId);
        Provide.value<CategoryLeftTypeProvide>(context).setCategoryModelDataBxmallsubdtoList(datas[0].bxMallSubDto);
        getMallGoods(context, "", 1);
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("商品分类"),),
      body: Row(
        children: <Widget>[
          CategoryTypePage(datas),
          CategoryRightPage(),
        ],
      ),
    );
  }
}
