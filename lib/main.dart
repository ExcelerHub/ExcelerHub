import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';

void main() {
  runApp(const ExcelerHubApp());
}

class ExcelerHubApp extends StatelessWidget {
  const ExcelerHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _ResponsiveWrapper(child: SplashScreen()),
    );
  }
}

class _ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const _ResponsiveWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: child,
      ),
    );
  }
}
