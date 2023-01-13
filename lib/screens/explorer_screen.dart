import 'package:backup_tool/api/drive.dart';
import 'package:backup_tool/components/default_widget.dart';
import 'package:backup_tool/components/item_widget.dart';
import 'package:flutter/material.dart';

class ExplorerScreen extends StatefulWidget {
  final List<Item> driveItems;
  const ExplorerScreen({super.key, required this.driveItems});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

final rootRegExp = RegExp(
  r'^[^\/]*\/[^\/]*$',
  caseSensitive: false,
  multiLine: false,
);

class _ExplorerScreenState extends State<ExplorerScreen> {
  String path = '';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return DefaultWidget(
      selected: 1,
      child: ListView.builder(
        itemBuilder: (context, item) {
          return ItemWidget(
            item: widget.driveItems
                .where((element) => path == ""
                    ? rootRegExp.hasMatch(element.path)
                    : element.path == path)
                .toList()[item],
          );
        },
        itemCount: widget.driveItems
            .where((element) => path == ""
                ? rootRegExp.hasMatch(element.path)
                : element.path == path)
            .length,
      ),
    );
  }
}
