// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
part 'user_details.g.dart';

@JsonSerializable()
class UserDetails {
  final String LPuserID;
  final String UserName;
  final String Orgscode;
  final String OrgLevel;
  final String OrgName;
  UserDetails({
    required this.LPuserID,
    required this.UserName,
    required this.Orgscode,
    required this.OrgLevel,
    required this.OrgName,
  });

  UserDetails copyWith({
    String? LPuserID,
    String? UserName,
    String? Orgscode,
    String? OrgLevel,
    String? OrgName,
  }) {
    return UserDetails(
      LPuserID: LPuserID ?? this.LPuserID,
      UserName: UserName ?? this.UserName,
      Orgscode: Orgscode ?? this.Orgscode,
      OrgLevel: OrgLevel ?? this.OrgLevel,
      OrgName: OrgName ?? this.OrgName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'LPuserID': LPuserID,
      'UserName': UserName,
      'Orgscode': Orgscode,
      'OrgLevel': OrgLevel,
      'OrgName': OrgName,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      LPuserID: map['LPuserID'] as String,
      UserName: map['UserName'] as String,
      Orgscode: map['Orgscode'] as String,
      OrgLevel: map['OrgLevel'] as String,
      OrgName: map['OrgName'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);

  factory UserDetails.fromJson(Map<String, dynamic> source) =>
      _$UserDetailsFromJson(source);

  @override
  String toString() {
    return 'UserDetails(LPuserID: $LPuserID, UserName: $UserName, Orgscode: $Orgscode, OrgLevel: $OrgLevel, OrgName: $OrgName)';
  }

  @override
  bool operator ==(covariant UserDetails other) {
    if (identical(this, other)) return true;

    return other.LPuserID == LPuserID &&
        other.UserName == UserName &&
        other.Orgscode == Orgscode &&
        other.OrgLevel == OrgLevel &&
        other.OrgName == OrgName;
  }

  @override
  int get hashCode {
    return LPuserID.hashCode ^
        UserName.hashCode ^
        Orgscode.hashCode ^
        OrgLevel.hashCode ^
        OrgName.hashCode;
  }
}
