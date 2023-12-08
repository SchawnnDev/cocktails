import 'package:flutter/material.dart';

class BadgePill extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle? textStyle;

  BadgePill({required this.text, required this.color, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: textStyle ?? TextStyle(color: Colors.white),
      ),
    );
  }
}