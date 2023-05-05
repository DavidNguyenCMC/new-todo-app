import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/common/enums/status.dart';
import 'package:todo_app/common/resources/index.dart';
import 'package:todo_app/common/widgets/content_bundle.dart';
import 'package:todo_app/common/widgets/default_app_bar.dart';
import 'package:todo_app/common/widgets/dialogs/loading_dialog.dart';
import 'package:todo_app/common/widgets/search_text_field.dart';
import 'package:todo_app/common/widgets/spacing.dart';
import 'package:todo_app/common/widgets/toast/toast.dart';
import 'package:todo_app/domain/entities/task_entity.dart';
import 'package:todo_app/presentations/pages/todo/controller/todo_controller.dart';
import 'package:todo_app/presentations/pages/todo/helper/task_options.dart';

import '../../routes/app_routes.dart';
import '../widgets/detail_option_widget.dart';
import '../widgets/task_list_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodoController _controller = Get.find();

  @override
  void initState() {
    super.initState();

    _controller.state.listen((status) {
      if (!mounted) {
        return;
      }
      _handleStateListener(status.status);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.initData();
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
        titleText: Strings.localized.todo,
        trailingActions: [IconButton(onPressed: _onSortTapped, icon: Icon(Icons.sort))],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const Spacing(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchTextField(
                  hintText: Strings.localized.search,
                  onChanged: (name) => _controller.onSearchTasks(name),
                ),
              ),
              const Spacing(),
              Expanded(
                child: Obx(
                  () {
                    return ContentBundle(
                      onRefresh: (_) => _controller.onRefresh(),
                      status: _controller.state.value.dataStatus,
                      child: TaskListWidget(
                        tasks: _controller.state.value.tasks,
                        onItemTapped: (task) => _onItemTapped(context, task),
                        onChecked: (task, val) => _onCheck(context, task, val),
                        onEditTapped: (task) => _onEditTapped(context, task),
                        onDeleteTapped: (task) => _onDeleteTapped(context, task),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                tooltip: 'AddTaskButton',
                onPressed: () => _onAddTapped(context),
                child: Icon(Icons.add),
                backgroundColor: AppColors.primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onSortTapped() {
    showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return TaskEditOptionsModal<SortOption>(
            onPress: (_, option) => _onSortOptionTapped(option.key), options: getSortTaskOptions());
      },
    );
  }

  void _onSortOptionTapped(SortOption option) {
    switch (option) {
      case SortOption.sortByTitle:
        _controller.onSortByTitle();
        break;
      case SortOption.sortByDesc:
        _controller.onSortByDesc();
        break;
      case SortOption.sortByDate:
        _controller.onSortByDate();
        break;
    }
  }

  void _handleStateListener(RequestStatus status) {
    switch (status) {
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
        showFailureMessage(context, _controller.state.value.message ?? '');
        break;
    }
  }

  void _onCheck(BuildContext context, TaskEntity? task, bool value) {
    _controller.updateTaskStatus(task, value);
  }

  void _onAddTapped(BuildContext context) {
    Navigator.pushNamed(context, RouterName.createTask);
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
