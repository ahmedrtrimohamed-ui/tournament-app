import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/dark_theme.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: TouGameApp()));
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
