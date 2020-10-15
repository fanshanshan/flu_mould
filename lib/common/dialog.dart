import 'package:flumould/common/percent_dialog.dart';
import 'package:flumould/common/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom_loading_dialog.dart';

typedef _toast = Function(
    {dynamic message, int duration, bool mask, Widget icon, Function onClose});

//const String fontFamily = 'iconfont';
//const String fontPackage = 'weui';
class DialogUtil {
  //static const IconData info = IconData(0xe6d0, fontFamily: fontFamily, fontPackage: fontPackage);

  static DialogUtil instance;
  static DialogUtil getInstacnce() {
    if (instance == null) {
      instance = new DialogUtil();
    }
    return instance;
  }

  static void showShortToastAlignCenter(String text,
      {bgColor: Colors.black, txColor: Colors.white}) async {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: bgColor,
        textColor: txColor,
        fontSize: 16.0);
  }

  static void showShortToastAlignTop(String text) async {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showShortToastAlignBottom(String text,
      {bgColor: Colors.black, txColor: Colors.white}) async {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: bgColor,
        textColor: txColor,
        fontSize: 16.0);
  }

  static LoadingDialog loadingDialog;
  static void showProgressDialog(BuildContext context, String text,
      {bool autoDiss: true}) {
    if (loadingDialog == null) {
      loadingDialog = new LoadingDialog(
        //调用对话框
        text: text,
        autoDiss: autoDiss,
      );
    }
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          loadingDialog.isLoading = true;
          loadingDialog.text = text;
          loadingDialog.autoDiss = autoDiss;
          return loadingDialog;
        });
  }

  static void closeProgressDialog(BuildContext context) {
    if (loadingDialog == null) {
      return;
    }
    if (loadingDialog.isLoading) {
      Navigator.of(context).pop();
      loadingDialog.isLoading = false;
    }
  }

  static showSuccessToast(BuildContext context,
      {String text:"操作成功", Duration duration}) {
    OverlayEntry overlayEntry = createOverlayEntry(
        context: context,
        child: ToastWidget(
          message: Text(text),
          icon: Icon(
            Icons.done,
            color: Colors.white,
            size: 50,
          ),
        ));
    Future.delayed(duration ?? Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }
  // 提示

  static shoFailToast(BuildContext context,
      {String text: "操作失败", Duration duration}) {
    OverlayEntry overlayEntry = createOverlayEntry(
        context: context,
        child: ToastWidget(
          message: Text(text),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 50,
          ),
        ));
    Future.delayed(duration ?? Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }

// 创建OverlayEntry
  static OverlayEntry createOverlayEntry(
      {@required BuildContext context,
      @required Widget child,
      bool backIntercept = false,
      Function willPopCallback}) {
    final overlayState = Overlay.of(context);
    ModalRoute _route;

    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return DefaultTextStyle(
          style: Theme.of(context).textTheme.body1, child: child);
    });
    overlayState.insert(overlayEntry);

    // 返回关闭
    Future<bool> backClose() {
      willPopCallback();
      return Future.value(false);
    }

    void close() {
      overlayEntry.remove();
      _route?.removeScopedWillPopCallback(backClose);
    }

    // 返回键拦截
    if (willPopCallback != null) {
      _route = ModalRoute.of(context);

      // back监听
      _route.addScopedWillPopCallback(backClose);
    }

    return overlayEntry;
  }

  void showPercentDialog<T>(
      BuildContext context, String text, double max, double progress) {
    if (percentDialog != null && percentDialog.isLoading) {
      return;
    }
    percentDialog = new PercentDialog(
      //调用对话框
      text: text,
      max: max,
      progress: progress,
    );
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SafeArea(
          child: Builder(builder: (BuildContext context) {
            return percentDialog;
          }),
        );
      },
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Color(0x40000000), // 自定义遮罩颜色
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }

  PercentDialog percentDialog;
  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // 使用缩放动画
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  void closePercentDialog(BuildContext context) {
    if (percentDialog == null) {
      return;
    }
    if (percentDialog.isLoading) {
      Navigator.of(context).pop();
      percentDialog = null;
    }
  }

  void updatepercentDialog(BuildContext context, double progress) {
    if (percentDialog == null) {
      return;
    }
    percentDialog.progress = progress;
    percentDialog.update(progress);
  }
}
