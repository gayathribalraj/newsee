/* 
@author     : karthick.d  14/05/2025
@desc       : Data class for Login Rest API response json serialization
              json serialization fromJSON and deserialization toJson
              will be delegated to auth_respose_model.g.dart 
              which is a generated file by running 
              dart run build_runner run command
 */
import 'package:json_annotation/json_annotation.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  @JsonKey(name: 'LPuserID')
  final String id;
  final String UserName;
  final String Orgscode;
  final List<String> orgLocationList;
  final String StatusCode;
  final List<String> UserGroups;
  final String token;

  AuthResponseModel({
    required this.id,
    required this.UserName,
    required this.Orgscode,
    required this.orgLocationList,
    required this.StatusCode,
    required this.UserGroups,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  @override
  String toString() {
    return 'AuthResponseModel [ id = $id , userName = $UserName]';
  }
}
