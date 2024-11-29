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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, $userName!\nYou have successfully logged in!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            CustomButton(
                text: "log out",
                onTap: () async {
                  await AuthServices().signOut();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }),
            const SizedBox(height: 20),
            CustomButton(
                text: " chatbot",
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Geminichatbot(userName: userName)));
                }),
            const SizedBox(height: 20),
            CustomButton(
                text: " image Model",
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ObjectDetectionScreen()));
                }),
            const SizedBox(height: 20),
            CustomButton(
                text: " DiagonsticChatbot",
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          SkinDiagnosisChatBot(userName: userName)));
                }),
          ],
        ),
      ),
    );
  }
}
