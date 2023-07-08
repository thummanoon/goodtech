import 'package:flutter/material.dart';
import 'package:goodtech/states/navigator_page.dart';
import 'package:upgrader/upgrader.dart';

class UpgradeAlertPage extends StatelessWidget {
  const UpgradeAlertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: UpgradeAlert(child: const NavigatorPage(),));
  }
}