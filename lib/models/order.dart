// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:deligo_delivery/config/colors.dart';
import 'package:deligo_delivery/utility/app_settings.dart';
import 'package:deligo_delivery/utility/helper.dart';

import 'address.dart';
import 'order_delivery.dart';
import 'order_product.dart';
import 'payment.dart';
import 'user_data.dart';
import 'vendor.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final int id;
  final String? notes;
  final dynamic meta;
  final double? subtotal;
  final double? taxes;
  final double? delivery_fee;
  final double? total;
  final double? discount;
  final String? type;
  final String? order_type;

  final String? customer_name;
  final String? customer_email;
  final String? customer_mobile;

  final String? scheduled_on;
  final String?
      status; //["new","pending","cancelled","rejected","refund","hold","failed","accepted","preparing","prepared","dispatched","intransit","complete"]
  final int? vendor_id;
  final int? user_id;
  final String? created_at;
  final String? updated_at;
  final List<OrderProduct>? products;
  final Vendor? vendor;
  final UserData? user;
  final Address? address;
  final Address? source_address;
  final OrderDelivery? delivery;
  final Payment? payment;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? createdAtFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? scheduledOnFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? totalFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? subtotalFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? deliveryFeeFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? discountFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? taxesFormatted;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Color? color;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Color? colorLight;

  LatLng get sourceLatLng => vendor != null
      ? LatLng(vendor!.latitude, vendor!.longitude)
      : source_address != null
          ? LatLng(source_address!.latitude, source_address!.longitude)
          : LatLng(0, 0);

  LatLng get destinationLatLng => address != null
      ? LatLng(address!.latitude, address!.longitude)
      : LatLng(0, 0);

  bool get isOngoing => [
        "accepted",
        "preparing",
        "prepared",
        "dispatched",
        "intransit"
      ].contains(status?.toLowerCase());

  Order(
      this.id,
      this.notes,
      this.meta,
      this.subtotal,
      this.taxes,
      this.delivery_fee,
      this.total,
      this.discount,
      this.type,
      this.order_type,
      this.customer_name,
      this.customer_email,
      this.customer_mobile,
      this.scheduled_on,
      this.status,
      this.vendor_id,
      this.user_id,
      this.created_at,
      this.updated_at,
      this.products,
      this.vendor,
      this.user,
      this.address,
      this.source_address,
      this.delivery,
      this.payment);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order && other.id == id && other.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ status.hashCode;

  /// A necessary factory constructor for creating a new Order instance
  /// from a map. Pass the map to the generated `_$OrderFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Order.
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$OrderToJson`.
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  void setup() {
    if (created_at != null) {
      createdAtFormatted = Helper.setupDateTime(created_at!, false, true);
    }
    if (scheduled_on != null) {
      scheduledOnFormatted = Helper.setupDateTime(scheduled_on!, false, true);
    }
    totalFormatted =
        "${AppSettings.currencyIcon} ${Helper.formatNumber(num.tryParse("$total") ?? 0)}";
    subtotalFormatted =
        "${AppSettings.currencyIcon} ${Helper.formatNumber(num.tryParse("$subtotal") ?? 0)}";
    if (delivery_fee != null) {
      deliveryFeeFormatted =
          "${AppSettings.currencyIcon} ${Helper.formatNumber(num.tryParse("$delivery_fee") ?? 0)}";
    }
    if (discount != null) {
      discountFormatted =
          "${AppSettings.currencyIcon} ${Helper.formatNumber(num.tryParse("$discount") ?? 0)}";
    }
    if (taxes != null) {
      taxesFormatted =
          "${AppSettings.currencyIcon} ${Helper.formatNumber(num.tryParse("$taxes") ?? 0)}";
    }
    if (products != null) {
      for (OrderProduct op in products!) {
        op.setup();
      }
    }
    user?.setup();
    vendor?.setup();
    switch (status) {
      case "new":
      case "pending":
        color = orderGreen;
        colorLight = orderGreenLight;
        break;
      case "complete":
      case "failed":
      case "cancelled":
      case "rejected":
        color = orderBlack;
        colorLight = orderBlackLight;
        break;
      default:
        color = orderOrange;
        colorLight = orderOrangeLight;
        break;
    }
  }
}
