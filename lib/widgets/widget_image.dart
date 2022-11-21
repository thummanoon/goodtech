import 'package:flutter/material.dart';

class WidgetImage extends StatelessWidget {
  const WidgetImage({
    Key? key,
    this.size,
  }) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/logo.png',
      width: size,
    );
  }
}
