import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/local/keychain/shared_prefs.dart';
import 'package:todo_app/data/service/grpc/task_grpc_service.dart';
import 'package:todo_app/data/task/task_service.dart';
import 'package:todo_app/pages/complete/controller/complete_controller.dart';
import 'package:todo_app/pages/create_task/controller/create_task_controller.dart';
import 'package:todo_app/pages/inprogress/controller/inprogress_controller.dart';
import 'package:todo_app/pages/todo/controller/todo_controller.dart';
import 'package:todo_app/repositories/task_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../configs/grpc_config.dart';
import '../data/local/datasource/task_local_datasource.dart';

Future<void> injectDependencies() async {
  await Get.putAsync<SharedPrefs>(() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return SharedPrefs(sharedPreferences);
  });
  Get.lazyPut<TaskService>(() => kIsWeb
      ? TaskServiceImpl()
      : TaskGrpcService(clientChannel: GrpcConfig().clientChannel));
  Get.lazyPut<TaskLocalDatasource>(
      () => TaskLocalDatasourceImpl(Get.find<SharedPrefs>()));
  Get.lazyPut<TaskRepository>(() => TaskRepositoryImpl(
      userService: Get.find<TaskService>(),
      taskLocalDatasource: Get.find<TaskLocalDatasource>()));
  _injectController();
}

void _injectController() {
  Get.lazyPut(() => TodoController(Get.find<TaskRepository>()));
  Get.lazyPut(() => InProgressController(Get.find<TaskRepository>()));
  Get.lazyPut(() => CompleteController(Get.find<TaskRepository>()));
  Get.lazyPut(() => CreateTaskController(Get.find<TaskRepository>()));
}
