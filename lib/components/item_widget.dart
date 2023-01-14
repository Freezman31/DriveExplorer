import 'package:backup_tool/api/drive.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final void Function(String path) onTap;
  const ItemWidget({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: InkWell(
          onTap: () {
            item.type == ItemType.folder ? onTap(item.path) : null;
          },
          child: Row(
            children: [
              Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Icon(item.type == ItemType.file
                      ? Icons.file_open
                      : Icons.folder)),
              Text(
                item.name,
                style: theme.textTheme.displaySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
