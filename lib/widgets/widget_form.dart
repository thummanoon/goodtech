import 'package:flutter/material.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    Key? key,
    required this.hint,
    required this.changeFunc,
    this.suffixWidget,
  }) : super(key: key);

  final String hint;
  final Function(String) changeFunc;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      height: 40,
      child: TextFormField(
        onChanged: changeFunc,
        decoration: InputDecoration(
          suffixIcon: suffixWidget,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          hintText: hint,
        ),
      ),
    );
  }
}
