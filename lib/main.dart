import 'package:cocktails/services/boxes_service.dart';
import 'package:cocktails/services/thecocktailsdb_service.dart';
import 'package:cocktails/views/app.dart';
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
