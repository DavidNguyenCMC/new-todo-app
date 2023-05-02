import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet }

DeviceType getDeviceType() {
  if (WidgetsBinding.instance?.window != null) {
    final MediaQueryData data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return data.size.shortestSide < 550 ? DeviceType.mobile : DeviceType.tablet;
  }
  return DeviceType.mobile;
}