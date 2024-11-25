import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:wellio/Widgets/model.dart';

class Geminichatbot extends StatefulWidget {
  const Geminichatbot({super.key});

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
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.blue,
        title: Text("WellioBot"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: prompt.length,
                  itemBuilder: (context, index) {
                    final message = prompt[index];
                    return UserPrompt(
                        isPrompt: message.isPrompt,
                        message: message.message,
                        date: DateFormat('hh:mm a').format(message.time));
                  })),
          Padding(
            padding: EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                    flex: 20,
                    child: TextField(
                      controller: promptController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        hintText: "Enter the Prompt",
                      ),
                    )),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: CircleAvatar(
                    radius: 29,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
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
        color: isPrompt ? Colors.green : Colors.grey,
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
              color: isPrompt ? Colors.white : Colors.black,
            ),
          ),

          // for prompt and respond time

          Text(date,
              style: TextStyle(
                fontSize: 14,
                color: isPrompt ? Colors.white : Colors.black,
              ))
        ],
      ),
    );
  }
}
