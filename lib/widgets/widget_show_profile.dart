import 'package:flutter/material.dart';

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
    return CircleAvatar(
      backgroundImage: NetworkImage(urlImage),
      backgroundColor: Colors.white,
      radius: radius,
    );
  }
}
