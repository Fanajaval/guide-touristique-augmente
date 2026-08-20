import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'services/favorites_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await FavoritesService.instance.loadFavorites();
  } catch (_) {
    // La persistance des favoris est optionnelle au démarrage.
  }

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
