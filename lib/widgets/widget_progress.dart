import 'package:flutter/material.dart';

class WidgetProgress extends StatelessWidget {
  const WidgetProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}