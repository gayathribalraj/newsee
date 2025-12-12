import 'dart:convert';

class PanidRequest {
 final String pan ;
 final String consent;
 

  const PanidRequest({
    required this.pan,
     this.consent = "Y"
  });

  PanidRequest copyWith({
    String?pan ,
    String? consent,
  }) {
    return PanidRequest(
      pan:  pan?? this.pan,
      consent: consent ?? this.consent,
    );
  }


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pan': pan,
      'consent': consent
    };
  }


  factory PanidRequest.fromMap(Map<String, dynamic> map) {
    return PanidRequest(
       pan : map['pan'] as String,
      consent: map['consent'] as String,
    );
  }
  

  String toJson() => json.encode(toMap());

  factory PanidRequest.fromJson(String source) => PanidRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PanidRequest(: $pan, consent: $consent)';
 
  @override
  int get hashCode => pan.hashCode ^ consent.hashCode;
}
