import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  var idx = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 25,
            offset: const Offset(8, 20))
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.black,
            currentIndex: idx,
            landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
            onTap: (index) {
              setState(() {
                idx = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Lottie.asset(
                      'lottie/icon_home.json',
                    height: 32,
                    frameRate: FrameRate(60),
                  ),
                  label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Lottie.asset(
                    'lottie/icon_like.json',
                    height: 32,
                    frameRate: FrameRate(60),
                  ),
                  label: "Favorite"
              ),
              BottomNavigationBarItem(
                  icon: Lottie.asset(
                    'lottie/icon_settings.json',
                    height: 32,
                    frameRate: FrameRate(60),
                  ),
                  label: "Setting"
              ),
            ]),
      ),
    );
  }
}
