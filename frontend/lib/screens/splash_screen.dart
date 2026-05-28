import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../config/app_config.dart';
import '../config/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/ai_loading.json',
              width: 200, height: 200,
              repeat: true,
            ),
            const SizedBox(height: 24),
            Text(AppConfig.appName,
              style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text('Loading...',
              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
