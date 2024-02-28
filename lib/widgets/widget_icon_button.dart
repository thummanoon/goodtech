import 'package:flutter/material.dart';

class WidgetIconButton extends StatelessWidget {
  const WidgetIconButton({
    Key? key,
    required this.iconData,
    required this.pressFunc,
    this.iconColor,
    this.tooltip,
    this.size,
  }) : super(key: key);

  final IconData iconData;
  final Function() pressFunc;
  final Color? iconColor;
  final String? tooltip;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: pressFunc,
      icon: Icon(
        iconData,
        color: iconColor,size: size,
      ),
      tooltip: tooltip,
    );
  }
}
