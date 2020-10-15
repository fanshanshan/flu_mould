import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flumould/app/app_repository.dart';
import 'package:flumould/common/common_service.dart';
import 'package:flumould/models/app_user.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppRepository _appRepository;
  AppBloc(this._appRepository) : super(AppInitial());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    // TODO: implement mapEventToState

    if (event is InitEvent) {
      yield AppInitial();
      await Future.delayed(Duration(seconds: 1));//这里模拟加载一秒钟  目的为了演示bloc的状态管理
      App_user app_user = await _appRepository.getUser();
      yield AppInitSuc(app_user);
    }
  }
}
