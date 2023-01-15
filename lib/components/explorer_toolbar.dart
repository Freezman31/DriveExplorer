import 'package:flutter/material.dart';

class ExplorerToolBar extends StatelessWidget {
  final void Function() onTap;
  const ExplorerToolBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
