
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/index.dart';
import '../utils/extensions/extension.dart';
import 'date_time_picker.dart';
import 'title_text_field.dart';

enum DateTimeInputMode { date, time, datetime }

enum IconAppearanceMode { prefix, suffix }

class DateTimeInputController with ChangeNotifier {
  DateTimeInputController({DateTime? value}) : _value = value;

  DateTime? _value;

  DateTime? get value => _value;

  set value(DateTime? value) {
    _value = value;
    notifyListeners();
  }
}

class DateTimeInput extends StatefulWidget {
  const DateTimeInput({
    Key? key,
    required this.title,
    this.hintText,
    this.style,
    this.enable = true,
    this.onDateTimeSelected,
    this.initialValue,
    this.min,
    this.max,
    this.mode = DateTimeInputMode.datetime,
    this.mandatory = false,
    this.background,
    this.iconAppearanceMode = IconAppearanceMode.suffix,
    this.iconColor,
    this.controller,
    this.validator,
    this.pickerTitle,
    String? dateFormat,
    this.autoDispose = true,
  })  : format = dateFormat ??
            (mode == DateTimeInputMode.datetime
                ? DateTimeFormat.DD_MMM_YYYY_HH_MM
                : mode == DateTimeInputMode.time
                    ? DateTimeFormat.HH_MM_A
                    : DateTimeFormat.DD_MM_YYYY),
        super(key: key);

  final String title;
  final String? hintText;
  final TextStyle? style;
  final bool enable;
  final bool mandatory;

  final Color? background;
  final IconAppearanceMode iconAppearanceMode;
  final Color? iconColor;

  final DateTime? initialValue;
  final DateTime? min;
  final DateTime? max;

  final String format;
  final DateTimeInputMode mode;

  final Function(DateTime?)? onDateTimeSelected;
  final DateTimeInputController? controller;
  final FormFieldValidator<DateTime>? validator;
  final String? pickerTitle;
  final bool autoDispose;

  @override
  DateTimeInputState createState() => DateTimeInputState();
}

class DateTimeInputState extends State<DateTimeInput> {
  late TextEditingController _textEditingController;
  late DateTimeInputController _dateTimeInputController;
  final List<int> _availableHours = List<int>.generate(24, (int index) => index);
  final List<int> _availableMinutes = <int>[0, 15, 30, 45];

  @override
  void initState() {
    super.initState();

    _dateTimeInputController =
        widget.controller ?? DateTimeInputController(value: widget.initialValue);
    _textEditingController =
        TextEditingController(text: _dateTimeInputController.value?.format(widget.format));

    _dateTimeInputController.addListener(() {
      _textEditingController.text = _dateTimeInputController.value?.format(widget.format) ?? '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.autoDispose) {
      _dateTimeInputController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget icon = UnconstrainedBox(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8),
        child: (widget.mode != DateTimeInputMode.time)
            ? AssetImages.icCalendar.toSvg(
                color: (widget.iconColor ?? AppColors.black).withOpacity(widget.enable ? 1 : 0.3))
            : AssetImages.icTime.toSvg(
                color: (widget.iconColor ?? AppColors.black).withOpacity(widget.enable ? 1 : 0.3)),
      ),
    );
    return TitleTextField(
      mandatory: widget.mandatory,
      title: widget.title,
      hintText: widget.hintText,
      style: widget.style,
      controller: _textEditingController,
      enable: widget.enable,
      readOnly: true,
      maxLines: 1,
      autocorrect: false,
      onTap: () => _onSelectDateTime(context),
      prefixIcon: widget.iconAppearanceMode == IconAppearanceMode.prefix ? icon : null,
      suffixIcon: widget.iconAppearanceMode == IconAppearanceMode.suffix ? icon : null,
      background: widget.background,
      validator: (_) => widget.validator?.call(_dateTimeInputController.value),
    );
  }

  void setDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      setState(() {
        _dateTimeInputController.value = dateTime;
      });
    }
  }

  Future<void> _onSelectDateTime(BuildContext context) async {
    if (!widget.enable) {
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());

    _onSelectDateTimePicker(context, mode: widget.mode, onSelected: (DateTime? dateTime) {
      if (dateTime != null) {
        setState(() {
          _dateTimeInputController.value = dateTime;
        });
        widget.onDateTimeSelected?.call(dateTime);
      }
    });
  }

  Future<DateTime?> _onSelectDateTimePicker(BuildContext context,
      {required Function(DateTime? datetime) onSelected,
      DateTimeInputMode mode = DateTimeInputMode.datetime}) async {
    CupertinoDatePickerMode pickerMode;
    switch (mode) {
      case DateTimeInputMode.date:
        pickerMode = CupertinoDatePickerMode.date;
        break;
      case DateTimeInputMode.time:
        pickerMode = CupertinoDatePickerMode.time;
        break;
      case DateTimeInputMode.datetime:
        pickerMode = CupertinoDatePickerMode.dateAndTime;
        break;
    }
    final DateTime defaultDate = DateTime.now();
    final DateTime defaultMin = defaultDate.subtract(const Duration(seconds: 1));
    final DateTime defaultMax = defaultDate.add(const Duration(hours: 87600));
    final DateTime minDate = widget.min ?? defaultMin;
    DateTime initDate = _dateTimeInputController.value ?? defaultDate;
    if (initDate.compareTo(minDate) <= 0) {
      initDate = minDate;
    }
    showDateTimePicker(
      context,
      mode: pickerMode,
      initValue: initDate,
      min: minDate,
      max: widget.max ?? defaultMax,
      onSelected: onSelected,
      title: widget.pickerTitle,
    );
    return null;
  }
}
