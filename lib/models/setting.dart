import 'package:flutter/material.dart';

class Setting {
  final String name;
  String _value; // key
  final IconData? icon;
  final Map<String, String> values; // key: value
  final String Function(String newValue)? onChange;
  final Function(BuildContext ctx)? onTap; // in case of a button

  Setting(String value,
      {required this.name,
      required this.icon,
      required this.values,
      this.onChange,
      this.onTap})
      : _value = value {
    assert(
        onTap == null && onChange != null || onTap != null && onChange == null);
  }

  String? getLabel() {
    return values[_value];
  }

  void setValue(String value) {
    if (onChange != null && value != _value) {
      _value = onChange!(value);
    }
  }

  String getValue() {
    return _value;
  }
}
