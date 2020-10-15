import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flumould/theme/model/theme_model.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

/**
 * 修改主题色有两种方案 1.  一种方案直接在themeData中定义主题色，然后通过修改MaterialApp的themeData来修改主题色
 * 2. 一种是自定义themeData，结合bloc框架
 *
 * 方案1一次只需配置一次主题，修改后立即生效 ，缺点是灵活度不高
 * 方案2 可以随意定义各种主题，但是使用的时候需要显示调用，比较麻烦，
 */
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeModel themeModel;

  ThemeBloc(this.themeModel) : super(ThemeState(themeModel));


  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if(event is ChangeThemeEvent){
      yield ThemeState(ThemeModel.mapStringToThmemeModel(event.themeIndex));
    }
  }
}
