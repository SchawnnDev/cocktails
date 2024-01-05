import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // quick system translations (app not loaded & get translations not available)
    var alcohol = 'Alcohol is injurious to health';
    var loading = 'Loading...';
    final defaultLocale = Platform.localeName;
    if (defaultLocale == 'fr' || defaultLocale == 'fr_FR') {
      alcohol = 'L\'alcool est dangereux pour la santé';
      loading = 'Chargement...';
    } else if (defaultLocale == 'de' || defaultLocale == 'de_DE') {
      alcohol = 'Alkohol ist gesundheitsschädlich';
      loading = 'Wird geladen...';
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Color(0xFFBAA9DB),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/cocktail_loading.json',
                    frameRate: FrameRate(60),
                    repeat: true,
                    controller: _controller, onLoaded: (composition) async {
                  _controller
                    ..duration = Duration(seconds: 3)
                    ..repeat();
                }),
                Text(
                  loading,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Karla',
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text(
                  alcohol,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Karla',
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
