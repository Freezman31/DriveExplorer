import 'package:backup_tool/utils.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          isWidthSmall(size)
              ? SizedBox(
                  width: 75,
                  height: size.height,
                  child: Container(color: theme.colorScheme.surface),
                )
              : isWidthLarge(size)
                  ? SizedBox(
                      width: 350,
                      height: size.height,
                      child: Container(color: theme.colorScheme.surface),
                    )
                  : Expanded(
                      child: Container(color: theme.colorScheme.surface)),
          Expanded(
            flex: 3,
            child: Container(color: theme.colorScheme.background),
          ),
        ],
      ),
    );
  }
}
