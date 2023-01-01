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
    return Scaffold(
        body: Column(
      children: [
        Text(
          'Hello World',
          style: theme.textTheme.titleLarge,
        ),
      ],
    ));
  }
}
