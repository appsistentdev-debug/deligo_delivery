// ignore_for_file: deprecated_member_use, avoid_print

import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class Repository {
  Future<void> subscribeEmail(String email) async {
    Response response = await Dio().post(
        'https://dashboard.vtlabs.dev/api/subscribe',
        data: {"email": email, "source": "opus_subscribe_page"});
    if (response.statusCode != 200) {
      throw Exception();
    }
  }

  static Future<void> launchUrl(String url) async {
    try {
      await launch(url);
    } catch (e) {
      print("launchURL: $e");
    }
  }
}
