// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

App_user _$App_userFromJson(Map<String, dynamic> json) {
  return App_user()
    ..name = json['name'] as String
    ..headimg = json['headimg'] as String
    ..sex = json['sex'] as String;
}

Map<String, dynamic> _$App_userToJson(App_user instance) => <String, dynamic>{
      'name': instance.name,
      'headimg': instance.headimg,
      'sex': instance.sex
    };
