import 'package:backup_tool/api/drive.dart';
import 'package:backup_tool/components/default_widget.dart';
import 'package:flutter/material.dart';

class ExplorerScreen extends StatefulWidget {
  final List<Item> driveItems;
  const ExplorerScreen({super.key, required this.driveItems});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return DefaultWidget(selected: 1, child: Container());
  }
}
