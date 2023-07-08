import 'package:flutter/material.dart';
import 'package:goodtech/widgets/widget_text.dart';

class WidgetImageInternet extends StatelessWidget {
  const WidgetImageInternet({
    Key? key,
    required this.urlPath,
    this.width,
    this.height,
    this.tapFunc,
  }) : super(key: key);

  final String urlPath;
  final double? width;
  final double? height;
  final Function()? tapFunc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapFunc,
      child: Image.network(
        urlPath,
        fit: BoxFit.cover,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          return WidgetText(text: 'No Image');
        },
      ),
    );
  }
}
