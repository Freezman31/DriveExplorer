import 'package:backup_tool/api/drive.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  const ItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(item.type == ItemType.file ? Icons.file_open : Icons.folder),
        Text(item.name),
      ],
    );
  }
}
