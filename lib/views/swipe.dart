import 'package:cocktails/views/widgets/cocktails_appbar.dart';
import 'package:cocktails/views/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwipePage extends StatelessWidget {
  const SwipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CocktailsAppBar(title: 'swipe'.tr, isBackButton: false),
      bottomNavigationBar: NavBar(index: 2, animate: true,),
    );
  }
}
