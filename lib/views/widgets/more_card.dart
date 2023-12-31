import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreCard extends StatelessWidget {
  final String contentKey;
  final Color bgColor;
  final double? width;
  final double? height;
  final Function onTap;

  const MoreCard(
      this.contentKey, this.onTap, this.bgColor, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                contentKey.tr,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: Color(0x00542E71).withOpacity(0.2),
              highlightColor: Color(0x00542E71).withOpacity(0.3),
              onTapUp: (TapUpDetails details) {
                onTap();
              },
            ),
          ),
        ),
      ],
    );
  }
}
