// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'package:deligo_delivery/models/driver_profile.dart';
import 'package:deligo_delivery/models/order.dart';

part 'order_delivery_request.g.dart';

@JsonSerializable()
class OrderDeliveryRequest {
  final int? id;
  final int? delivery_profile_id;
  final Order? order;
  final DriverProfile? delivery;
  final String? status;
  final String? created_at;
  final String? updated_at;

  OrderDeliveryRequest(this.id, this.delivery_profile_id, this.order,
      this.delivery, this.status, this.created_at, this.updated_at);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order && other.id == id && other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ status.hashCode;

  factory OrderDeliveryRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderDeliveryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDeliveryRequestToJson(this);
}
