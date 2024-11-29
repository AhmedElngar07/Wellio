import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:wellio/Screens/Login.dart';
import 'package:wellio/Screens/imagemodel.dart';
import 'package:wellio/Screens/newChatbot.dart';
import 'package:wellio/Services/Authentication.dart';
import 'package:wellio/Widgets/GeminiChatBot.dart';
import 'package:wellio/Widgets/buttom.dart';

class Home extends StatelessWidget {
  final String userName;

  const Home({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff452C63), Color(0xff3D2C8D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message and Log Out button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome, $userName!", // Display the logged-in user's name
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF4A6E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        await AuthServices().signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Log Out",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Animated welcome text
                Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome to WellioChat, \n We Are Here to Help You :) ',
                        textStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 90),
                      ),
                    ],
                    totalRepeatCount: 2,
                    pause: const Duration(milliseconds: 5000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
                const Spacer(),
                // Buttons for navigating to different screens
                Column(
                  children: [
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Image Model",
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => ObjectDetectionScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Diagnostic Chatbot",
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  SkinDiagnosisChatBot(userName: userName)),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Get Started",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                Geminichatbot(userName: userName),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
