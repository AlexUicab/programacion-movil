import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'core/constants.dart';
import 'screens/home_screen.dart';

class MisDestinosApp extends StatelessWidget {
  const MisDestinosApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeScreen(),
      );
}
