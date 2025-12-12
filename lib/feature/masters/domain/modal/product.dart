// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

/* 
@author    : karthick.d  
@desc     : data class model for Product Master - Main category and Subcategory
@param    : {String lsfFacId} - this is the id for the product 
            {String lsfFacParentId} - this is the id of the parent product , for
                                      main category it is 0 for 
                                      sub category it has non zero value
            {String lsfFacDesc} - Product name string
            {String lsfBizVertical} - number that define product type
                                      Agri - 7 , Retail - 11 
 */

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String lsfFacId;
  final String lsfFacDesc;
  final String lsfFacParentId;
  final String lsfBizVertical;
  final String lsfFacType;
  Product({
    required this.lsfFacId,
    required this.lsfFacDesc,
    required this.lsfFacParentId,
    required this.lsfBizVertical,
    required this.lsfFacType,
  });

  Product copyWith({
    String? lsfFacId,
    String? lsfFacDesc,
    String? lsfFacParentId,
    String? lsfBizVertical,
    String? lsfFacType,
  }) {
    return Product(
      lsfFacId: lsfFacId ?? this.lsfFacId,
      lsfFacDesc: lsfFacDesc ?? this.lsfFacDesc,
      lsfFacParentId: lsfFacParentId ?? this.lsfFacParentId,
      lsfBizVertical: lsfBizVertical ?? this.lsfBizVertical,
      lsfFacType: lsfFacType ?? this.lsfFacType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lsfFacId': lsfFacId,
      'lsfFacDesc': lsfFacDesc,
      'lsfFacParentId': lsfFacParentId,
      'lsfBizVertical': lsfBizVertical,
      'lsfFacType': lsfFacType,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      lsfFacId: map['lsfFacId'] as String,
      lsfFacDesc: map['lsfFacDesc'] as String,
      lsfFacParentId: map['lsfFacParentId'] as String,
      lsfBizVertical: map['lsfBizVertical'] as String,
      lsfFacType: map['lsfFacType'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  @override
  String toString() {
    return 'Product(lsfFacId: $lsfFacId, lsfFacDesc: $lsfFacDesc, lsfFacParentId: $lsfFacParentId, lsfBizVertical: $lsfBizVertical, lsfFacType:$lsfFacType)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.lsfFacId == lsfFacId &&
        other.lsfFacDesc == lsfFacDesc &&
        other.lsfFacParentId == lsfFacParentId &&
        other.lsfBizVertical == lsfBizVertical &&
        other.lsfFacType == lsfFacType;
  }

  @override
  int get hashCode {
    return lsfFacId.hashCode ^
        lsfFacDesc.hashCode ^
        lsfFacParentId.hashCode ^
        lsfBizVertical.hashCode ^
        lsfFacType.hashCode;
  }
}
