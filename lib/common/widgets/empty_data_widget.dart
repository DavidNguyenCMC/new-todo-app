import 'package:flutter/material.dart';

import '../resources/index.dart';
import 'spacing.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(AssetImages.imgEmpty, height: 90),
        const Spacing(),
        const Text('You currently have no items'),
      ],
    );
  }
}
