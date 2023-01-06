import 'package:backup_tool/components/info_card.dart';
import 'package:backup_tool/components/sidebar.dart';
import 'package:backup_tool/main.dart';
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
    return FutureBuilder(
      future: apiManager.login(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                isWidthSmall(size)
                    ? SizedBox(
                        width: 75,
                        height: size.height,
                        child: const SideBar(isSmall: true),
                      )
                    : isWidthLarge(size)
                        ? SizedBox(
                            width: 350,
                            height: size.height,
                            child: const SideBar(isSmall: false),
                          )
                        : const Expanded(
                            child: SideBar(
                              isSmall: false,
                            ),
                          ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: theme.colorScheme.background,
                    child: Column(
                      children: const [
                        Expanded(child: InfoCard()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
