import 'package:cocktails/controllers/settings_controller.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/routes/routes.dart';
import 'package:cocktails/utils/translations.dart';
import 'package:cocktails/views/widgets/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/no_internet.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final dataProvider = Get.put(PersistentDataProvider(), permanent: true);
  final settingsController = Get.put(SettingsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    Future<void> data = dataProvider.load();

    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done) {
          if (dataProvider.error.value) {
            child = NoInternet(
              retry: () => {
                setState(() {
                  data = dataProvider.load();
                }),
              },
            );
          } else {
            child = GetMaterialApp(
              key: const Key('app'),
              translations: AppTranslations(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(fontFamily: 'Karla'),
              locale: settingsController.getLocale(),
              initialRoute: Routes.initialRoute,
              getPages: Routes.routes,
            );
          }
        } else {
          child = const Splash();
        }

        return AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: child,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    );
  }
}
