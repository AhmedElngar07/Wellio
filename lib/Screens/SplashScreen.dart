import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wellio/Screens/Welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellio/Screens/Home.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  @override

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Navigate to the appropriate screen based on Firebase auth state after the splash screen delay
    Future.delayed(const Duration(seconds: 5), () {
      // Check the current authentication state
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          // If the user is logged in, navigate to Home
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Home()),
          );
        } else {
          // If the user is not logged in, navigate to WelcomeScreen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff452C63),
              Color(0xff3D2C8D),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.png',
              height: MediaQuery.of(context).size.height * 0.25, // 25% of screen height
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Wellio',
              style: TextStyle(
                fontSize: 80,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
