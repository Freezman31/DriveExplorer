import 'package:backup_tool/api/drive.dart';
import 'package:backup_tool/components/default_widget.dart';
import 'package:backup_tool/components/info_card.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final List<Item> driveData;
  const MainScreen({super.key, required this.driveData});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    
      return DefaultWidget(
          selected: 0,
          child: InfoCard(
            driveItems: widget.driveData,
          ));
  }
}
