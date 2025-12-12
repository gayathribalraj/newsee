import 'package:json_annotation/json_annotation.dart';

// part 'cif_response.g.dart'; //i comment

@JsonSerializable(explicitToJson: true)
class CifResponse {
  final String? custTitle;
  final String? firstName;
  final String? secondName;
  final String? lastName;
  final String? email;
  final String? dateOfBirth;
  final String? mobilNum;
  final String? panNo;
  final String? aadharNum;
  final String? restAddress;
  final String? borrowerState;
  final String? borrowerCity;
  final String? borrowerPostalCode;
  final String? relCifid;
  final String? gender;
  final String? communityName;
  final String? casteName;
  final String? applicantName;
  final String? customrStatus;
  final String? operativeAcct;
  final String? constitutionCode;
  final String? constitutionName;
  final String? sectorCode;
  final String? sectorDesc;
  final String? custId;
  final String? loanAcctNum;

  CifResponse({
    this.custTitle,
    this.firstName,
    this.secondName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.mobilNum,
    this.panNo,
    this.aadharNum,
    this.restAddress,
    this.borrowerState,
    this.borrowerCity,
    this.borrowerPostalCode,
    this.relCifid,
    this.gender,
    this.communityName,
    this.casteName,
    this.applicantName,
    this.customrStatus,
    this.operativeAcct,
    this.constitutionCode,
    this.constitutionName,
    this.sectorCode,
    this.sectorDesc,
    this.custId,
    this.loanAcctNum,
  });

  // factory CifResponse.fromJson(Map<String, dynamic> json) =>
  //     _$CifResponseFromJson(json);

  // Map<String, dynamic> toJson() => _$CifResponseToJson(this);

  CifResponse copyWith({
    String? custTitle,
    String? firstName,
    String? secondName,
    String? lastName,
    String? email,
    String? dateOfBirth,
    String? mobilNum,
    String? panNo,
    String? aadharNum,
    String? restAddress,
    String? borrowerState,
    String? borrowerCity,
    String? borrowerPostalCode,
    String? relCifid,
    String? gender,
    String? fatherName,
    String? communityName,
    String? casteName,
    String? applicantName,
    String? customrStatus,
    String? schmType,
    String? schmDesc,
    String? operativeAcct,
    String? constitutionCode,
    String? constitutionName,
    String? kccacctNum,
    String? sectorCode,
    String? sectorDesc,
    String? custId,
    String? msgid,
    String? loanAcctNum,
    String? maxAlwdLmt,
  }) {
    return CifResponse(
      custTitle: custTitle ?? this.custTitle,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      mobilNum: mobilNum ?? this.mobilNum,
      panNo: panNo ?? this.panNo,
      aadharNum: aadharNum ?? this.aadharNum,
      restAddress: restAddress ?? this.restAddress,
      borrowerState: borrowerState ?? this.borrowerState,
      borrowerCity: borrowerCity ?? this.borrowerCity,
      borrowerPostalCode: borrowerPostalCode ?? this.borrowerPostalCode,
      relCifid: relCifid ?? this.relCifid,
      gender: gender ?? this.gender,
      communityName: communityName ?? this.communityName,
      casteName: casteName ?? this.casteName,
      applicantName: applicantName ?? this.applicantName,
      customrStatus: customrStatus ?? this.customrStatus,
      operativeAcct: operativeAcct ?? this.operativeAcct,
      constitutionCode: constitutionCode ?? this.constitutionCode,
      constitutionName: constitutionName ?? this.constitutionName,
      sectorCode: sectorCode ?? this.sectorCode,
      sectorDesc: sectorDesc ?? this.sectorDesc,
      custId: custId ?? this.custId,
      loanAcctNum: loanAcctNum ?? this.loanAcctNum,
    );
  }

  // @override
  // String toString() => 'CifResponse(${toJson()})';
}
