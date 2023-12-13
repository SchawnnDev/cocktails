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
  var currentIndex = -1;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (index) {
      return AnimationController(
          vsync: this, duration: const Duration(seconds: 1));
    });

    currentIndex = widget.index;

    if (widget.animate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
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
    const activeIconColor = Color(0xFF8253DB);
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
          borderRadius: BorderRadius.circular(25),
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
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
                    if (index == currentIndex && widget.animate) {
                      _controllers[index].reset();
                      _controllers[index].forward();
                      return;
                    }

                    currentIndex = index;

                    switch (index) {
                      case 0:
                        Get.toNamed('/');
                        break;
                      case 1:
                        Get.toNamed('/favorites');
                        break;
                      case 2:
                        Get.toNamed('/swipe');
                        break;
                      case 3:
                        Get.toNamed('/settings');
                        break;
                    }
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Lottie.asset(
                      currentIndex == 0
                          ? 'assets/lottie/icon_home_solid.json'
                          : 'assets/lottie/icon_home_regular.json',
                      height: 30,
                      frameRate: FrameRate(60),
                      controller: _controllers[0],
                      delegates: LottieDelegates(
                        values: [
                          if (currentIndex == 0)
                            ValueDelegate.strokeColor(
                              const ['**'],
                              value: activeIconColor,
                            ),
                          if (currentIndex == 0)
                            ValueDelegate.color(
                              const ['**'],
                              value: activeIconColor,
                            ),
                        ],
                      ),
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                      icon: Lottie.asset(
                        currentIndex == 1
                            ? 'assets/lottie/icon_favorite_solid.json'
                            : 'assets/lottie/icon_favorite_regular.json',
                        height: 30,
                        frameRate: FrameRate(60),
                        controller: _controllers[1],
                        delegates: LottieDelegates(
                          values: [
                            if(currentIndex == 1)
                              ValueDelegate.strokeColor(
                                const ['**'],
                                value: activeIconColor,
                              ),
                            if(currentIndex == 1)
                              ValueDelegate.color(
                                const ['**'],
                                value: activeIconColor,
                              ),
                          ],
                        ),
                      ),
                      label: "Favorite"),
                  BottomNavigationBarItem(
                    icon: Lottie.asset(
                      currentIndex == 2
                          ? 'assets/lottie/icon_swipe_solid.json'
                          : 'assets/lottie/icon_swipe_regular.json',
                      height: 28,
                      frameRate: FrameRate(60),
                      controller: _controllers[2],
                      delegates: LottieDelegates(
                        values: [
                          if (currentIndex == 2)
                            ValueDelegate.strokeColor(
                              const ['**'],
                              value: activeIconColor,
                            ),
                          if (currentIndex == 2)
                            ValueDelegate.color(
                              const ['**'],
                              value: activeIconColor,
                            ),
                        ],
                      ),
                    ),
                    label: "Swipe",
                  ),
                  BottomNavigationBarItem(
                    icon: Lottie.asset(
                      currentIndex == 3
                          ? 'assets/lottie/icon_settings_solid.json'
                          : 'assets/lottie/icon_settings_regular.json',
                      height: 28,
                      frameRate: FrameRate(60),
                      controller: _controllers[3],
                      delegates: LottieDelegates(
                        values: [
                          if (currentIndex == 3)
                            ValueDelegate.strokeColor(
                              const ['**'],
                              value: activeIconColor,
                            ),
                          if (currentIndex == 3)
                            ValueDelegate.color(
                              const ['**'],
                              value: activeIconColor,
                            ),
                        ],
                      ),
                    ),
                    label: "Settings",
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
