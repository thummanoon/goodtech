import 'package:flutter/material.dart';

class WidgetImageInternet extends StatelessWidget {
  const WidgetImageInternet({
    Key? key,
    required this.urlPath,
  }) : super(key: key);

  final String urlPath;

  @override
  Widget build(BuildContext context) {
    return Image.network(urlPath, fit: BoxFit.cover,);
  }
}
