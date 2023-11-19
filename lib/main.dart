import 'package:cocktails/pages/home.dart';
import 'package:cocktails/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Karla'),
            home: const Splash(),
            getPages: [
              GetPage(
                name: '/',
                page: () => const HomePage(),
                transition: Transition.fadeIn,
              )
            ],
          );
        } else {
          return const Splash();
        }
      },
    );
  }
}