import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/dark_theme.dart';
import 'features/splash/splash_screen.dart';
import 'data/providers/storage_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const TouGameApp(),
    ),
  );
}

class TouGameApp extends StatelessWidget {
  const TouGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TouGame - Tournament Gaming Platform',
      debugShowCheckedModeBanner: false,
      theme: DarkTheme.theme,
      home: const SplashScreen(),
    );
  }
}
