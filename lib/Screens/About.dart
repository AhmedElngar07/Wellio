import 'package:flutter/material.dart';
import 'package:wellio/Screens/Home.dart';
import 'package:wellio/Screens/Welcome.dart';
import 'package:wellio/Services/Authentication.dart';
import 'package:wellio/Services/sessionGenerate.dart';

class AboutUsPage extends StatelessWidget {
  final String userName;
  final String userID;

  // Constructor to pass the userName and userID
  AboutUsPage({Key? key, required this.userName, required this.userID})
      : super(key: key);

  void chatBot(BuildContext context) {
    ChatServices.startNewChatSession(
      context: context,
      userID: userID,
      userName: userName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff452C63), Color(0xff3D2C8D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            title:
                const Text('About Us', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 35.0, bottom: 16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff452C63), Color(0xff3D2C8D)],
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
                    title: Text('Chatbot'),
                    onTap: () => chatBot(context),
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/about-us-icon.png',
                      width: 24,
                      height: 24,
                    ),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Home(
                            userName: userName, // Pass the userName
                            userID: userID, // Pass the userID
                          ),
                        ),
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
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  await AuthServices().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff452C63), Color(0xff3D2C8D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Our App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome to our app! We are here to help you take control of your skin health. '
                  'Our AI-powered app analyzes skin images to provide potential diagnoses and recommendations. '
                  'It is a convenient and accessible way to get initial insights and decide if further medical attention is needed.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images-removebg-preview.png',
                    width: MediaQuery.of(context).size.width * 0.4,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
