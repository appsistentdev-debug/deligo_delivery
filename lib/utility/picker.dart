/// Depends on
/// FilePicker: https://pub.dev/packages/file_picker
/// and
/// ImagePicker: https://pub.dev/packages/image_picker
/// and
/// ImageCropper: https://pub.dev/packages/image_cropper
library;

// ignore_for_file: deprecated_member_use

import 'dart:io';

//import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:deligo_delivery/localization/app_localization.dart';

enum PickerSource { camera, gallery, ask }

enum CropConfig { free, square }

class Picker {
  final _imagePicker = ImagePicker();

  // Future<File?> pickAudioFile() async {
  //   FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
  //     type: FileType.audio,
  //   );
  //   return filePickerResult != null &&
  //           filePickerResult.files.single.path != null
  //       ? File(filePickerResult.files.single.path!)
  //       : null;
  // }

  // Future<File?> pickDocumentFile() async {
  //   FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'pdf', 'doc'],
  //   );
  //   return filePickerResult != null &&
  //           filePickerResult.files.single.path != null
  //       ? File(filePickerResult.files.single.path!)
  //       : null;
  // }

  Future<File?> pickVideoFile(
      {required BuildContext context,
      required PickerSource pickerSource}) async {
    ThemeData theme = Theme.of(context);
    if (pickerSource == PickerSource.ask) {
      PickerSource? pickerSourceChoice = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          //backgroundColor: gradientColor2,
          title: Text(
              AppLocalization.instance.getLocalizationFor("video_pic_header")),
          //content: Text(AppLocalization.instance.getLocalizationFor("video_pic_subheader")),
          actions: <Widget>[
            // MaterialButton(
            //   child: Text(AppLocalization.instance.getLocalizationFor("cancel")),
            //   textColor: theme.primaryColor,
            //   shape: RoundedRectangleBorder(
            //       side: BorderSide(color: Colors.white70)),
            //   onPressed: () => Navigator.pop(context, null),
            // ),
            MaterialButton(
              textColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.primaryColor),
              ),
              onPressed: () => Navigator.pop(context, PickerSource.camera),
              child: Text(AppLocalization.instance
                  .getLocalizationFor("image_pic_camera")),
            ),
            MaterialButton(
              textColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.primaryColor),
              ),
              onPressed: () => Navigator.pop(context, PickerSource.gallery),
              child: Text(AppLocalization.instance
                  .getLocalizationFor("image_pic_gallery")),
            ),
          ],
        ),
      );
      return pickerSourceChoice != null
          ? _pickVideo(pickerSourceChoice == PickerSource.camera
              ? ImageSource.camera
              : ImageSource.gallery)
          : null;
    } else {
      return _pickVideo(pickerSource == PickerSource.camera
          ? ImageSource.camera
          : ImageSource.gallery);
    }
  }

  Future<File?> pickImageFile(
      {required BuildContext context,
      required PickerSource pickerSource,
      CropConfig? cropConfig}) async {
    ThemeData theme = Theme.of(context);
    File? toReturn;
    if (pickerSource == PickerSource.ask) {
      PickerSource? pickerSourceChoice = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          //backgroundColor: gradientColor2,
          title: Text(
              AppLocalization.instance.getLocalizationFor("image_pic_header")),
          //content: Text(AppLocalization.instance.getLocalizationFor("image_pic_subheader")),
          actions: <Widget>[
            // MaterialButton(
            //   child: Text(AppLocalization.instance.getLocalizationFor("cancel")),
            //   textColor: theme.primaryColor,
            //   shape: RoundedRectangleBorder(
            //       side: BorderSide(color: Colors.white70)),
            //   onPressed: () => Navigator.pop(context, null),
            // ),
            MaterialButton(
              textColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.primaryColor),
              ),
              onPressed: () => Navigator.pop(context, PickerSource.camera),
              child: Text(AppLocalization.instance
                  .getLocalizationFor("image_pic_camera")),
            ),
            MaterialButton(
              textColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: theme.primaryColor),
              ),
              onPressed: () => Navigator.pop(context, PickerSource.gallery),
              child: Text(AppLocalization.instance
                  .getLocalizationFor("image_pic_gallery")),
            ),
          ],
        ),
      );
      toReturn = pickerSourceChoice != null
          ? await _pickImage(pickerSourceChoice == PickerSource.camera
              ? ImageSource.camera
              : ImageSource.gallery)
          : null;
    } else {
      toReturn = await _pickImage(pickerSource == PickerSource.camera
          ? ImageSource.camera
          : ImageSource.gallery);
    }

    if (toReturn != null && cropConfig != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: toReturn.path,
        aspectRatio: cropConfig == CropConfig.square
            ? const CropAspectRatio(ratioX: 1, ratioY: 1)
            : null,
        uiSettings: [
          AndroidUiSettings(
            hideBottomControls: true,
            lockAspectRatio: cropConfig != CropConfig.free,
            toolbarTitle: AppLocalization.instance
                    .getLocalizationFor("adjust_image")
                    .contains("_")
                ? "Adjust Image"
                : AppLocalization.instance.getLocalizationFor("adjust_image"),
            toolbarColor: theme.scaffoldBackgroundColor,
            toolbarWidgetColor: theme.primaryColor,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
          IOSUiSettings(
            title: AppLocalization.instance
                    .getLocalizationFor("adjust_image")
                    .contains("_")
                ? "Adjust Image"
                : AppLocalization.instance.getLocalizationFor("adjust_image"),
            cancelButtonTitle:
                AppLocalization.instance.getLocalizationFor("cancel"),
            doneButtonTitle:
                AppLocalization.instance.getLocalizationFor("done"),
            rotateClockwiseButtonHidden: true,
            resetButtonHidden: true,
            aspectRatioPresets: cropConfig == CropConfig.square
                ? [CropAspectRatioPreset.square]
                : [],
          ),
        ],
      );
      toReturn = croppedFile != null ? File(croppedFile.path) : null;
    }
    return toReturn;
  }

  Future<File?> _pickImage(ImageSource imageSource) async {
    final XFile? image = await _imagePicker.pickImage(source: imageSource);
    return image != null ? File(image.path) : null;
  }

  Future<File?> _pickVideo(ImageSource imageSource) async {
    final XFile? image = await _imagePicker.pickVideo(source: imageSource);
    return image != null ? File(image.path) : null;
  }
}
