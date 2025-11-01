// ignore_for_file: non_constant_identifier_names
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:deligo_delivery/utility/helper.dart';

import 'user_data.dart';

part 'user_notification.g.dart';

@JsonSerializable()
class UserNotification {
  final int id;
  final String text;
  final String created_at;
  final UserData user;
  final UserData fromuser;
  //FORUSER: {"from_user_name”: "Tester Provider”, "from_user_image”: null} FORPROVIDER: {"from_user_image”: null}
  final dynamic meta;

  String? created_at_formatted;
  String? categoryTitle;

  UserNotification(
      this.id, this.text, this.created_at, this.user, this.fromuser, this.meta);

  factory UserNotification.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationToJson(this);

  String getName() {
    String? toReturn;
    try {
      if (meta != null &&
          meta is Map &&
          (meta as Map).containsKey("from_user_name") &&
          (meta as Map)["from_user_name"] != null) {
        toReturn = meta["from_user_name"];
      }
    } catch (e) {
      if (kDebugMode) {
        print("getName: $e");
      }
    }
    if (toReturn == null || toReturn.isEmpty) {
      toReturn = fromuser.name;
    }
    return toReturn;
  }

  void setup() {
    user.setup();
    fromuser.setup();
    created_at_formatted = Helper.setupDateTime(created_at, false, true);
    if (meta != null &&
        meta is Map &&
        (meta as Map).containsKey("category") &&
        (meta as Map)["category"] != null &&
        (meta as Map)["category"].containsKey("title")) {
      categoryTitle = meta["category"]["title"];
    }
  }
}
