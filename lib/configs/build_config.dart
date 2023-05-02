import 'package:injectable/injectable.dart';

@lazySingleton
class BuildConfig {
  static const bool debugLog = true;
  static const String kDefaultAppName = 'Todo App';
}
