import 'package:flutter/material.dart';
import 'package:todo_app/presentations/pages/create_task/create_task_page.dart';
import 'package:todo_app/presentations/pages/detail/task_detail_page.dart';

import '../pages/main/main_page.dart';

// ignore_for_file: avoid_classes_with_only_static_members
class RouterName {
  static const String bootstrap = '/';
  static const String start = '/start';
  static const String mainPage = '/main';
  static const String introduction = '/introduction';
  static const String login = '/login';

  static const String taskDetail = '/taskDetail';
  static const String createTask = '/createTask';
  static const String editTask = '/editTask';
}

class AppRoutes {
  static Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.bootstrap:
        return _materialRoute(settings, const MainPage());
      case RouterName.taskDetail:
        return _materialRoute(settings, const TaskDetailPage());
      case RouterName.createTask:
      case RouterName.editTask:
        return _materialRoute(settings, const CreateTaskPage());
      default:
        return _materialRoute(settings, const MainPage());
    }
  }

  static Route<dynamic> _materialRoute(RouteSettings settings, Widget view) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => view,
    );
  }
}
