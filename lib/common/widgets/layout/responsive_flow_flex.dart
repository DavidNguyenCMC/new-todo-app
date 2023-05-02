import 'package:flutter/material.dart';
import 'package:todo_app/common/utils/extensions/extension.dart';

import 'row_flex.dart';

class ResponsiveFlowFlex extends StatelessWidget {
  const ResponsiveFlowFlex({
    Key? key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.verticalSpacing = 20.0,
    this.horizontalSpacing = 16.0,
    this.reverse = false,
    this.horizontalFlexes = const <int>[],
  }) : super(key: key);

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double verticalSpacing;
  final double horizontalSpacing;
  final bool reverse;
  final List<int> horizontalFlexes;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    children.asMap().forEach((int index, Widget value) {
      items.add(value);
      if (index < children.length - 1) {
        items.add(SizedBox(
          height: verticalSpacing,
        ));
      }
    });

    if (context.isLandscape()) {
      return !reverse
          ? RowFlex(
              crossAxisAlignment: crossAxisAlignment,
              children: children,
              spacing: horizontalSpacing,
              flexItems: horizontalFlexes,
            )
          : Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: items,
            );
    }

    return !reverse
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: items,
          )
        : RowFlex(
            crossAxisAlignment: crossAxisAlignment,
            children: children,
            spacing: horizontalSpacing,
            flexItems: horizontalFlexes,
          );
  }
}

class ResponsiveFlow extends StatelessWidget {
  const ResponsiveFlow({
    Key? key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.verticalSpacing = 20.0,
    this.horizontalSpacing = 16.0,
    this.reverse = false,
  }) : super(key: key);

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double verticalSpacing;
  final double horizontalSpacing;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    children.asMap().forEach((int index, Widget value) {
      items.add(value);
      if (index < children.length - 1) {
        items.add(SizedBox(
          width: horizontalSpacing,
          height: verticalSpacing,
        ));
      }
    });

    if (context.isLandscape()) {
      return !reverse
          ? Row(
              crossAxisAlignment: crossAxisAlignment,
              children: items,
            )
          : Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: items,
            );
    }

    return !reverse
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: items,
          )
        : Row(
            crossAxisAlignment: crossAxisAlignment,
            children: items,
          );
  }
}
