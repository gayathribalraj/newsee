import 'dart:convert';

class VoteridRequest {
 final String epicNo ;
 final String consent;
 

  const VoteridRequest({
    required this.epicNo,
     this.consent = "Y"
  });

  VoteridRequest copyWith({
    String?epicNo ,
    String? consent,
  }) {
    return VoteridRequest(
      epicNo:  epicNo?? this.epicNo,
      consent: consent ?? this.consent,
    );
  }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'epicNo': epicNo,
      'consent': consent
    };
  }


  factory VoteridRequest.fromMap(Map<String, dynamic> map) {
    return VoteridRequest(
       epicNo : map['epicNo'] as String,
      consent: map['consent'] as String,
    );
  }
  

  String toJson() => json.encode(toMap());

  factory VoteridRequest.fromJson(String source) => VoteridRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VoteridRequest(: $epicNo, consent: $consent)';
 
  @override
  int get hashCode => epicNo.hashCode ^ consent.hashCode;
}
