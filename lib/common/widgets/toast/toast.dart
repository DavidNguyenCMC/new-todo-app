import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../resources/index.dart';

enum ToastMessageType { success, failed, waining }

void showSuccessMessage(BuildContext context, String message) {
  FToast().init(context).showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: AppColors.green500,
          ),
          child: Text(message, style: TextStyles.whiteNormalBold),
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
}

void showFailureMessage(BuildContext context, String message) {
  FToast().init(context).showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: AppColors.red500,
          ),
          // child: Text(Strings.errorPrefix + message, style: TextStyles.whiteHeaderBold),
          child: Text(message, style: TextStyles.whiteNormalBold),
        ),
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 2),
      );
}
