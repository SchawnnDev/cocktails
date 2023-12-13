import 'package:cocktails/pages/widgets/cocktails_appbar.dart';
import 'package:cocktails/pages/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CocktailsAppBar(title: 'settings'.tr, isBackButton: false),
      bottomNavigationBar: NavBar(index: 3, animate: true,),
    );
  }
}
