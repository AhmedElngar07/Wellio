import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wellio/Screens/Home.dart';
import 'package:wellio/Widgets/model.dart';

class SkinDiagnosisChatBot extends StatefulWidget {
  final String userName;
  const SkinDiagnosisChatBot({Key? key, required this.userName})
      : super(key: key);

  @override
  _SkinDiagnosisChatBotState createState() => _SkinDiagnosisChatBotState();
}

class _SkinDiagnosisChatBotState extends State<SkinDiagnosisChatBot> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  final TextEditingController promptController = TextEditingController();
  static const apiKey =
      "AIzaSyD_q_DeFBAarzG4uHzHt7kAf2DOti0vmLw"; // Replace with your actual API key
  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);

  final List<ModelMessage> prompt = [];

  bool isLoading = true; // Flag to track if we are in the "loading" state

  @override
  void initState() {
    super.initState();
    loadModel();
    prompt.add(ModelMessage(
      isPrompt: false,
      message: "Hello ${widget.userName}, How can I help you?",
      time: DateTime.now(),
    ));
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/mobilenet_model.tflite",
      labels: "assets/labels.txt",
    );
    // Simulate a delay for loading or fetching initial data
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false; // Transition to the normal chat after the delay
    });
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        prompt.add(ModelMessage(
          isPrompt: true,
          message: image.path, // Save image path for display
          time: DateTime.now(),
        ));
      });

      await diagnoseImage(File(image.path));
    }
  }

  Future<void> diagnoseImage(File image) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 1,
        threshold: 0.1,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        var bestPrediction = recognitions.first;
        String diagnosis = "Prediction: ${bestPrediction['label']} \n"
            "Confidence: ${(bestPrediction['confidence'] * 100).toStringAsFixed(2)}%";

        setState(() {
          prompt.add(ModelMessage(
            isPrompt: false,
            message: diagnosis,
            time: DateTime.now(),
          ));
        });

        await generateChatBotResponse(bestPrediction['label']);
      } else {
        setState(() {
          prompt.add(ModelMessage(
            isPrompt: false,
            message: "Unable to predict. Please try another image.",
            time: DateTime.now(),
          ));
        });
      }
    } catch (e) {
      print("Error during image diagnosis: $e");
      setState(() {
        prompt.add(ModelMessage(
          isPrompt: false,
          message: "Error during image diagnosis. Please try again.",
          time: DateTime.now(),
        ));
      });
    }
  }

  Future<void> generateChatBotResponse(String message) async {
    final response = await model.generateContent([Content.text(message)]);

    setState(() {
      prompt.add(ModelMessage(
        isPrompt: false,
        message: response.text ?? "No response available.",
        time: DateTime.now(),
      ));
    });
  }

  void sendMessage() {
    final message = promptController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        prompt.add(ModelMessage(
          isPrompt: true,
          message: message,
          time: DateTime.now(),
        ));
      });

      promptController.clear();
      generateChatBotResponse(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff5b457c),
            Color(0xff301998),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Ensures gradient remains visible
        appBar: AppBar(
          backgroundColor: const Color(0xff5b457c),
          shadowColor: Colors.black.withOpacity(0.7),
          elevation: 5,
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
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        body: isLoading // Check if we are in loading state
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display the GPT logo (replace with your logo image)
                    Image.asset('assets/Logo.png', width: 150, height: 150),
                    SizedBox(height: 20),
                    Text(
                      "Starting new session!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: prompt.length,
                      itemBuilder: (context, index) {
                        final message = prompt[index];
                        return Align(
                          alignment: message.isPrompt
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.80,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.symmetric(vertical: 1)
                                  .copyWith(
                                      left: message.isPrompt ? 80 : 15,
                                      right: message.isPrompt ? 15 : 80),
                              decoration: BoxDecoration(
                                color: message.isPrompt
                                    ? Color(0xF9694AFF)
                                    : Color(0x882E2E3D),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: message.isPrompt
                                      ? Radius.circular(20)
                                      : Radius.zero,
                                  bottomRight: message.isPrompt
                                      ? Radius.zero
                                      : Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  message.isPrompt
                                      ? (message.message.endsWith(".jpg") ||
                                              message.message.endsWith(".png"))
                                          ? Image.file(
                                              File(message.message),
                                              height: 150,
                                              width: 150,
                                            )
                                          : Text(message.message)
                                      : Text(
                                          message.message,
                                          style: TextStyle(
                                            fontWeight: message.isPrompt
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 18,
                                            color: message.isPrompt
                                                ? Colors.white
                                                : Colors.white,
                                          ),
                                        ),
                                  SizedBox(height: 5),
                                  Text(
                                    DateFormat('hh:mm a').format(message.time),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: message.isPrompt
                                          ? Colors.white
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
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
                        IconButton(
                          icon: const Icon(Icons.image),
                          onPressed: pickImage,
                          color: Colors.white,
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
}
