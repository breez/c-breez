// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_fee_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedFeePayload _$RecommendedFeePayloadFromJson(
        Map<String, dynamic> json) =>
    RecommendedFeePayload(
      json['fastestFee'] as int,
      json['halfHourFee'] as int,
      json['hourFee'] as int,
      json['economyFee'] as int,
      json['minimumFee'] as int,
    );

Map<String, dynamic> _$RecommendedFeePayloadToJson(
        RecommendedFeePayload instance) =>
    <String, dynamic>{
      'fastestFee': instance.fastestFee,
      'halfHourFee': instance.halfHourFee,
      'hourFee': instance.hourFee,
      'economyFee': instance.economyFee,
      'minimumFee': instance.minimumFee,
    };
