import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/configs/firebase_config.dart';
import 'package:todo_app/di/injection.dart';

import 'configs/build_config.dart';
import 'pages/app.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? FirebaseOptions(
            apiKey: FirebaseConfigurations.apiKey,
            appId: FirebaseConfigurations.appId,
            messagingSenderId: FirebaseConfigurations.messagingSenderId,
            projectId: FirebaseConfigurations.projectId,
            authDomain: FirebaseConfigurations.authDomain,
            databaseURL: FirebaseConfigurations.databaseURL,
            measurementId: FirebaseConfigurations.measurementId,
            storageBucket: FirebaseConfigurations.storageBucket,
          )
        : null,
  );
  await injectDependencies();
  if (BuildConfig.debugLog) {
    Bloc.observer = AppBlocObserver();
  }
  runApp(const App());
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
