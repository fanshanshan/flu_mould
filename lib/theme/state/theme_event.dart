part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}


class ChangeThemeEvent extends ThemeEvent{
  int themeIndex;

  ChangeThemeEvent(this.themeIndex);
}
