import 'package:backup_tool/components/sidebar.dart';
import 'package:backup_tool/utils.dart';
import 'package:flutter/material.dart';

class DefaultWidget extends StatelessWidget {
  final Widget child;
  final int selected;
  const DefaultWidget({super.key, required this.child, required this.selected});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      body: Row(
        children: [
          isWidthSmall(size)
              ? SizedBox(
                  width: 75,
                  height: size.height,
                  child: SideBar(isSmall: true, selected: selected),
                )
              : isWidthLarge(size)
                  ? SizedBox(
                      width: 350,
                      height: size.height,
                      child: SideBar(
                        isSmall: false,
                        selected: selected,
                      ),
                    )
                  : Expanded(
                      child: SideBar(
                        isSmall: false,
                        selected: selected,
                      ),
                    ),
          Expanded(
            flex: 3,
            child: Container(
              color: theme.colorScheme.background,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
