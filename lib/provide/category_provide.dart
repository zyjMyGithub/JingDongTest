import 'package:flutter/material.dart';
import 'package:jingdong_app/model/category_goods_list_model_entity.dart';
import '../model/category_model_entity.dart';

//这里做的都是category的状态管理

//因为我们在点击左侧的菜单栏时需要联动的更新右侧上边的类别导航，而这两个是独立的widget
class CategoryLeftTypeProvide with ChangeNotifier{

  //这里我们需要提供一个方法，来获取当前点击类别得到的列表
  List<CategoryModelDataBxmallsubdto> bxmallsubdtoList = [];
  setCategoryModelDataBxmallsubdtoList( List<CategoryModelDataBxmallsubdto> dataLsit){
    var bxmallsubdto = CategoryModelDataBxmallsubdto();
    bxmallsubdto.mallCategoryId = "";
    bxmallsubdto.mallSubId = "";
    bxmallsubdto.mallSubName = "全部";
    bxmallsubdto.comments = "";
    bxmallsubdtoList.clear();
    bxmallsubdtoList.add(bxmallsubdto);
    bxmallsubdtoList.addAll(dataLsit);
    notifyListeners();
  }

  //这里我们需要更新右侧头部的切换效果，所以我们先记录一下当前选择的index
  int currentIndex = 0;
  setCurrentIndex(int index){
    currentIndex = index;
    notifyListeners();
  }
  //这里需要记录一下左侧选择类别的id
   String categoryId = "";
   setCategoryId(String id ){
     categoryId = id;
     notifyListeners();
   }
   String categorySubId = "";
   setCategorySubId(String id){
     categorySubId = id;
     notifyListeners();
   }
  ScrollController scroController = ScrollController();
   //这里定义一个是否还有更多数据的标识
   bool hasMore = false;
   //这里定义一个标识来标注当前列表是第几页
   int pageIndex = 1;
   //这里我们提供一个方法，点击获取对应类别商品的列表数据
  List<CategoryGoodsListModelData> datas = [];
  setCategoryGoodsListModelData( List<CategoryGoodsListModelData> data,int page){
    if(page==1){
      datas.clear();
    }
    datas.addAll(data);
    notifyListeners();
  }
}