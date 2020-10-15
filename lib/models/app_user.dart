import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class App_user {
    App_user();

    String name;
    String headimg;
    String sex;
    
    factory App_user.fromJson(Map<String,dynamic> json) => _$App_userFromJson(json);
    Map<String, dynamic> toJson() => _$App_userToJson(this);
}
