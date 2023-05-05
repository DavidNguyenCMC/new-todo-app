import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet }

DeviceType getDeviceType() {
  final MediaQueryData data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 550 ? DeviceType.mobile : DeviceType.tablet;
}
