import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/home_shell.dart';

class ShopLiteApp extends StatefulWidget {
  const ShopLiteApp({super.key});

  @override
  State<ShopLiteApp> createState() => _ShopLiteAppState();
}

class _ShopLiteAppState extends State<ShopLiteApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopLite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      home: HomeShell(
        darkMode: _themeMode == ThemeMode.dark,
        onDarkModeChanged: (value) =>
            setState(() => _themeMode = value ? ThemeMode.dark : ThemeMode.light),
      ),
    );
  }
}
