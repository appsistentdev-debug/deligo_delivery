import 'dart:io';

import 'package:deligo_delivery/models/file_upload_response.dart';
import 'package:deligo_delivery/network/remote_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:deligo_delivery/widgets/loader.dart';

class RemoteUploader {
  static Future<String?> uploadFile(BuildContext context, File fileToUpload,
      String? progressText, String? progressBodyText) async {
    Loader.showProgress(context, progressText ?? "uploading..",
        progressBodyText ?? "Please Wait.");
    FileUploadResponse? fileUploadResponse;
    try {
      fileUploadResponse = await RemoteRepository().uploadFile(fileToUpload);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    Loader.dismissProgress();
    return fileUploadResponse?.url;
  }
}
