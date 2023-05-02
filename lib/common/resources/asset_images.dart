import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetImages {
  static const String imgEmpty = 'assets/images/png/img_empty.png';
  static const String imgDefault = 'assets/images/png/default.png';
  static const String iconCheckboxUnchecked = 'assets/images/svg/ic_checkbox_unchecked.svg';
  static const String iconCheckboxChecked = 'assets/images/svg/ic_checkbox_checked.svg';
  static const String iconTrash = 'assets/images/svg/ic_trash.svg';
  static const String iconAdd = 'assets/images/svg/ic_add.svg';
  static const String iconEdit = 'assets/images/svg/ic_edit.svg';
  static const String iconEmpty = 'assets/images/svg/ic_empty_state.svg';
  static const String imgCameraPrimary = 'assets/images/svg/ic_camera_primary.svg';
  static const String icTime = 'assets/images/svg/ic_time.svg';
  static const String icCalendar = 'assets/images/svg/ic_calendar.svg';
}

extension ConvertToImage on String {
  Widget toSvg({
    BuildContext? context,
    double width = 24,
    double? height,
    double padding = 0,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: SvgPicture.asset(
        this,
        width: width,
        height: height ?? width,
        color: color,
        cacheColorFilter: true,
      ),
    );
  }

  AssetImage toImage({
    double width = 24,
    double? height,
  }) {
    return AssetImage(this);
  }
}
