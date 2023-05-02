import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../common/resources/index.dart';
import '../common/utils/screen_type_ultil.dart';
import '../configs/build_config.dart';
import '../di/injection.dart';
import '../generated/l10n.dart';
import '../routes/app_routes.dart';
import 'main/main_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _configOrientation(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: MaxWidthBox(
            child: child!,
            maxWidth: 800,
          ),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) {
          for (final Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        supportedLocales: S.delegate.supportedLocales,
        title: BuildConfig.kDefaultAppName,
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          backgroundColor: AppColors.backgroundColor,
          primaryColorDark: AppColors.black,
          primaryColorLight: AppColors.white,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  void _configOrientation(BuildContext context) {
    if (getDeviceType() == DeviceType.tablet) {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}
