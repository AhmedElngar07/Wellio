import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:wellio/Services/Authentication.dart';
import 'package:wellio/Screens/Login.dart';
import 'package:wellio/Widgets/GeminiChatBot.dart';
import 'package:wellio/Widgets/buttom.dart';

class Home extends StatelessWidget {
  final String fullName;

  const Home({super.key, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // "Hello, $fullName",
                      "Hello,\n Yousef Yasser",
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
                          MaterialPageRoute(builder: (context) => LoginScreen()),
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
                Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome to WellioChat , \n We Are Here to Help You :) ',
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
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: "Get Start",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Geminichatbot(),
                        ),
                      );
                    },
                  ),
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
