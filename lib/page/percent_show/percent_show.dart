import 'dart:async';

import 'package:flumould/common/dialog.dart';
import 'package:flutter/material.dart';

class PercentShow extends StatefulWidget {
  @override
  _PercentShowState createState() => _PercentShowState();
}

class _PercentShowState extends State<PercentShow> {
  double index = 0;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        DialogUtil.getInstacnce().showPercentDialog(context, "正在上传", 100, 0);
        start();
      },
      child: Text("上传进度条"),
    );
  }
  Timer timer;
  void start(){
    timer =  Timer.periodic(Duration(milliseconds: 100),(e){
      index++;
      DialogUtil.getInstacnce().updatepercentDialog(context, index);
      if(index==100){
        timer.cancel();
        DialogUtil.getInstacnce().closePercentDialog(context);
        DialogUtil.showSuccessToast(context,text: "上传成功");
      }
    });
  }
}
