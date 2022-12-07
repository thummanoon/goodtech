import 'package:flutter/material.dart';

class WidgetIconButton extends StatelessWidget {
  const WidgetIconButton({
    Key? key,
    required this.iconData,
    required this.pressFunc,
    this.iconColor,
  }) : super(key: key);

  final IconData iconData;
  final Function() pressFunc;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: pressFunc,
        icon: Icon(
          iconData,
          color: iconColor,
        ));
  }
}
