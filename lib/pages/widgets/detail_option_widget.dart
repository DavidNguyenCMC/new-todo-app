import 'package:flutter/material.dart';

import '../../common/resources/index.dart';
import '../../common/widgets/spacing.dart';

class DetailOption<K> {
  DetailOption({
    required this.key,
    required this.title,
    required this.icon,
    this.color = AppColors.black,
  });

  final K key;
  final String title;
  final Widget icon;
  final Color color;
}

class TaskEditOptionsModal<K> extends StatelessWidget {
  const TaskEditOptionsModal({Key? key, required this.onPress, required this.options})
      : super(key: key);

  final List<DetailOption<K>> options;
  final Function(BuildContext, DetailOption<K>) onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Material(
                  color: AppColors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _onClosePressed(context),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ...options.map((DetailOption<K> option) {
                      return Material(
                        color: AppColors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            onPress(context, option);
                          },
                          child: Ink(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              children: <Widget>[
                                const Spacing(),
                                option.icon,
                                const Spacing(),
                                Text(
                                  option.title,
                                  style: TextStyles.blackNormalMedium.copyWith(color: option.color),
                                ),
                                const Spacing(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const Spacing(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _onClosePressed(BuildContext context) {
    Navigator.pop(context);
  }
}