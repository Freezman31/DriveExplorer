import 'package:drive_explorer/api/drive.dart';
import 'package:drive_explorer/components/default_widget.dart';
import 'package:drive_explorer/components/explorer_toolbar.dart';
import 'package:drive_explorer/components/item_widget.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

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
  String path = '/';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return DefaultWidget(
      selected: 1,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ExplorerToolBar(
                onTap: () => setState(() {
                  path = p.dirname(path);
                }),
              ),
            ),
            Column(
              children: [
                for (final item in widget.driveItems)
                  if (p.dirname(item.path) == path)
                    ItemWidget(
                      item: item,
                      onTap: (i) => changePath(item.path),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void changePath(String newPath) {
    setState(() {
      path = newPath;
    });
  }
}
