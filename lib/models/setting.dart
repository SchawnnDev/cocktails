import 'package:flutter/material.dart';

class Setting {
  final String name;
  String _value; // key
  final IconData? icon;
  final Map<String, String> values; // key: value
  final String Function(String newValue) onChange;

  Setting(String value, {required this.name, required this.icon, required this.values, required this.onChange}) : _value = value;

  String? getLabel() {
    return values[_value];
  }

  void setValue(String value) {
    _value = onChange(value);
  }

  String getValue() {
    return _value;
  }

}