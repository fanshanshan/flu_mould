import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config {
    Config();

    num theme;
    num lauguage;
    
    factory Config.fromJson(Map<String,dynamic> json) => _$ConfigFromJson(json);
    Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
