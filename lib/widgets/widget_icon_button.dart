import 'package:flutter/material.dart';

class WidgetIconButton extends StatelessWidget {
  const WidgetIconButton({
    Key? key,
    required this.iconData,
    required this.pressFunc,
  }) : super(key: key);

  final IconData iconData;
  final Function() pressFunc;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: pressFunc, icon: Icon(iconData));
  }
}
