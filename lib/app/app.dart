import 'package:flutter/material.dart';

import '../features/splash/views/splash_screen.dart';
import 'theme/app_theme.dart';

class AetherCryptoApp extends StatelessWidget {
  const AetherCryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aether Crypto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}
