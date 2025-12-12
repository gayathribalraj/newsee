import 'dart:convert';

class LandHoldingDeleteRequest {
  String proposalNumber;
  String custId;
  String rowId;
  String token;
  LandHoldingDeleteRequest({
    required this.proposalNumber,
    required this.custId,
    required this.rowId,
    required this.token,
  });

  LandHoldingDeleteRequest copyWith({
    String? proposalNumber,
    String? custId,
    String? rowId,
    String? token,
  }) {
    return LandHoldingDeleteRequest(
      proposalNumber: proposalNumber ?? this.proposalNumber,
      custId: custId ?? this.custId,
      rowId: rowId ?? this.rowId,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'proposalNumber': proposalNumber,
      'custId': custId,
      'rowId': rowId,
      'token': token,
    };
  }

  factory LandHoldingDeleteRequest.fromMap(Map<String, dynamic> map) {
    return LandHoldingDeleteRequest(
      proposalNumber: map['proposalNumber'] as String,
      custId: map['custId'] as String,
      rowId: map['rowId'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LandHoldingDeleteRequest.fromJson(String source) =>
      LandHoldingDeleteRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'LandHoldingDeleteRequest(proposalNumber: $proposalNumber, custId: $custId, rowId: $rowId, token: $token)';

  @override
  bool operator ==(covariant LandHoldingDeleteRequest other) {
    if (identical(this, other)) return true;

    return other.proposalNumber == proposalNumber &&
        other.custId == custId &&
        other.rowId == rowId &&
        other.token == token;
  }

  @override
  int get hashCode =>
      proposalNumber.hashCode ^
      custId.hashCode ^
      rowId.hashCode ^
      token.hashCode;
}
