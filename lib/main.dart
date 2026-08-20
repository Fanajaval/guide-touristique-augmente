import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'services/favorites_service.dart';
import 'services/poi_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
    await PoiService.instance.importMockPoisOnce();
  } catch (error) {
    // L'application peut démarrer même si Firestore refuse l'import.
    debugPrint('Import des POIs impossible: $error');
  }

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