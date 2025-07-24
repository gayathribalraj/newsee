// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class GetLeadResponse {
  final List<Map<String,dynamic>>? LeadAddressDetails;
  final Map<String, dynamic>? LeadDetails;
  GetLeadResponse({
    this.LeadAddressDetails,
    this.LeadDetails,
  });

  GetLeadResponse copyWith({
    List<Map<String,dynamic>>? LeadAddressDetails,
    Map<String, dynamic>? LeadDetails,
  }) {
    return GetLeadResponse(
      LeadAddressDetails: LeadAddressDetails ?? this.LeadAddressDetails,
      LeadDetails: LeadDetails ?? this.LeadDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'LeadAddressDetails': LeadAddressDetails,
      'LeadDetails': LeadDetails,
    };
  }

  factory GetLeadResponse.fromMap(Map<String, dynamic> map) {
  return GetLeadResponse(
    LeadAddressDetails: map['LeadAddressDetails'] != null
        ? List<Map<String, dynamic>>.from(
            (map['LeadAddressDetails'] as List).map(
              (x) => Map<String, dynamic>.from(x),
            ),
          )
        : null,
    LeadDetails: Map<String, dynamic>.from(map['LeadDetails'] as Map),
  );
}

  String toJson() => json.encode(toMap());

  factory GetLeadResponse.fromJson(String source) => GetLeadResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GetLeadResponse(LeadAddressDetails: $LeadAddressDetails, LeadDetails: $LeadDetails)';

  @override
  bool operator ==(covariant GetLeadResponse other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.LeadAddressDetails, LeadAddressDetails) &&
      mapEquals(other.LeadDetails, LeadDetails);
  }

  @override
  int get hashCode => LeadAddressDetails.hashCode ^ LeadDetails.hashCode;
}
