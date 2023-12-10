import 'package:flutter/material.dart';

class BadgePill extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle? textStyle;
  final Icon? frontIcon;
  final Icon? backIcon;

  BadgePill(
      {required this.text,
      required this.color,
      this.textStyle,
      this.frontIcon,
      this.backIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (frontIcon != null)
            Container(margin: EdgeInsets.only(right: 5), child: frontIcon!),
          Text(
            text,
            style: textStyle ?? TextStyle(color: Colors.white),
          ),
          if (backIcon != null)
            Container(margin: EdgeInsets.only(left: 5), child: backIcon!),
        ]));
  }
}
