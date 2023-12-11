import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NavBar extends StatefulWidget {
  final int index;
  final bool animate;

  const NavBar({super.key, this.index = 0, this.animate = true});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(vsync: this, duration: const Duration(seconds: 1));
    });

    if (widget.animate) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
            print('animating ${widget.index}');
            _controllers[widget.index].forward();
          });
    }

  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 25,
              offset: const Offset(8, 20))
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            child: BottomNavigationBar(
                selectedFontSize: 0.0,
                unselectedFontSize: 0.0,
                type: BottomNavigationBarType.fixed,
                elevation: 0.0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.redAccent,
                unselectedItemColor: Colors.black,
                currentIndex: widget.index,
                landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
                onTap: (index) {
                  setState(() {
                    switch(index) {
                      case 0:
                        Get.toNamed('/');
                        break;
                      case 1:
                        Get.toNamed('/favorites');
                        break;
                      case 2:
                        Get.toNamed('/swipe');
                        break;
                    }
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          Lottie.asset(
                            'assets/lottie/icon_home.json',
                          height: 32,
                          frameRate: FrameRate(60),
                          controller: _controllers[0],
                        ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle
                              ),
                            ),
                          )
                        ]
                      ),
                      label: "Home",
                  ),
                  BottomNavigationBarItem(
                      icon: Lottie.asset(
                        'assets/lottie/icon_like.json',
                        height: 42,
                        frameRate: FrameRate(60),
                        controller: _controllers[1],
                      ),
                      label: "Favorite"
                  ),
                  BottomNavigationBarItem(
                      icon: Lottie.asset(
                        'assets/lottie/icon_settings.json',
                        height: 32,
                        frameRate: FrameRate(60),
                        controller: _controllers[2],
                      ),
                      label: "Setting"
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
