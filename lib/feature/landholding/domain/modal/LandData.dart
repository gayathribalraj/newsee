// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Landdata {
  String? applicantName;
  String? locationOfFarm;
  String? state;
  String? taluk;
  String? firka;
  String? totalAcreage;
  String? irrigatedLand;
  String? compactBlocks;
  bool? landOwnedByApplicant;
  String? distanceFromBranch;
  String? district;
  String? village;
  String? surveyNo;
  String? natureOfRight;
  String? irrigationFacilities;
  String? affectedByCeiling;
  String? landAgriActive;
  Landdata({
    this.applicantName,
    this.locationOfFarm,
    this.state,
    this.taluk,
    this.firka,
    this.totalAcreage,
    this.irrigatedLand,
    this.compactBlocks,
    this.landOwnedByApplicant,
    this.distanceFromBranch,
    this.district,
    this.village,
    this.surveyNo,
    this.natureOfRight,
    this.irrigationFacilities,
    this.affectedByCeiling,
    this.landAgriActive,
  });

  Landdata copyWith({
    String? applicantName,
    String? locationOfFarm,
    String? state,
    String? taluk,
    String? firka,
    String? totalAcreage,
    String? irrigatedLand,
    String? compactBlocks,
    bool? landOwnedByApplicant,
    String? distanceFromBranch,
    String? district,
    String? village,
    String? surveyNo,
    String? natureOfRight,
    String? irrigationFacilities,
    String? affectedByCeiling,
    String? landAgriActive,
  }) {
    return Landdata(
      applicantName: applicantName ?? this.applicantName,
      locationOfFarm: locationOfFarm ?? this.locationOfFarm,
      state: state ?? this.state,
      taluk: taluk ?? this.taluk,
      firka: firka ?? this.firka,
      totalAcreage: totalAcreage ?? this.totalAcreage,
      irrigatedLand: irrigatedLand ?? this.irrigatedLand,
      compactBlocks: compactBlocks ?? this.compactBlocks,
      landOwnedByApplicant: landOwnedByApplicant ?? this.landOwnedByApplicant,
      distanceFromBranch: distanceFromBranch ?? this.distanceFromBranch,
      district: district ?? this.district,
      village: village ?? this.village,
      surveyNo: surveyNo ?? this.surveyNo,
      natureOfRight: natureOfRight ?? this.natureOfRight,
      irrigationFacilities: irrigationFacilities ?? this.irrigationFacilities,
      affectedByCeiling: affectedByCeiling ?? this.affectedByCeiling,
      landAgriActive: landAgriActive ?? this.landAgriActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'applicantName': applicantName,
      'locationOfFarm': locationOfFarm,
      'state': state,
      'taluk': taluk,
      'firka': firka,
      'totalAcreage': totalAcreage,
      'irrigatedLand': irrigatedLand,
      'compactBlocks': compactBlocks,
      'landOwnedByApplicant': landOwnedByApplicant,
      'distanceFromBranch': distanceFromBranch,
      'district': district,
      'village': village,
      'surveyNo': surveyNo,
      'natureOfRight': natureOfRight,
      'irrigationFacilities': irrigationFacilities,
      'affectedByCeiling': affectedByCeiling,
      'landAgriActive': landAgriActive,
    };
  }

  factory Landdata.fromMap(Map<String, dynamic> map) {
    return Landdata(
      applicantName:
          map['applicantName'] != null ? map['applicantName'] as String : null,
      locationOfFarm:
          map['locationOfFarm'] != null
              ? map['locationOfFarm'] as String
              : null,
      state: map['state'] != null ? map['state'] as String : null,
      taluk: map['taluk'] != null ? map['taluk'] as String : null,
      firka: map['firka'] != null ? map['firka'] as String : null,
      totalAcreage:
          map['totalAcreage'] != null ? map['totalAcreage'] as String : null,
      irrigatedLand:
          map['irrigatedLand'] != null ? map['irrigatedLand'] as String : null,
      compactBlocks:
          map['compactBlocks'] != null ? map['compactBlocks'] as String : null,
      landOwnedByApplicant:
          map['landOwnedByApplicant'] != null
              ? map['landOwnedByApplicant'] as bool
              : null,
      distanceFromBranch:
          map['distanceFromBranch'] != null
              ? map['distanceFromBranch'] as String
              : null,
      district: map['district'] != null ? map['district'] as String : null,
      village: map['village'] != null ? map['village'] as String : null,
      surveyNo: map['surveyNo'] != null ? map['surveyNo'] as String : null,
      natureOfRight:
          map['natureOfRight'] != null ? map['natureOfRight'] as String : null,
      irrigationFacilities:
          map['irrigationFacilities'] != null
              ? map['irrigationFacilities'] as String
              : null,
      affectedByCeiling:
          map['affectedByCeiling'] != null
              ? map['affectedByCeiling'] as String
              : null,
      landAgriActive:
          map['landAgriActive'] != null
              ? map['landAgriActive'] as String
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Landdata.fromJson(String source) =>
      Landdata.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Landdata(applicantName: $applicantName, locationOfFarm: $locationOfFarm, state: $state, taluk: $taluk, firka: $firka, totalAcreage: $totalAcreage, irrigatedLand: $irrigatedLand, compactBlocks: $compactBlocks, landOwnedByApplicant: $landOwnedByApplicant, distanceFromBranch: $distanceFromBranch, district: $district, village: $village, surveyNo: $surveyNo, natureOfRight: $natureOfRight, irrigationFacilities: $irrigationFacilities, affectedByCeiling: $affectedByCeiling, landAgriActive: $landAgriActive)';
  }

  @override
  bool operator ==(covariant Landdata other) {
    if (identical(this, other)) return true;

    return other.applicantName == applicantName &&
        other.locationOfFarm == locationOfFarm &&
        other.state == state &&
        other.taluk == taluk &&
        other.firka == firka &&
        other.totalAcreage == totalAcreage &&
        other.irrigatedLand == irrigatedLand &&
        other.compactBlocks == compactBlocks &&
        other.landOwnedByApplicant == landOwnedByApplicant &&
        other.distanceFromBranch == distanceFromBranch &&
        other.district == district &&
        other.village == village &&
        other.surveyNo == surveyNo &&
        other.natureOfRight == natureOfRight &&
        other.irrigationFacilities == irrigationFacilities &&
        other.affectedByCeiling == affectedByCeiling &&
        other.landAgriActive == landAgriActive;
  }

  @override
  int get hashCode {
    return applicantName.hashCode ^
        locationOfFarm.hashCode ^
        state.hashCode ^
        taluk.hashCode ^
        firka.hashCode ^
        totalAcreage.hashCode ^
        irrigatedLand.hashCode ^
        compactBlocks.hashCode ^
        landOwnedByApplicant.hashCode ^
        distanceFromBranch.hashCode ^
        district.hashCode ^
        village.hashCode ^
        surveyNo.hashCode ^
        natureOfRight.hashCode ^
        irrigationFacilities.hashCode ^
        affectedByCeiling.hashCode ^
        landAgriActive.hashCode;
  }
}
