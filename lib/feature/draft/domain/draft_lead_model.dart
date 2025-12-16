class DraftLead {
  final String leadref;
  final String createdOn;
  final Map<String, dynamic> loan;
  final Map<String, dynamic> dedupe;
  final Map<String, dynamic> personal;
  final Map<String, dynamic> address;
  final List<Map<String, dynamic>> coapplicant;

  DraftLead({
    required this.leadref,
    required this.createdOn,
    required this.loan,
    required this.dedupe,
    required this.personal,
    required this.address,
    required this.coapplicant,
  });

  Map<String, dynamic> toJson() => {
    'leadref': leadref,
    'createdOn': createdOn,
    'loan': loan,
    'dedupe': dedupe,
    'personal': personal,
    'address': address,
    'coapplicant': coapplicant,
  };

  factory DraftLead.fromJson(Map<String, dynamic> json) => DraftLead(
    leadref: json['leadref'] as String,
    createdOn: json['createdOn'] as String,
    loan:
        json['loan'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json['loan'])
            : {},
    dedupe:
        json['dedupe'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json['dedupe'])
            : {},
    personal:
        json['personal'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json['personal'])
            : {},
    address:
        json['address'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json['address'])
            : {},
    coapplicant:
        json['coapplicant'] is List
            ? (json['coapplicant'] as List)
                .whereType<Map<String, dynamic>>()
                .map(
                  (e) => Map<String, dynamic>.from(e),
                )
                .toList()
            : [],
  );
}
