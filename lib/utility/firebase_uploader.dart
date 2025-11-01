import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:deligo_delivery/widgets/loader.dart';

class FirebaseUploader {
  static Future<String?> uploadFile(BuildContext context, File fileToUpload,
      String? progressText, String? progressBodyText, String? child) async {
    Loader.showProgress(context, progressText ?? "uploading..",
        progressBodyText ?? "Please Wait.");
    final Reference reference = FirebaseStorage.instance
        .ref()
        .child('files')
        .child(child ?? fileToUpload.uri.pathSegments.last);
    final UploadTask uploadTask = reference.putFile(fileToUpload);
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      if (kDebugMode) {
        print('Task state: ${snapshot.state}');
        print(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      }
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      if (kDebugMode) {
        print(uploadTask.snapshot);
      }

      if (e.code == 'permission-denied') {
        if (kDebugMode) {
          print('User does not have permission to upload to this reference.');
        }
      }
    });
    String storageUrl = await uploadTask
        .whenComplete(() {})
        .then((snapshot) => snapshot.ref.getDownloadURL());

    Loader.dismissProgress();
    if (kDebugMode) {
      print("firebase_storage_url: $storageUrl");
    }
    return storageUrl;
  }

  static Future<void> deleteRef(String child) =>
      FirebaseStorage.instance.ref().child('files').child(child).delete();
}
