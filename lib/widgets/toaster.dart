import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  static Future<void> showToast(String msg) => Fluttertoast.showToast(
      msg: msg, backgroundColor: Colors.black.withValues(alpha: 0.5));

  static Future<void> showToastTop(String msg) => Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      gravity: ToastGravity.TOP);

  static Future<void> showToastCenter(String msg) => Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      gravity: ToastGravity.CENTER);

  static Future<void> showToastBottom(String msg) => Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      gravity: ToastGravity.BOTTOM);
}
