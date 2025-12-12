import 'dart:convert';

class LiveLinessDetails {
  final bool verifyFlag;
  final String livelinessDoc;
  final String livelinessKycDoc;

  LiveLinessDetails({
    required this.verifyFlag,
    required this.livelinessDoc,
    required this.livelinessKycDoc,
  });

  LiveLinessDetails copyWith({
    bool? verifyFlag,
    String? livelinessDoc,
    String? livelinessKycDoc,
  }) {
    return LiveLinessDetails(
      verifyFlag: verifyFlag ?? this.verifyFlag,
      livelinessDoc: livelinessDoc ?? this.livelinessDoc,
      livelinessKycDoc: livelinessKycDoc ?? this.livelinessKycDoc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'verifyFlag': verifyFlag,
      'livelinessDoc': livelinessDoc,
      'livelinessKycDoc': livelinessKycDoc,
    };
  }

  factory LiveLinessDetails.fromMap(Map<String, dynamic> map) {
    return LiveLinessDetails(
      verifyFlag: map['verifyFlag'] ?? false,
      livelinessDoc: map['livelinessDoc'] ?? '',
      livelinessKycDoc: map['livelinessKycDoc'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LiveLinessDetails.fromJson(String source) =>
      LiveLinessDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LiveLinessDetails('
        'verifyFlag: $verifyFlag, '
        'livelinessDoc: $livelinessDoc, '
        'livelinessKycDoc: $livelinessKycDoc'
        ')';
  }
}
