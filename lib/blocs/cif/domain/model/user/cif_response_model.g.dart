// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cif_response_model.dart';

// JsonSerializableGenerator

CifResponseModel _$CifResponseModelFromJson(Map<String, dynamic> json) =>
    CifResponseModel(
      staffFlag: json['staffFlag'] as String,
      cifFlga: json['cifFlga'] as String,
      CBS: json['CBS'] as bool,
      resitype: json['resitype'] as String,
      lpretLeadDetails: json['lpretLeadDetails'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$CifResponseModelToJson(CifResponseModel instance) =>
    <String, dynamic>{
      'staffFlag': instance.staffFlag,
      'cifFlga': instance.cifFlga,
      'CBS': instance.CBS,
      'resitype': instance.resitype,
      'lpretLeadDetails': instance.lpretLeadDetails,
    };
