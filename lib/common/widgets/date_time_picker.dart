import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/index.dart';
import 'spacing.dart';

void showDateTimePicker(
  BuildContext context, {
  DateTime? initValue,
  DateTime? min,
  DateTime? max,
  CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
  String? title,
  required Function(DateTime?) onSelected,
  Function()? onReset,
}) {
  DateTime? selectedDate = initValue ?? DateTime.now();
  showCupertinoModalPopup(
    context: context,
    builder: (_) => Material(
      color: AppColors.transparent,
      child: Container(
        decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius:
                BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (onReset != null && initValue != null)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onReset.call();
                    },
                    child: Text(
                      Strings.localized.clear,
                      style: TextStyles.blackNormalSemiBold,
                    ),
                  )
                else
                  const SizedBox(width: 16),
                Text(
                  title ?? Strings.localized.selectADate,
                  style: TextStyles.blackNormalSemiBold,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const DividerDetail(color: AppColors.gray500, height: 1),
            Flexible(
              child: SizedBox(
                height: 180,
                child: CupertinoDatePicker(
                    initialDateTime: selectedDate,
                    mode: mode,
                    minimumDate: min,
                    maximumDate: max,
                    onDateTimeChanged: (val) {
                      selectedDate = val;
                    }),
              ),
            ),
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onSelected.call(selectedDate);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                child: Text(
                  Strings.localized.apply,
                  style: TextStyles.whiteNormalSemiBold,
                ),
              ),
            ),
            const Spacing(),
          ],
        ),
      ),
    ),
  );
}
