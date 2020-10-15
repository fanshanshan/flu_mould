import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'list_repository.dart';

class Listview extends StatefulWidget {
  @override
  _ListviewState createState() => _ListviewState();
}

class _ListviewState extends State<Listview> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  List data;
  ListRepository listRepository = ListRepository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = listRepository.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SmartRefresher(
        enablePullUp: true,
        enablePullDown: true,
        onLoading: () async {
          await listRepository.loadmore();
          refreshController.loadComplete();
          setState(() {});
        },
        onRefresh: () {
          data = listRepository.getData();
          setState(() {});
        },
        controller: refreshController,
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${index}"),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 2,
              );
            },
            itemCount: data.length),
      ),
    );
  }
}
