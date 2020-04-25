import 'package:flutter/material.dart';
import 'package:jingdong_app/config/service_url.dart';
import 'package:jingdong_app/http/http_utils.dart';
import 'dart:convert';//这里是json进行编解码操作
import '../widget/widget_home_page.dart';

//这里是首页的展示

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;//保持页面的状态

  String homePageContent = "正在请求数据。。。";
  List<Map> hotGoodsList=[];
  int page = 1;
  @override
  void initState() {
//    请求数据首页热推商品的数据
    HttpApi.getInstance().postRequest(servicePath['homePageBelowConten'],postData:{'page':1}).then((val){
      print(val.toString());
      var data=json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List ).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("百姓生活+"),
    ),
      body:SingleChildScrollView(
        child:FutureBuilder(//这里widget是直接给我提供一个异步请求后返回数据显示的操作，所以就不需要上面在init里面获取数据了
//        future: getHomePageContent(),
        future: HttpApi.getInstance().postRequest(servicePath['homePageContent'], postData:{'lon':'115.02932','lat':'35.76189'}),
        builder: (context,snapshot){
          if(snapshot.hasData){//判断是否有数据
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDatas = (data['data']['slides'] as List).cast();
            List<Map> navigatorDatas = (data['data']['category'] as List).cast();
            String bannerImgUrl = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImgUrl = data['data']['shopInfo']['leaderImage'];
            String leaderPhoneCode = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommendData = (data['data']['recommend'] as List).cast();
            String floor1Title =data['data']['floor1Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
            String floor2Title =data['data']['floor2Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
            String floor3Title =data['data']['floor3Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
            List<Map> floor1 = (data['data']['floor1'] as List).cast(); //楼层1商品和图片
            List<Map> floor2 = (data['data']['floor2'] as List).cast(); //楼层1商品和图片
            List<Map> floor3 = (data['data']['floor3'] as List).cast(); //楼层1商品和图片
            return Column(
              children: <Widget>[
                MySwiperWidget(datas: swiperDatas,),
                MyGridListView(childItemData: navigatorDatas,),
                Image.network(bannerImgUrl),
                LeaderPhone(leaderImg: leaderImgUrl,leaderPhoneCode: leaderPhoneCode,),
                RecommendWidget(recommendData),
                FloorTitle(floor1Title),
                FloorContent(floor1),
                FloorTitle(floor2Title),
                FloorContent(floor2),
                FloorTitle(floor3Title),
                FloorContent(floor3),
                HotGoodsTitle(),
                hotGoodsList.length>0?HotGoods(hotGoodsList.map((item){
                  return HotGoodsItem(item);
                }).toList()):Text(' '),
              ],
            );
          }else{
            return Text(homePageContent);
          }
        }
    )));
  }

}




