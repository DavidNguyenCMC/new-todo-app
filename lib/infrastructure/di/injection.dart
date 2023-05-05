import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/configs/grpc_config.dart';
import 'package:todo_app/data/repository_implement/task_repository_implement.dart';
import 'package:todo_app/data/service/local/datasource/task_local_service_implement.dart';
import 'package:todo_app/data/service/local/keychain/shared_prefs.dart';
import 'package:todo_app/data/service/network/firebase/task_firebase_service_implement.dart';
import 'package:todo_app/data/service/network/grpc/task_grpc_service_implement.dart';
import 'package:todo_app/data/service/task_local_service.dart';
import 'package:todo_app/data/service/task_service.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';
import 'package:todo_app/domain/usecase/create_task_usecase.dart';
import 'package:todo_app/domain/usecase/delete_task_usecase.dart';
import 'package:todo_app/domain/usecase/get_cached_tasks_usecase.dart';
import 'package:todo_app/domain/usecase/get_tasks_usecase.dart';
import 'package:todo_app/domain/usecase/search_task_usecase.dart';
import 'package:todo_app/domain/usecase/update_task_usecase.dart';
import 'package:todo_app/presentations/pages/complete/controller/complete_controller.dart';
import 'package:todo_app/presentations/pages/create_task/controller/create_task_controller.dart';
import 'package:todo_app/presentations/pages/inprogress/controller/inprogress_controller.dart';
import 'package:todo_app/presentations/pages/todo/controller/todo_controller.dart';

Future<void> injectDependencies() async {
  await Get.putAsync<SharedPrefs>(() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return SharedPrefs(sharedPreferences);
  });
  Get.lazyPut<TaskService>(() => kIsWeb
      ? TaskFirebaseServiceImpl()
      : TaskGrpcService(clientChannel: GrpcConfig().clientChannel));
  Get.lazyPut<TaskLocalService>(() => TaskLocalServiceImplement(Get.find<SharedPrefs>()));
  Get.lazyPut<TaskRepository>(() => TaskRepositoryImpl(
      userService: Get.find<TaskService>(), taskLocalDatasource: Get.find<TaskLocalService>()));
  Get.lazyPut<GetTaskUseCase>(() => GetTaskUseCase(Get.find<TaskRepository>()));
  Get.lazyPut<GetCachedTasksUseCase>(() => GetCachedTasksUseCase(Get.find<TaskRepository>()));
  Get.lazyPut<CreateTaskUseCase>(() => CreateTaskUseCase(Get.find<TaskRepository>()));
  Get.lazyPut<UpdateTaskUseCase>(() => UpdateTaskUseCase(Get.find<TaskRepository>()));
  Get.lazyPut<DeleteTaskUseCase>(() => DeleteTaskUseCase(Get.find<TaskRepository>()));
  Get.lazyPut<SearchTaskUseCase>(() => SearchTaskUseCase(Get.find<TaskRepository>()));
  _injectController();
}

void _injectController() {
  Get.lazyPut(() => TodoController(
        Get.find<GetTaskUseCase>(),
        Get.find<GetCachedTasksUseCase>(),
        Get.find<DeleteTaskUseCase>(),
        Get.find<SearchTaskUseCase>(),
        Get.find<UpdateTaskUseCase>(),
      ));
  Get.lazyPut(() => InProgressController(Get.find<TaskRepository>()));
  Get.lazyPut(() => CompleteController(Get.find<TaskRepository>()));
  Get.lazyPut(
      () => CreateTaskController(Get.find<CreateTaskUseCase>(), Get.find<UpdateTaskUseCase>()));
}
