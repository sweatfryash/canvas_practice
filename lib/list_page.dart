import 'package:canvas_practice/windmill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'circle_progress.dart';


class MyPage {

  MyPage(this.title, this.widget);

  String title;
  Widget widget;

}

class ListPage extends StatelessWidget {
  
  final List<MyPage> pages =<MyPage>[
    MyPage('圆环（可以不封闭）进度表示', CircleProgressPage()),
    MyPage('风车', WindmillPage()),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canvas练习'),
      ),
      body: ListView.separated(
        itemCount: pages.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(pages[index].title),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (BuildContext c) => pages[index].widget));
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}
