import 'package:flumould/app/app_repository.dart';
import 'package:flumould/app/page/home_page.dart';
import 'package:flumould/app/state/app_bloc.dart';
import 'package:flumould/page/listview/listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoute {
  final appBloc;

  AppRoute(this.appBloc);

  Route onGenerateRoute(RouteSettings settings) {
    //在这里可以做一些拦截操作  比如未登录时跳转到登录页面
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
        break;
        case "listview":
        return MaterialPageRoute(
          builder: (_) => Listview(),
        );
        break;
    }
  }

}
