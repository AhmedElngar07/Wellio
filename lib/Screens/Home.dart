import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:wellio/Screens/About.dart';
import 'package:wellio/Screens/Welcome.dart';
import 'package:wellio/Services/Authentication.dart';
import 'package:wellio/Services/sessionGenerate.dart';
import 'package:wellio/Widgets/buttom.dart';

class Home extends StatelessWidget {
  final String userName;
  final String userID;

  const Home({super.key, required this.userName, required this.userID});

  void handleGetStarted(BuildContext context) {
    ChatServices.startNewChatSession(
      context: context,
      userID: userID,
      userName: userName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // Add Drawer to Scaffold
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff452C63), Color(0xff3D2C8D)],
                ),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                      leading: Image.asset(
                        'assets/robot.png',
                        width: 24,
                        height: 24,
                      ),
                      title: const Text('Chatbot'),
                      onTap: () => handleGetStarted(context)),
                  ListTile(
                    leading: Image.asset(
                      'assets/about-us-icon.png',
                      width: 24,
                      height: 24,
                    ),
                    title: const Text('About us'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AboutUsPage(
                                  userName: userName, // Pass the userName
                                  userID: userID,
                                )),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF4A6E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  try {
                    await AuthServices().signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error logging out: $e')),
                    );
                  }
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: screenSize.height,
            width: screenSize.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/111_n.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Welcome, $userName",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Welcome to WellioChat,\nWe Are Here to Help You :)',
                            textAlign: TextAlign.left,
                            textStyle: const TextStyle(
                              color: Colors.white70,
                              fontSize: 24.0,
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              children: [
                CustomButton(
                  text: "Get Started",
                  onTap: () => handleGetStarted(context),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
