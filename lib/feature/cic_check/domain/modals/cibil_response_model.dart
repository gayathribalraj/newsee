class CibilResponse {
  final String status;
  final String htmlFileCIR;
  final String cibilScore;

  CibilResponse({
    required this.status,
    required this.htmlFileCIR,
    required this.cibilScore,
  });

  factory CibilResponse.fromJson(Map<String, dynamic> json) {
    return CibilResponse(
      status: json['Status'] ?? '',
      htmlFileCIR: json['htmlFileCIR'] ?? '',
      cibilScore: json['cibilScore'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'Status': status,
    'htmlFileCIR': htmlFileCIR,
    'cibilScore': cibilScore,
  };
}
