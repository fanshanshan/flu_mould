import 'dart:convert';

import 'package:flumould/api/HttpUtils.dart';
import 'package:flumould/app/app_config.dart';
import 'package:flumould/common/common_service.dart';
import 'package:flumould/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRepository {
  static SharedPreferences _prefs;
  static AppRepository _appRepository;

  static AppRepository _getInstance(){
    if(_appRepository==null){
      _appRepository = AppRepository();
    }
    return _appRepository;
  }




  Future<Config> getAppConfig() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    var _profile = _prefs.getString(AppConfig.configCacheKey);
    if (_profile != null) {
      try {
        Config config = Config.fromJson(jsonDecode(_profile));
        return config;
      } catch (e) {
        return getDefaultConfig();
      }
    } else {
     return getDefaultConfig();
    }
  }


  Future<App_user> getUser() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    var _profile = _prefs.getString(AppConfig.userCacheKey);
    if (_profile != null) {
      try {
        App_user config = App_user.fromJson(jsonDecode(_profile));
        return config;
      } catch (e) {
        return getDefaultUser();
      }
    } else {
      return getDefaultUser();
    }
  }


  //网络请求  登陆
  Future<String> login()async{
    String result = await HttpUtils.sharedInstance().request("login");
    return result;
  }


  Future<String> logout(){

  }


  App_user getDefaultUser(){
    return App_user()..name="你好"..headimg=""..sex="男";
  }

  Config getDefaultConfig(){
    return Config()
      ..theme = 1
      ..lauguage = 1;
  }

  Future<bool> saveConfigs(Config config)async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
   return await _prefs.setString(AppConfig.configCacheKey, jsonEncode(config.toJson()));
  }



  Future<bool> saveUsers(App_user app_user)async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return await _prefs.setString(AppConfig.userCacheKey, jsonEncode(app_user.toJson()));
  }


  Future<bool> clearConfig()async{

   return await saveConfigs(Config());
  }


  Future<bool> clearUser()async{

    return await saveUsers(App_user());
  }
}
