import 'dart:io';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PercentDialog extends StatefulWidget {
  String text;
  double max;
  double progress;
  bool isLoading;
  LoadingDialogState loadingDialogState = new LoadingDialogState();
  PercentDialog({Key key, this.text, this.max: 1, this.progress: 0,this.isLoading:true})
      : super(key: key);

  update(double progress){

    this.progress = progress;
    loadingDialogState.update();
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return loadingDialogState;
  }
}

class LoadingDialogState extends State<PercentDialog> {
  update(){
    setState(() {

    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(body: new Center(
      //保证控件居中效果
      child: new SizedBox(
        width: 120.0,
        height: 120.0,
        child: new Container(
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: Color(0xbf000000),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child:  Container(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        strokeWidth: 2,
                        value:widget.progress/widget.max,
                      ),
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child:Text(
                        "${((widget.progress / widget.max * 100).toStringAsFixed(0))}%",
                        style:
                        TextStyle(color: Colors.white, fontSize: 8),
                      ),
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                    ),
                  )
                ],
              ),
              widget.text == null
                  ? null
                  : new Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: new Text(
                  widget.text,
                  style: new TextStyle(
                      fontSize: 12.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ),backgroundColor: Colors.transparent,);
  }
}
