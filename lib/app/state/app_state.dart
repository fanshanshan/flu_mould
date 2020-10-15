part of 'app_bloc.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {

}

class AppInitSuc extends AppState{
  App_user app_user;

  AppInitSuc( this.app_user);
}

class AppInitFail extends AppState{
  String msg;
}
