import 'package:flutter/material.dart';

import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MadaGuideApp());
}

class MadaGuideApp extends StatelessWidget {
  const MadaGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MadaGuide',
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}