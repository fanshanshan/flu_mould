import 'dart:io';

import 'package:flutter/material.dart';


// ignore: must_be_immutable
class LoadingDialog extends StatefulWidget {
  String text;
  bool isLoading;
  bool autoDiss;
  LoadingDialog({Key key, this.text,this.isLoading:false,this.autoDiss:true}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoadingDialogState();
  }
}

class LoadingDialogState extends State<LoadingDialog> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(child: new Material(
      //创建透明层
        type: MaterialType.transparency, //透明类型
        child: Stack(
          children: <Widget>[
            GestureDetector(onTap: () {
                if (widget.isLoading&&widget.autoDiss) {
                  Navigator.of(context).pop();
                  widget.isLoading = false;
                }

            }),
            new Center(
              //保证控件居中效果
              child: new SizedBox(
                width: 120.0,
                height: 120.0,
                child: new Container(
                  padding: EdgeInsets.only(left: 4,right: 4),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(17, 17, 17, 0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    CircularProgressIndicator(),
                    widget.text==null?null:  new Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: new Text(
                        widget.text,
                        style: new TextStyle(
                            fontSize: 12.0, color: Colors.white),
                      ),
                    ),
                  ],),
                ),
              ),
            ),
          ],
        )), onWillPop: (){
      if(widget.autoDiss){
        Navigator.of(context).pop();
      }
    });
  }
}
