import 'package:backup_tool/api/drive.dart';
import 'package:backup_tool/screens/main_screen.dart';
import 'package:flutter/material.dart';

final apiManager = GoogleDriveApiManager();

void main() {
  runApp(const BackupToolApp());
}

class BackupToolApp extends StatelessWidget {
  const BackupToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xFFFF664F),
            onPrimary: Color(0xFF000000),
            secondary: Color(0xFF0ec37e),
            onSecondary: Color(0xFF000000),
            background: Color(0xFF12141d),
            error: Color(0xFF960801),
            onError: Color(0xFFFFFFFF),
            onBackground: Color(0xFFFFFFFF),
            surface: Color(0xFF1E2029),
            onSurface: Color(0xFFd5d0fd),
          ),
          textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                fontFamily: 'Work Sans',
                color: Color(0xFFFFFFFF),
              ),
              labelMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Work Sans',
              )),
        ),
        routes: const {});
  }
}
