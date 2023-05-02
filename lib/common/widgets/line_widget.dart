import 'package:flutter/material.dart';

import '../resources/index.dart';

class LineWidget extends StatelessWidget {
  const LineWidget({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.2,
      color: color ?? AppColors.gray100,
    );
  }
}
