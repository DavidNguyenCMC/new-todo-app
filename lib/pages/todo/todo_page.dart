// import 'package:flutter/material.dart';
// import 'package:fluttercontroller/fluttercontroller.dart';
// import 'package:todo_app/common/resources/index.dart';
// import 'package:todo_app/common/widgets/content_bundle.dart';
// import 'package:todo_app/common/widgets/default_app_bar.dart';
// import 'package:todo_app/common/widgets/spacing.dart';
// import 'package:todo_app/pages/todo/bloc/todo_state.dart';
// import 'package:todo_app/pages/todo/helper/task_options.dart';
//
// import '../../common/enums/status.dart';
// import '../../common/widgets/dialogs/loading_dialog.dart';
// import '../../common/widgets/search_text_field.dart';
// import '../../common/widgets/toast/toast.dart';
// import '../../di/injection.dart';
// import '../../models/task.dart';
// import '../../routes/app_routes.dart';
// import '../widgets/detail_option_widget.dart';
// import '../widgets/task_list_widget.dart';
// import 'bloc/todo_cubit.dart';
//
// class TodoPage extends StatefulWidget {
//   const TodoPage({Key? key}) : super(key: key);
//
//   @override
//   State<TodoPage> createState() => _TodoPageState();
// }
//
// class _TodoPageState extends State<TodoPage> {
//   final controller = getIt<TodoCubit>();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => controller..initData(),
//       child: BlocConsumer<TodoCubit, TodoState>(
//         listener: _handleStateListener,
//         builder: (_, state) {
//           return Scaffold(
//             appBar: DefaultAppBar(
//               titleText: Strings.localized.todo,
//               trailingActions: [
//                 IconButton(onPressed: _onSortTapped, icon: Icon(Icons.sort))
//               ],
//             ),
//             body: Stack(
//               children: [
//                 Column(
//                   children: [
//                     const Spacing(),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: SearchTextField(
//                         hintText: Strings.localized.search,
//                         onChanged: (name) => controller.onSearchTasks(name),
//                       ),
//                     ),
//                     const Spacing(),
//                     Expanded(
//                       child: ContentBundle(
//                         onRefresh: (_) => controller.onRefresh(),
//                         status: state.dataStatus,
//                         child: TaskListWidget(
//                           tasks: state.tasks,
//                           onItemTapped: (task) => _onItemTapped(context, task),
//                           onChecked: (task, val) => _onCheck(context, task, val),
//                           onEditTapped: (task) => _onEditTapped(context, task),
//                           onDeleteTapped: (task) => _onDeleteTapped(context, task),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: FloatingActionButton(
//                       onPressed: () => _onAddTapped(context),
//                       child: Icon(Icons.add),
//                       backgroundColor: AppColors.primaryColor,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _onSortTapped() {
//     showModalBottomSheet<dynamic>(
//       context: context,
//       backgroundColor: AppColors.transparent,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return TaskEditOptionsModal<SortOption>(
//             onPress: (_, option) => _onSortOptionTapped(option.key), options: getSortTaskOptions());
//       },
//     );
//   }
//
//   void _onSortOptionTapped(SortOption option) {
//     switch (option) {
//       case SortOption.sortByTitle:
//         controller.onSortByTitle();
//         break;
//       case SortOption.sortByDesc:
//         controller.onSortByDesc();
//         break;
//       case SortOption.sortByDate:
//         controller.onSortByDate();
//         break;
//     }
//   }
//
//   void _handleStateListener(context, state) {
//     switch (state.status) {
//       case RequestStatus.initial:
//         break;
//       case RequestStatus.requesting:
//         IgnoreLoadingIndicator().show(context);
//         break;
//       case RequestStatus.success:
//         IgnoreLoadingIndicator().hide(context);
//         break;
//       case RequestStatus.failed:
//         IgnoreLoadingIndicator().hide(context);
//         showFailureMessage(context, state.message ?? '');
//         break;
//     }
//   }
//
//   void _onCheck(BuildContext context, Task? task, bool value) {
//     controller.updateTaskStatus(task, value);
//   }
//
//   void _onAddTapped(BuildContext context) {
//     Navigator.pushNamed(context, RouterName.createTask);
//   }
//
//   void _onItemTapped(BuildContext context, Task? task) {
//     Navigator.pushNamed(context, RouterName.taskDetail, arguments: task);
//   }
//
//   void _onEditTapped(BuildContext context, Task? task) {
//     Navigator.pushNamed(context, RouterName.editTask, arguments: task);
//   }
//
//   void _onDeleteTapped(BuildContext context, Task? task) {
//     controller.deleteTask(task);
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/common/resources/index.dart';
import 'package:todo_app/common/widgets/content_bundle.dart';
import 'package:todo_app/common/widgets/default_app_bar.dart';
import 'package:todo_app/common/widgets/spacing.dart';
import 'package:todo_app/pages/todo/controller/todo_controller.dart';
import 'package:todo_app/pages/todo/helper/task_options.dart';

import '../../common/enums/status.dart';
import '../../common/widgets/dialogs/loading_dialog.dart';
import '../../common/widgets/search_text_field.dart';
import '../../common/widgets/toast/toast.dart';
import '../../models/task.dart';
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

  void _onCheck(BuildContext context, Task? task, bool value) {
    _controller.updateTaskStatus(task, value);
  }

  void _onAddTapped(BuildContext context) {
    Navigator.pushNamed(context, RouterName.createTask);
  }

  void _onItemTapped(BuildContext context, Task? task) {
    Navigator.pushNamed(context, RouterName.taskDetail, arguments: task);
  }

  void _onEditTapped(BuildContext context, Task? task) {
    Navigator.pushNamed(context, RouterName.editTask, arguments: task);
  }

  void _onDeleteTapped(BuildContext context, Task? task) {
    _controller.deleteTask(task);
  }
}
