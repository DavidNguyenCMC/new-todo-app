import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/common/api_client/data_state.dart';
import 'package:todo_app/common/resources/index.dart';
import 'package:todo_app/common/widgets/app_checkbox.dart';
import 'package:todo_app/common/widgets/date_time_field.dart';
import 'package:todo_app/data/local/datasource/task_local_datasource.dart';
import 'package:todo_app/data/task/response_models/task_model.dart';
import 'package:todo_app/data/task/task_service.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/pages/app.dart';
import 'package:todo_app/pages/complete/controller/complete_controller.dart';
import 'package:todo_app/pages/create_task/controller/create_task_controller.dart';
import 'package:todo_app/pages/inprogress/controller/inprogress_controller.dart';
import 'package:todo_app/pages/todo/controller/todo_controller.dart';
import 'package:todo_app/pages/widgets/task_list_widget.dart';
import 'package:todo_app/repositories/task_repository.dart';

import '../unit_test/repository/task_repository_test.mocks.dart';

Future<void> runWithMock() async {
  runApp(const App());
}

@GenerateMocks([TaskRepository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final service = MockTaskService();
  final localDatasource = MockTaskLocalDatasource();
  group('end-to-end test\n', () {
    setUp(() {
      inject(service, localDatasource);
      mockData(service, localDatasource);
    });
    testWidgets('When Tap on the floating action button it should adding task\n', (tester) async {
      runWithMock();
      await tester.pumpAndSettle();

      final Finder fab = find.byTooltip('AddTaskButton');

      await tester.tap(fab);

      await tester.pumpAndSettle();

      final nameField = find.byType(TextFormField).first;
      final descField = find.byType(TextFormField).at(1);
      final dateField = find.byType(DateTimeInput).first;
      final scrollView = find.byType(SingleChildScrollView);
      await tester.enterText(nameField, 'Study');
      await tester.enterText(descField, 'Study math');
      await tester.dragUntilVisible(
        dateField,
        scrollView,
        const Offset(0, 500),
        duration: Duration(seconds: 1),
      );
      await tester.tap(dateField);
      await tester.pumpAndSettle();
      final applyBtn = find.text('Apply');
      await tester.tap(applyBtn);
      await tester.pumpAndSettle();
      final submitBtn = find.byType(TextButton);
      await tester.tap(submitBtn);
      await tester.pump();
      final items = find.text('Study');
      expect(items, findsNWidgets(3));
    });

    testWidgets('When search task by name\n', (tester) async {
      runWithMock();
      await tester.pumpAndSettle();
      final searchField = find.byType(TextFormField).first;
      await tester.enterText(searchField, 'Task test 1');
      await tester.pump(Duration(seconds: 2));
      final items = find.byType(TaskItemWidget);
      expect(items, findsWidgets);
    });

    testWidgets('When sort task by title\n', (tester) async {
      runWithMock();
      await tester.pumpAndSettle();
      final optionBtn = find.byIcon(Icons.sort);
      await tester.tap(optionBtn);
      await tester.pumpAndSettle();
      await tester.tap(find.text(Strings.localized.sortByTitle));
      await tester.pump(Duration(seconds: 1));
      final item = find.text('Task test 1').first;
      expect(item, findsAtLeastNWidgets(1));
    });

    testWidgets('When change task status to complete\n', (tester) async {
      runWithMock();
      await tester.pumpAndSettle();
      final checkBoxBtn = find.byType(AppCheckbox).first;
      await tester.tap(checkBoxBtn);
      await tester.pump(Duration(seconds: 1));
      bool widgetSelectedPredicate(Widget widget) =>
          widget is Container && (widget.decoration as BoxDecoration?)?.color == AppColors.green400;
      final item = find.byWidgetPredicate(widgetSelectedPredicate);
      expect(
        item,
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('When delete task by id\n', (tester) async {
      runWithMock();
      await tester.pumpAndSettle();
      final optionBtn = find.byIcon(Icons.more_vert_rounded).first;
      await tester.tap(optionBtn);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pump(Duration(seconds: 1));
      final item = find.text('Task test 1').first;
      expect(item, findsOneWidget);
    });
  });
}

void inject(TaskService taskService, TaskLocalDatasource taskLocalDatasource) {
  Get.lazyPut<TaskRepository>(
      () => TaskRepositoryImpl(userService: taskService, taskLocalDatasource: taskLocalDatasource));
  Get.lazyPut(() => TodoController(Get.find<TaskRepository>()));
  Get.lazyPut(() => InProgressController(Get.find<TaskRepository>()));
  Get.lazyPut(() => CompleteController(Get.find<TaskRepository>()));
  Get.lazyPut(() => CreateTaskController(Get.find<TaskRepository>()));
}

void mockData(MockTaskService taskService, MockTaskLocalDatasource taskLocalDatasource) {
  final tasks = [
    TaskModel(
      id: '2',
      name: 'Task test 2',
      desc: 'Task Desc A',
      status: TaskStatus.inprogress.rawValue,
    ),
    TaskModel(
      id: '1',
      name: 'Task test 1',
      desc: 'Task Desc B',
      status: TaskStatus.inprogress.rawValue,
    ),
  ];
  final newTask = TaskModel(
    id: '3',
    name: 'Study',
    desc: 'Study math',
    status: TaskStatus.inprogress.rawValue,
  );
  when(taskLocalDatasource.getTasks()).thenAnswer((_) => Future.value([]));

  when(taskService.getTasks()).thenAnswer((_) {
    return Future.value(DataSuccess(tasks));
  });
  when(taskService.createTask(any)).thenAnswer((_) {
    tasks.add(newTask);
    return Future.value(DataSuccess(newTask));
  });

  when(taskService.updateTask(any)).thenAnswer((_) {
    tasks.first.status = TaskStatus.complete;
    return Future.value(DataSuccess(newTask));
  });

  when(taskService.deleteTask(any)).thenAnswer((_) {
    return Future.value(DataSuccess(true));
  });

  when(taskLocalDatasource.deleteTask(any)).thenAnswer((_) {
    tasks.removeAt(0);
    return Future.value(DataSuccess(true));
  });
}
