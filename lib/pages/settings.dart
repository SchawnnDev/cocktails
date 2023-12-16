import 'package:cocktails/controllers/settings_controller.dart';
import 'package:cocktails/models/setting.dart';
import 'package:cocktails/pages/widgets/cocktails_appbar.dart';
import 'package:cocktails/pages/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsController get settingsController => Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CocktailsAppBar(title: 'settings'.tr, isBackButton: false),
      body: _settings(),
      bottomNavigationBar: NavBar(
        index: 3,
        animate: true,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }

  SafeArea _settings() {
    return SafeArea(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return SizedBox(
                height: 50,
                child: ListTile(
                  leading: Icon(settingsController.settings[index].icon),
                  title: Text(settingsController.settings[index].name.tr),
                  trailing: DropdownButton<String>(
                    value: settingsController.settings[index].getValue(),
                    onChanged: (newValue) {
                      setState(() {
                        settingsController.settings[index].setValue(newValue!);
                      });
                    },
                    items: settingsController.settings[index].values.entries
                        .map<DropdownMenuItem<String>>((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: settingsController.settings.length));
  }
}
