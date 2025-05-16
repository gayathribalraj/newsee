// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      id: json['LPuserID'] as String,
      UserName: json['UserName'] as String,
      Orgscode: json['Orgscode'] as String,
      orgLocationList:
          (json['orgLocationList'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      StatusCode: json['StatusCode'] as String,
      UserGroups:
          (json['UserGroups'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      token: json['token'] as String,
    );

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'LPuserID': instance.id,
      'UserName': instance.UserName,
      'Orgscode': instance.Orgscode,
      'orgLocationList': instance.orgLocationList,
      'StatusCode': instance.StatusCode,
      'UserGroups': instance.UserGroups,
      'token': instance.token,
    };
