import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../common/resources/index.dart';

// ignore_for_file: always_specify_types
// ignore: avoid_classes_with_only_static_members
class PlatformImagePicker {
  static Future<XFile?> show(BuildContext context) async {
    if (kIsWeb) {
      Uint8List? fromPicker = await ImagePickerWeb.getImageAsBytes();
      XFile? file;
      if (fromPicker != null) {
        file = XFile.fromData(fromPicker);
      }
      return file;
    }
    final ImageSource? imageSource = await _showImageSourceActionSheet(context);
    final ImagePicker picker = ImagePicker();
    try {
      if (imageSource != null) {
        return picker.pickImage(source: imageSource, imageQuality: 20);
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<ImageSource?> _showImageSourceActionSheet(
      BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: Text(Strings.localized.camera),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: Text(Strings.localized.gallery),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            )
          ],
        ),
      );
    } else {
      return showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) => Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(Strings.localized.camera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: Text(Strings.localized.gallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      );
    }
  }
}
