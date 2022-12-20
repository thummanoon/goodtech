import 'package:flutter/material.dart';

class WidgetImageInternet extends StatelessWidget {
  const WidgetImageInternet({
    Key? key,
    required this.urlPath,
    this.width,
    this.height,
  }) : super(key: key);

  final String urlPath;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      urlPath,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}
