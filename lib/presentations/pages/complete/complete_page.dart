import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/common/enums/status.dart';
import 'package:todo_app/common/resources/asset_strings.dart';
import 'package:todo_app/common/widgets/content_bundle.dart';
import 'package:todo_app/common/widgets/default_app_bar.dart';
import 'package:todo_app/common/widgets/dialogs/loading_dialog.dart';
import 'package:todo_app/common/widgets/spacing.dart';
import 'package:todo_app/common/widgets/toast/toast.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/presentations/pages/complete/controller/complete_controller.dart';
import '../../routes/app_routes.dart';
import '../widgets/task_list_widget.dart';

class CompletePage extends StatefulWidget {
  const CompletePage({Key? key}) : super(key: key);

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  final CompleteController _controller = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.initData();
    });

    _controller.state.listen((state) {
      _handleStateListener(state);
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleText: Strings.localized.completed,
      ),
      body: Container(
        child: Column(
          children: [
            const Spacing(),
            Expanded(
              child: Obx(
                () => ContentBundle(
                  onRefresh: (_) => _controller.onRefresh(),
                  status: _controller.state.value.dataStatus,
                  child: TaskListWidget(
                    tasks: _controller.state.value.tasks,
                    showCheckBox: false,
                    onItemTapped: (task) => _onItemTapped(context, task),
                    onEditTapped: (task) => _onEditTapped(context, task),
                    onDeleteTapped: (task) => _onDeleteTapped(context, task),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStateListener(state) {
    switch (state.status) {
      case RequestStatus.initial:
        break;
      case RequestStatus.requesting:
        IgnoreLoadingIndicator().show(context);
        break;
      case RequestStatus.success:
        IgnoreLoadingIndicator().hide(context);
        break;
      case RequestStatus.failed:
        IgnoreLoadingIndicator().hide(context);
        showFailureMessage(context, state.message ?? '');
        break;
    }
  }

  void _onItemTapped(BuildContext context, TaskEntity? task) {
    Navigator.pushNamed(context, RouterName.taskDetail, arguments: task);
  }

  void _onEditTapped(BuildContext context, TaskEntity? task) {
    Navigator.pushNamed(context, RouterName.editTask, arguments: task);
  }

  void _onDeleteTapped(BuildContext context, TaskEntity? task) {
    _controller.deleteTask(task);
  }
}
