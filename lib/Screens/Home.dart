import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellio/Screens/Login.dart';
import 'package:wellio/Screens/newChatbot.dart';
import 'package:wellio/Services/Authentication.dart';
import 'package:wellio/Widgets/buttom.dart';


class Home extends StatelessWidget {
  final String userName;
  final String userID;

  const Home({super.key, required this.userName, required this.userID});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [

          Container(
            height: screenSize.height,
            width: screenSize.width,
            decoration: BoxDecoration(
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
                        IconButton(
                          onPressed: () async {
                            await AuthServices().signOut();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.exit_to_app, color: Colors.red),
                          tooltip: 'Logout',
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),


                    Center(
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Welcome to WellioChat,\nWe Are Here to Help You :)',
                            textAlign: TextAlign.center,
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
                  onTap: () async {
                    String sessionID = DateTime.now().millisecondsSinceEpoch.toString();

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userID)
                        .collection('chats')
                        .doc(sessionID)
                        .set({
                      'createdAt': FieldValue.serverTimestamp(),
                      'sessionID': sessionID,
                      'status': 'active',
                    });

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SkinDiagnosisChatBot(
                          userName: userName,
                          userID: userID,
                          sessionID: sessionID,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // CustomButton(
                //   text: "Get Started",
                //   onTap: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => Geminichatbot(
                //           userName: userName,
                //           userID: userID,
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
