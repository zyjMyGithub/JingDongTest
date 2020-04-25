import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


typedef PullRefreshCallback = Future<void> Function();


///@describe 自定义ListView（下拉刷新，上拉加载更多）
///
///@author mi
///
///@time 2019/10/28
class PullToRefreshListView extends StatefulWidget {
  //滚动控制器
  ScrollController controller;

  //item回调方法
  IndexedWidgetBuilder itemBuilder;

  //条目数
  int itemCount;

  //分割线
  Widget separatorView =  LineView(height: 4);

  //刷新回调
  PullRefreshCallback onRefresh;

  //加载更多回调
  PullRefreshCallback onMoreRefresh;

  //是否有下一页
  bool hasMore = true;

  PullToRefreshListView(
      {@required this.controller,@required this.itemBuilder,@required this.itemCount,this.onRefresh,this.onMoreRefresh,this.hasMore});

  PullToRefreshListView.separated(
      {@required this.controller,@required this.itemBuilder,
        @required this.itemCount,this.separatorView,this.onRefresh,this.onMoreRefresh,this.hasMore});


  @override
  State<StatefulWidget> createState() {
    return ListViewState();
  }

}

class ListViewState extends State<PullToRefreshListView>{

  @override
  void initState() {
    super.initState();
    if(widget.controller==null){
      widget.controller = ScrollController();
    }
    widget.controller.addListener(() {
      if (widget.controller.position.pixels == widget.controller.position.maxScrollExtent) {
        if(widget.hasMore)
          widget.onMoreRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.separated(
          controller: widget.controller,
          itemBuilder: (context, index) {
            if (index == widget.itemCount) {
              return widget.hasMore ? LoadMoreView():NoMoreView();
            } else {
              return widget.itemBuilder(context, index);
            }
          },
          separatorBuilder: (context, index) {
            return widget.separatorView;
          },
          itemCount: widget.itemCount+1),
    );
  }
}

class LoadMoreView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Center(child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 20,height: 20,child: CircularProgressIndicator(strokeWidth: 2)),
          Padding(padding: EdgeInsets.all(10),child: Text("加载中",style: TextStyle(color: Colors.grey,fontSize: 13)))
        ]));
  }

}

class NoMoreView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(
        child: Padding(padding: EdgeInsets.all(2),
            child: Text("到底啦！",style: TextStyle(color: Colors.grey,fontSize: 13)))));
  }

}


///@describe LineView
///
///@author mi
///
///@time 2019/9/10
class LineView extends StatelessWidget{

  double height;
  LineView({this.height = 10});

  @override
  Widget build(BuildContext context) {
    return  Container(color: Colors.grey[200],height: height);
  }

}
