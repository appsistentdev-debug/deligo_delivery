import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

extension StringExtensions on String? {
  bool get isNotBlank => this != null && this!.isNotEmpty;

  bool get isBlank => !isNotBlank;

  bool equalsIgnoreCase(String? other) =>
      this?.toLowerCase() == other?.toLowerCase();

  bool containsIgnoreCase(String? other) {
    if (other == null) return false;
    return this?.toLowerCase().contains(other.toLowerCase()) ?? false;
  }

  String? validateMobileNumber(String dialCode) {
    RegExp regExp = RegExp(r"^\+(?:[0-9] ?){6,14}[0-9]$");
    if (isBlank) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(dialCode + this!)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? get validateFullName {
    RegExp regExp = RegExp(r"^[a-z A-Z,.\-]+$");
    if (isBlank) {
      return 'Please enter full name';
    } else if (!regExp.hasMatch(this!)) {
      return 'Please enter valid full name';
    } else {
      return null;
    }
  }

  String? get validateEmail {
    RegExp regExp = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (isBlank) {
      return 'Please enter email address';
    } else if (!regExp.hasMatch(this!)) {
      return 'Please enter valid email address';
    } else {
      return null;
    }
  }

  IconData get icon {
    String? type = this?.toLowerCase();
    switch (type) {
      case 'home':
        return Icons.home;
      case 'office':
        return Icons.apartment;
      default:
        return Icons.location_on;
    }
  }

  String get encrypt {
    var bytes = utf8.encode(this!);
    Digest sha512Result = sha512.convert(bytes);
    return sha512Result.toString();
  }

  String get clean {
    return this?.replaceAll(" ", "") ?? "";
  }

  String capitalizeFirst() {
    if (this?.isEmpty ?? false) {
      return this ?? "";
    }
    if (this?.length == 1) {
      return this!.toUpperCase();
    }
    return this![0].toUpperCase() + this!.substring(1).toLowerCase();
  }
}
