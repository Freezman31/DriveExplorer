import 'package:backup_tool/api/drive.dart';
import 'package:backup_tool/components/default_widget.dart';
import 'package:backup_tool/components/info_card.dart';
import 'package:backup_tool/main.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Item>? driveData;

  @override
  void initState() {
    apiManager.login().then((value) => setState(() {
          driveData = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (driveData == null) {
      Future.delayed(const Duration(seconds: 1))
          .then((value) => setState(() {}));
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    } else {
      return DefaultWidget(
          selected: 0,
          child: InfoCard(
            driveItems: driveData!,
          ));
    }
  }
}
