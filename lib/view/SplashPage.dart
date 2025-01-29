
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:base_app/constants/AppAssets.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';


class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(AppAssets.logo.pathString),
      nextScreen: const HomePage(),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.black,
      duration: 3000,
    );
  }
}