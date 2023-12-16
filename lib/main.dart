import 'package:cocktails/controllers/settings_controller.dart';
import 'package:cocktails/pages/splash.dart';
import 'package:cocktails/providers/persistent_data_provider.dart';
import 'package:cocktails/routes/routes.dart';
import 'package:cocktails/services/boxes_service.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:cocktails/utils/translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  await Get.putAsync(() => BoxesService().init());
  await Get.putAsync(() => TheCocktailsDBService().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Get.put(PersistentDataProvider(), permanent: true);
    final settingsController = Get.put(SettingsController(), permanent: true);

    return FutureBuilder(
        future: dataProvider.load(),
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.connectionState == ConnectionState.done) {
            child = GetMaterialApp(
              key: const Key('app'),
              translations: AppTranslations(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(fontFamily: 'Karla'),
              locale: settingsController.getLocale(),
              initialRoute: Routes.initialRoute,
              getPages: Routes.routes,
            );
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
              });
        });
  }
}
