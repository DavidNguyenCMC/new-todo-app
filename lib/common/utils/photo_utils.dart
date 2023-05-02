import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as IMG;

String? getPhotoName(String? url) {
  if (url != null && url.contains('http')) {
    return url.split('/').last.replaceAll('sm_', '');
  }
  return url;
}

Future<Uint8List?> reduceImageQualityAndSize(Uint8List? image, [int reduceToQuality = 10]) async {
  if (image == null) {
    return null;
  }

  int maxInBytes = 20000;
  Uint8List resizedData = Uint8List.fromList(image);

  IMG.Image? img = await IMG.decodeImage(image);
  int size = await image.lengthInBytes;
  int quality = 100;

  print("size max: " + maxInBytes.toString());
  print("size before: " + size.toString() + " bytes");

  // while (size > maxInBytes && quality > reduceToQuality) {
  //   // reduce image size about 10% of image, until the size is less than the maximum limit
  //   quality = (quality - (quality * (reduceToQuality / 100))).toInt();
  //   int width = img!.width - (img.width * (reduceToQuality/100)).toInt();
  //   IMG.Image resized = await IMG.copyResize(img, width: width);
  //   resizedData =
  //   await Uint8List.fromList(IMG.encodeJpg(resized, quality: quality));
  //   size = await resizedData.lengthInBytes;
  //   img = resized;
  // }

  quality = (quality - (quality * (reduceToQuality / 100))).toInt();
  int width = img!.width - (img.width * (reduceToQuality/100)).toInt();
  IMG.Image resized = await IMG.copyResize(img, width: 128);
  resizedData =
  await Uint8List.fromList(IMG.encodeJpg(resized, quality: quality));
  size = await resizedData.lengthInBytes;
  img = resized;

  print("size after: " + size.toString() + " bytes");

  return resizedData;
}