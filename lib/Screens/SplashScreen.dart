import 'package:cloud_firestore/cloud_firestore.dart';
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

    Future.delayed(const Duration(seconds: 5), () async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch user data (e.g., from Firestore)
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String userName = userData['FullName'] ?? 'User';
        String userID = userData["uid"];
        // Navigate to Home and pass the userName
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => Home(userName: userName, userID: userID)),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
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
              Color(0xff5b457c),
              Color(0xff301998),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.png',
              height: MediaQuery.of(context).size.height *
                  0.25, // 25% of screen height
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
