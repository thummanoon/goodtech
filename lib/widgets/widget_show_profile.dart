import 'package:flutter/material.dart';
import 'package:goodtech/widgets/widget_text.dart';

class WidgetShowProfile extends StatelessWidget {
  const WidgetShowProfile({
    Key? key,
    required this.urlImage,
    this.radius,
  }) : super(key: key);

  final String urlImage;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return urlImage.isEmpty
        ? Container(alignment: Alignment.center,
            width: radius,
            height: radius,
            child: WidgetText(text: 'No Image'),
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(urlImage),
            backgroundColor: Colors.white,
            radius: radius,
          );
  }
}
