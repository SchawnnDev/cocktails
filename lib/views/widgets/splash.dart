import 'package:flutter/material.dart';
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
    return Container(
      color: Color(0xFFBAA9DB),
      alignment: Alignment.center,
      child: Lottie.asset('assets/lottie/cocktail_loading.json',
          frameRate: FrameRate(60),
          repeat: true,
          controller: _controller,
          onLoaded: (composition) async {
            _controller
                ..duration = Duration(seconds: 3)
                ..repeat();
          }),
    );
  }
}
