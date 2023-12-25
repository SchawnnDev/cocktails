import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CocktailProgressIndicator extends StatefulWidget {
  const CocktailProgressIndicator({super.key});

  @override
  State<CocktailProgressIndicator> createState() => _CocktailProgressIndicatorState();
}

class _CocktailProgressIndicatorState extends State<CocktailProgressIndicator> with SingleTickerProviderStateMixin {
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
    return Lottie.asset('assets/lottie/cocktail_loading.json',
        frameRate: FrameRate(60),
        repeat: true,
        controller: _controller,
        delegates: LottieDelegates(
          values: [
              ValueDelegate.strokeColor(
                const ['BG', '**'],
                value: Colors.white,
              ),
              ValueDelegate.color(
                const ['BG', '**'],
                value: Colors.white,
              ),
          ],
        ),
        onLoaded: (composition) async {
          _controller
            ..duration = Duration(seconds: 3)
            ..repeat();
        });
  }
}
