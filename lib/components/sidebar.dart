import 'package:backup_tool/components/sidebar_item.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.isSmall});

  final bool isSmall;
  final List<SideBarItem> items = const [
    SideBarItem(title: 'Home', icon: Icons.home_filled, route: '/'),
  ];

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selected = 0;
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
                    child: getListTile(index, theme, context, widget.isSmall),
                  )
                : getListTile(index, theme, context, widget.isSmall);
          },
          itemCount: widget.items.length,
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
              widget.items[index].icon,
              color: theme.colorScheme.onSurface,
            ),
          )
        : ListTile(
            title: Text(
              widget.items[index].title,
              style: theme.textTheme.labelMedium!
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
            leading: Icon(
              widget.items[index].icon,
              color: theme.colorScheme.onSurface,
            ),
            selected: selected == index,
            onTap: () {
              setState(() {
                selected = index;
              });
              Navigator.pushNamed(context, widget.items[index].route);
            },
          );
  }
}
