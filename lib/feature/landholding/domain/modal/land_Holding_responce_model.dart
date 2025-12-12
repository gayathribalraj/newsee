import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';

class LandHoldingResponceModel {
  final List<LandData> agriLandHoldingsList;
  final List<PolygonDetailsModal>? polygonDetails;
  final List? partyDetails;

  LandHoldingResponceModel({
    required this.agriLandHoldingsList,
    this.polygonDetails,
    this.partyDetails,
  });

  LandHoldingResponceModel copyWith({
    List<LandData>? agriLandHoldingsList,
    List<PolygonDetailsModal>? polygonDetails,
    List? partyDetails,
  }) {
    return LandHoldingResponceModel(
      agriLandHoldingsList: agriLandHoldingsList ?? this.agriLandHoldingsList,
      polygonDetails: polygonDetails ?? this.polygonDetails,
      partyDetails: partyDetails ?? this.partyDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'agriLandHoldingsList':
          agriLandHoldingsList.map((e) => e.toMap()).toList(),
      'polygonDetails': polygonDetails?.map((e) => e.toJson()).toList() ?? [],
      'partyDetails': partyDetails,
    };
  }

  factory LandHoldingResponceModel.fromMap(Map<String, dynamic> map) {
    return LandHoldingResponceModel(
      agriLandHoldingsList: List<LandData>.from(
        (map['agriLandHoldingsList'] ?? []).map((e) {
          final m = Map<String, dynamic>.from(e);

          // Convert mixed numeric/string values safely
          // m['lklTotAcre'] = m['lklTotAcre']?.toString();
          // m['lklsumOfTotalAcreage'] = m['lklsumOfTotalAcreage']?.toString();

          return LandData.fromMap(m);
        }),
      ),
      polygonDetails: List<PolygonDetailsModal>.from(
        (map['polygonDetails'] ?? []).map(
          (e) => PolygonDetailsModal.fromJson(Map<String, dynamic>.from(e)),
        ),
      ),

      partyDetails: (map['partyDetails'] is List) ? map['partyDetails'] : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory LandHoldingResponceModel.fromJson(dynamic source) {
    if (source is String) {
      return LandHoldingResponceModel.fromMap(json.decode(source));
    } else if (source is Map<String, dynamic>) {
      return LandHoldingResponceModel.fromMap(source);
    } else {
      throw Exception("Invalid source type for fromJson");
    }
  }

  @override
  String toString() =>
      'LandHoldingResponceModel(agriLandHoldingsList: $agriLandHoldingsList, polygonDetails: $polygonDetails, partyDetails: $partyDetails)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LandHoldingResponceModel &&
        listEquals(other.agriLandHoldingsList, agriLandHoldingsList) &&
        listEquals(other.polygonDetails, polygonDetails) &&
        listEquals(other.partyDetails, partyDetails);
  }

  @override
  int get hashCode =>
      agriLandHoldingsList.hashCode ^
      partyDetails.hashCode ^
      polygonDetails.hashCode;
}

class PolygonDetailsModal {
  int? lppRowId;
  String? lppPropNo;
  int? lppCustId;
  int? lppCreatedDate;
  double? lppLongitude;
  double? lppLatitude;

  PolygonDetailsModal({
    this.lppRowId,
    this.lppPropNo,
    this.lppCustId,
    this.lppCreatedDate,
    this.lppLongitude,
    this.lppLatitude,
  });

  factory PolygonDetailsModal.fromJson(Map<String, dynamic> json) {
    return PolygonDetailsModal(
      lppRowId: json['lppRowId'],
      lppPropNo: json['lppPropNo'],
      lppCustId: json['lppCustId'],
      lppCreatedDate: json['lppCreatedDate'],
      lppLongitude: (json['lppLongitude'] as num?)?.toDouble(),
      lppLatitude: (json['lppLatitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lppRowId': lppRowId,
      'lppPropNo': lppPropNo,
      'lppCustId': lppCustId,
      'lppCreatedDate': lppCreatedDate,
      'lppLongitude': lppLongitude,
      'lppLatitude': lppLatitude,
    };
  }
}
