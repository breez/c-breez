import 'package:json_annotation/json_annotation.dart';
part 'recommended_fee_payload.g.dart';

@JsonSerializable(explicitToJson: true)
class RecommendedFeePayload {
  final int fastestFee;
  final int halfHourFee;
  final int hourFee;
  final int economyFee;
  final int minimumFee;

  RecommendedFeePayload(
    this.fastestFee,
    this.halfHourFee,
    this.hourFee,
    this.economyFee,
    this.minimumFee,
  );

  factory RecommendedFeePayload.fromJson(Map<String, dynamic> json) => _$RecommendedFeePayloadFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendedFeePayloadToJson(this);
}
