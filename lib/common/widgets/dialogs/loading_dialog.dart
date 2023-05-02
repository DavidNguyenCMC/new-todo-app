import 'package:flutter/material.dart';

class IgnoreLoadingIndicator {
  factory IgnoreLoadingIndicator() {
    return _dialog;
  }

  IgnoreLoadingIndicator._internal();

  static final IgnoreLoadingIndicator _dialog = IgnoreLoadingIndicator._internal();

  final GlobalKey<State> _key = GlobalKey<State>();

  bool isShowing = false;

  Future<void> show(BuildContext context) async {
    if (isShowing) {
      return;
    }
    isShowing = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          key: _key,
          onWillPop: () async => false,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void hide(BuildContext context) {
    if (!isShowing) {
      return;
    }
    isShowing = false;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
