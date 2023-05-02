import 'package:flutter/material.dart';
import 'package:todo_app/common/resources/index.dart';
import 'package:todo_app/common/utils/extensions/extension.dart';
import 'package:todo_app/common/widgets/default_app_bar.dart';
import 'package:todo_app/common/widgets/spacing.dart';
import 'package:todo_app/routes/app_routes.dart';

import '../../common/widgets/default_image_widget.dart';
import '../../models/task.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Task? task = context.getRouteArguments();
    return Scaffold(
      appBar: DefaultAppBar(
        titleText: Strings.localized.taskDetail,
        trailingActions: [
          IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, RouterName.editTask, arguments: task);
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DefaultImageWidget(
                  task?.image ?? '',
                  // imageFile: state.image,
                  height: 100,
                  width: 100,
                  radius: 50,
                ),
                const Spacing(),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.localized.name,
                        style: TextStyles.blackNormalBold,
                      ),
                      const TitleSpacing(),
                      Text(task?.name ?? 'NA', style: TextStyles.blackSmallRegular),
                      const Spacing(),
                      Text(
                        Strings.localized.description,
                        style: TextStyles.blackNormalBold,
                      ),
                      const TitleSpacing(),
                      Text(task?.desc ?? 'NA', style: TextStyles.blackSmallRegular),
                      const Spacing(),
                      Text(
                        Strings.localized.createdAt,
                        style: TextStyles.blackNormalBold,
                      ),
                      const TitleSpacing(),
                      Text(task?.createAt?.toMMDDYYHHMMAString() ?? 'NA',
                          style: TextStyles.blackSmallRegular),
                      const Spacing(),
                      Text(
                        Strings.localized.expiredAt,
                        style: TextStyles.blackNormalBold,
                      ),
                      const TitleSpacing(),
                      Text(task?.expiredAt?.toMMDDYYHHMMAString() ?? 'NA',
                          style: TextStyles.blackSmallRegular),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
