import 'package:cocktails/controllers/settings_controller.dart';
import 'package:cocktails/views/app.dart';
import 'package:cocktails/views/widgets/no_internet.dart';
import 'package:cocktails/views/widgets/splash.dart';
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

  runApp(const App());
}

Future<void> initServices() async {
  await Get.putAsync(() => BoxesService().init());
  await Get.putAsync(() => TheCocktailsDBService().init());
}
