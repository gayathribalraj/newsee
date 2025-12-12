// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

/* 
@author    : karthick.d 27/05/2025
@desc      : data class for ProductScheme Model
@param     : {String optionValue} - 
             {String optionDesc} - Scheme Name
             {String optionId} - unique number assigned for a Scheme which is required to pass to 
             listofvalues masters to fetch the scheme code
 */
part 'productschema.g.dart';

@JsonSerializable()
class ProductSchema {
  final String optionValue;
  final String optionDesc;
  final String optionId;
  ProductSchema({
    required this.optionValue,
    required this.optionDesc,
    required this.optionId,
  });

  ProductSchema copyWith({
    String? optionValue,
    String? optionDesc,
    String? optionId,
  }) {
    return ProductSchema(
      optionValue: optionValue ?? this.optionValue,
      optionDesc: optionDesc ?? this.optionDesc,
      optionId: optionId ?? this.optionId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'optionValue': optionValue,
      'optionDesc': optionDesc,
      'optionId': optionId,
    };
  }

  factory ProductSchema.fromMap(Map<String, dynamic> map) {
    return ProductSchema(
      optionValue: map['optionValue'] as String,
      optionDesc: map['optionDesc'] as String,
      optionId: map['optionId'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$ProductSchemaToJson(this);

  factory ProductSchema.fromJson(Map<String, dynamic> json) =>
      _$ProductSchemaFromJson(json);

  @override
  String toString() =>
      'ProductSchema(optionValue: $optionValue, optionDesc: $optionDesc, optionId: $optionId)';

  @override
  bool operator ==(covariant ProductSchema other) {
    if (identical(this, other)) return true;

    return other.optionValue == optionValue &&
        other.optionDesc == optionDesc &&
        other.optionId == optionId;
  }

  @override
  int get hashCode =>
      optionValue.hashCode ^ optionDesc.hashCode ^ optionId.hashCode;
}
