import 'package:flutter/material.dart';

import '../resources/index.dart';


class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    Key? key,
    required this.isSelected,
    this.onChanged,
    this.color,
    this.iconChecked,
    this.iconUnChecked,
  }) : super(key: key);

  final bool isSelected;
  final Function(bool value)? onChanged;
  final Color? color;
  final Widget? iconChecked;
  final Widget? iconUnChecked;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _onChangeStatus,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashColor:  Colors.transparent,
      icon: isSelected
          ? (iconChecked ?? AssetImages.iconCheckboxChecked.toSvg(color: color))
          : (iconUnChecked ?? AssetImages.iconCheckboxUnchecked.toSvg(color: color)),
    );
  }

  void _onChangeStatus() {
    onChanged?.call(!isSelected);
  }
}
