import 'package:flutter/material.dart';

class ExplorerToolBar extends StatelessWidget {
  final void Function() onTapBack;
  final void Function() onTapFolder;
  const ExplorerToolBar({super.key, required this.onTapBack, required this.onTapFolder});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: onTapBack,
            child: const Icon(Icons.arrow_back),
          ),
          InkWell(
            onTap: onTapFolder,
            child: const Icon(Icons.create_new_folder),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
