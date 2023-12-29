import 'package:cocktails/controllers/settings_controller.dart';
import 'package:cocktails/models/setting.dart';
import 'package:cocktails/views/widgets/cocktails_appbar.dart';
import 'package:cocktails/views/widgets/navbar.dart';
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
          final setting = settingsController.settings[index];
          return ListTile(
            leading: Icon(setting.icon),
            title: Text(setting.name.tr),
            trailing: _buildTrailing(context, setting),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: settingsController.settings.length,
      ),
    );
  }

  Widget _buildTrailing(BuildContext ctx, Setting setting) {
    if (setting.onTap != null) {
      return OutlinedButton(
        onPressed: () => setting.onTap!(ctx),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(setting.getValue().tr),
      );
    }

    return DropdownButton<String>(
      value: setting.getValue(),
      onChanged: (newValue) {
        setState(() {
          setting.setValue(newValue!);
        });
      },
      items: setting.values.entries
          .map<DropdownMenuItem<String>>((entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value.tr),
              ))
          .toList(),
    );
  }
}
