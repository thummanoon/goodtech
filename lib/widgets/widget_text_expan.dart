import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class WidgetTextExpanable extends StatelessWidget {
  const WidgetTextExpanable({
    Key? key,
    required this.data,
    this.textStyle,
  }) : super(key: key);
  final String data;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      data,
      expandText: 'ดูเพิ่มเติม',
      collapseText: '...ย่อ',
      maxLines: 1,
      style: textStyle,
    );
  }
}
