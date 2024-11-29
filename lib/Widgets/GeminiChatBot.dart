import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:wellio/Screens/Home.dart';
import 'package:wellio/Widgets/model.dart';

class Geminichatbot extends StatefulWidget {
  final String userName;

  const Geminichatbot({super.key, required this.userName});

  @override
  State<Geminichatbot> createState() => _GeminichatbotState();
}

class _GeminichatbotState extends State<Geminichatbot> {
  TextEditingController promptController = TextEditingController();
  static const apiKey = "AIzaSyD_q_DeFBAarzG4uHzHt7kAf2DOti0vmLw";
  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);

  final List<ModelMessage> prompt = [];

  Future<void> sendMessage() async {
    final message = promptController.text;
    // for prompt
    setState(() {
      promptController.clear();

      prompt.add(
        ModelMessage(
          isPrompt: true,
          message: message,
          time: DateTime.now(),
        ),
      );
    });
    // for respond
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      prompt.add(
        ModelMessage(
          isPrompt: false,
          message: response.text ?? "",
          time: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Color(0xff1c1c1e),
            // Color(0xff464649),
            Color(0xff5b457c),
            Color(0xff301998),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        // Ensure the background remains transparent
        backgroundColor: Colors.transparent, // Ensures gradient remains visible
        appBar: AppBar(
          backgroundColor: const Color(0xff5b457c),
          shadowColor: Colors.black.withOpacity(0.7), // Add shadow to AppBar
          elevation: 5, // Adjust the shadow intensity
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(userName: widget.userName),
                ),
              );
            },
          ),
          title: const Text(
            "WellioBot",
            style: TextStyle(
              color: Colors.white, // Use a contrasting color
              fontSize: 25,
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 20), // Adds space below the AppBar
            Expanded(
              child: ListView.builder(
                itemCount: prompt.length,
                shrinkWrap:
                    true, // Ensures the ListView doesn't take unnecessary space
                physics: BouncingScrollPhysics(), // Adds smooth scrolling
                itemBuilder: (context, index) {
                  final message = prompt[index];
                  return Align(
                    alignment: message.isPrompt
                        // Align based on sender
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          // Adjust width
                          // maxWidth: MediaQuery.of(context).size.width * 0.40,
                          ),
                      child: UserPrompt(
                        isPrompt: message.isPrompt,
                        message: message.message,
                        date: DateFormat('hh:mm a').format(message.time),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Row(
                children: [
                  Expanded(
                    flex: 20,
                    child: TextField(
                      controller: promptController,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Ask a question",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: CircleAvatar(
                      radius: 29,
                      backgroundColor: Color(0xF9694AFF),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container UserPrompt({
    required final bool isPrompt,
    required String message,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 1)
          .copyWith(left: isPrompt ? 80 : 15, right: isPrompt ? 15 : 80),
      decoration: BoxDecoration(
        color: isPrompt ? Color(0xF9694AFF) : Color(0x882E2E3D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: isPrompt ? Radius.circular(20) : Radius.zero,
          bottomRight: isPrompt ? Radius.zero : Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // for prompt and respond
          Text(
            message,
            style: TextStyle(
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
              color: isPrompt ? Colors.white : Colors.white,
            ),
          ),

          // for prompt and respond time

          Text(date,
              style: TextStyle(
                fontSize: 13,
                color: isPrompt ? Colors.white : Colors.white,
              ))
        ],
      ),
    );
  }
}
