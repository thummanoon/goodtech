import 'package:flutter/material.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    Key? key,
    this.hint,
    required this.changeFunc,
    this.suffixWidget,
    this.obscecu,
    this.labelWidget,
    this.textInputType,
    this.textEditingController,
    this.marginTop,
    this.width,
    this.fillColor,
  }) : super(key: key);

  final String? hint;
  final Function(String) changeFunc;
  final Widget? suffixWidget;
  final bool? obscecu;
  final Widget? labelWidget;
  final TextInputType? textInputType;
  final TextEditingController? textEditingController;
  final double? marginTop;
  final double? width;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(top: marginTop ?? 16),
      width: width ?? 250,
      height: 40,
      child: TextFormField(
        controller: textEditingController,
        keyboardType: textInputType,
        obscureText: obscecu ?? false,
        onChanged: changeFunc,
        decoration: InputDecoration(
          label: labelWidget,
          suffixIcon: suffixWidget,
          filled: true,fillColor: fillColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: hint,
        ),
      ),
    );
  }
}
