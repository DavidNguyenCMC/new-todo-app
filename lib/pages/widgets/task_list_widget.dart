import 'package:flutter/material.dart';
import 'package:todo_app/common/utils/extensions/extension.dart';
import 'package:todo_app/common/widgets/default_image_widget.dart';

import '../../common/resources/index.dart';
import '../../common/widgets/app_checkbox.dart';
import '../../common/widgets/spacing.dart';
import '../../models/task.dart';
import '../todo/helper/task_options.dart';
import 'detail_option_widget.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    Key? key,
    required this.tasks,
    this.onItemTapped,
    this.onChecked,
    this.onEditTapped,
    this.onDeleteTapped,
    this.showCheckBox = true,
  }) : super(key: key);

  final List<Task>? tasks;
  final Function(Task? task)? onItemTapped;
  final Function(Task? task, bool value)? onChecked;
  final Function(Task? task)? onEditTapped;
  final Function(Task? task)? onDeleteTapped;
  final bool showCheckBox;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (tasks ?? []).length,
      itemBuilder: (context, index) {
        final task = tasks?[index];
        return TaskItemWidget(
          task: task,
          onChecked: onChecked,
          onItemTapped: onItemTapped,
          onTaskDetailOptionTapped: _onTaskDetailOptionTapped,
        );
      },
    );
  }

  void _onTaskDetailOptionTapped(BuildContext context, Task? task) {
    showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return TaskEditOptionsModal<OptionType>(
            onPress: (_, option) => _onOptionTapped(option.key, task),
            options: getTaskOptions(task?.status));
      },
    );
  }

  void _onOptionTapped(OptionType option, Task? task) {
    switch (option) {
      case OptionType.edit:
        onEditTapped?.call(task);
        break;
      case OptionType.delete:
        onDeleteTapped?.call(task);
        break;
    }
  }
}

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    Key? key,
    this.task,
    this.onItemTapped,
    this.onTaskDetailOptionTapped,
    this.onChecked,
    this.showCheckBox = true,
  }) : super(key: key);

  final Task? task;
  final Function(Task? task)? onItemTapped;
  final Function(Task? task, bool value)? onChecked;
  final bool showCheckBox;
  final Function(BuildContext context, Task? task)? onTaskDetailOptionTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: task?.status == TaskStatus.complete ? AppColors.green400 : AppColors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () => onItemTapped?.call(task),
            borderRadius: BorderRadius.circular(6),
            child: Ink(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacing(),
                    DefaultImageWidget(
                      task?.image,
                      width: 40,
                      height: 40,
                      radius: 20,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacing(),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task?.name ?? '',
                                  style: TextStyles.blackNormalBold,
                                ),
                                const TitleSpacing(),
                                if ((task?.desc ?? '').isNotEmpty)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 17,
                                      ),
                                      const TitleSpacing(),
                                      Text(
                                        task?.desc ?? '',
                                        style: TextStyles.blackSmallRegular,
                                      ),
                                    ],
                                  ),
                                const TitleSpacing(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: AppColors.black,
                                      size: 17,
                                    ),
                                    const TitleSpacing(),
                                    Text(
                                      task?.createAt?.toMMDDYYHHMMAString() ?? '',
                                      style: TextStyles.blackSmallMedium,
                                    ),
                                  ],
                                ),
                                const TitleSpacing(),
                                Row(
                                  children: [
                                    Text(
                                      Strings.localized.status + ': ',
                                      style: TextStyles.blackSmallMedium,
                                    ),
                                    Text(
                                      (task?.status?.name ?? ''),
                                      style: TextStyles.greySmallBold.copyWith(
                                          color: task?.status == TaskStatus.complete
                                              ? AppColors.white
                                              : AppColors.blue),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          if (showCheckBox)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: AppCheckbox(
                                isSelected: task?.status == TaskStatus.complete,
                                onChanged: (val) => onChecked?.call(task, val),
                              ),
                            ),
                          InkWell(
                            child: Icon(Icons.more_vert_rounded),
                            onTap: () => onTaskDetailOptionTapped?.call(context, task),
                          ),
                          const Spacing(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
