import 'package:backup_tool/components/sidebar_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key, required this.isSmall, required this.selected});

  final bool isSmall;
  final int selected;
  final List<SideBarItem> items = const [
    SideBarItem(title: 'Home', icon: Icons.home_filled, route: 'home'),
    SideBarItem(title: 'Explorer', icon: Icons.folder, route: 'explorer'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return selected == index
                ? Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF3b3170),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: getListTile(index, theme, context, isSmall),
                  )
                : getListTile(index, theme, context, isSmall);
          },
          itemCount: items.length,
        ),
      ),
    );
  }

  Widget getListTile(
      int index, ThemeData theme, BuildContext context, bool iconOnly) {
    return iconOnly
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Icon(
              items[index].icon,
              color: theme.colorScheme.onSurface,
            ),
          )
        : ListTile(
            title: Text(
              items[index].title,
              style: theme.textTheme.labelMedium!
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
            leading: Icon(
              items[index].icon,
              color: theme.colorScheme.onSurface,
            ),
            selected: selected == index,
            onTap: () {
              context.go('/${items[index].route}');
            },
          );
  }
}
