// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

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
  final Map<String, dynamic> MasterDetails;
  AuthResponseModel({
    required this.id,
    required this.UserName,
    required this.Orgscode,
    required this.orgLocationList,
    required this.StatusCode,
    required this.UserGroups,
    required this.token,
    required this.MasterDetails,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  @override
  String toString() {
    return 'AuthResponseModel(id: $id, UserName: $UserName, Orgscode: $Orgscode, orgLocationList: $orgLocationList, StatusCode: $StatusCode, UserGroups: $UserGroups, token: $token, MasterDetails: $MasterDetails)';
  }

  AuthResponseModel copyWith({
    String? id,
    String? UserName,
    String? Orgscode,
    List<String>? orgLocationList,
    String? StatusCode,
    List<String>? UserGroups,
    String? token,
    Map<String, dynamic>? MasterDetails,
  }) {
    return AuthResponseModel(
      id: id ?? this.id,
      UserName: UserName ?? this.UserName,
      Orgscode: Orgscode ?? this.Orgscode,
      orgLocationList: orgLocationList ?? this.orgLocationList,
      StatusCode: StatusCode ?? this.StatusCode,
      UserGroups: UserGroups ?? this.UserGroups,
      token: token ?? this.token,
      MasterDetails: MasterDetails ?? this.MasterDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'UserName': UserName,
      'Orgscode': Orgscode,
      'orgLocationList': orgLocationList,
      'StatusCode': StatusCode,
      'UserGroups': UserGroups,
      'token': token,
      'MasterDetails': MasterDetails,
    };
  }

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    return AuthResponseModel(
      id: map['id'] as String,
      UserName: map['UserName'] as String,
      Orgscode: map['Orgscode'] as String,
      orgLocationList: List<String>.from(
        (map['orgLocationList'] as List<String>),
      ),
      StatusCode: map['StatusCode'] as String,
      UserGroups: List<String>.from((map['UserGroups'] as List<String>)),
      token: map['token'] as String,
      MasterDetails: Map<String, dynamic>.from(
        (map['MasterDetails'] as Map<String, dynamic>),
      ),
    );
  }

  @override
  bool operator ==(covariant AuthResponseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.UserName == UserName &&
        other.Orgscode == Orgscode &&
        listEquals(other.orgLocationList, orgLocationList) &&
        other.StatusCode == StatusCode &&
        listEquals(other.UserGroups, UserGroups) &&
        other.token == token &&
        mapEquals(other.MasterDetails, MasterDetails);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        UserName.hashCode ^
        Orgscode.hashCode ^
        orgLocationList.hashCode ^
        StatusCode.hashCode ^
        UserGroups.hashCode ^
        token.hashCode ^
        MasterDetails.hashCode;
  }
}
