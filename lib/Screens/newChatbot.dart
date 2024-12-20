import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:tflite_v2/tflite_v2.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wellio/Screens/Home.dart';
import 'package:wellio/Widgets/model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class SkinDiagnosisChatBot extends StatefulWidget {
  final String userName;
  final String userID;
  final String sessionID;
  const SkinDiagnosisChatBot(
      {Key? key,
      required this.userName,
      required this.userID,
      required this.sessionID})
      : super(key: key);

  @override
  _SkinDiagnosisChatBotState createState() => _SkinDiagnosisChatBotState();
}

class _SkinDiagnosisChatBotState extends State<SkinDiagnosisChatBot> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  final TextEditingController promptController = TextEditingController();
  static const apiKey = "AIzaSyD_q_DeFBAarzG4uHzHt7kAf2DOti0vmLw";
  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);

  final List<ModelMessage> prompt = [];

  late Interpreter interpreter; // Declare the interpreter globally

  String? lastDetectedDisease;
  bool hasDetectedDisease = false;
  double? lastConfidence;
  List<String> labels = []; // To store labels

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
    try {
      // Load TFLite model
      interpreter =
          await Interpreter.fromAsset('assets/mobilenet_model.tflite');

      // Load labels
      String labelsData =
          await DefaultAssetBundle.of(context).loadString('assets/labels.txt');
      labels = labelsData.split('\n').map((e) => e.trim()).toList();

      print("Model and labels loaded successfully!");

      setState(() {
        isLoading = false; // Update UI when loading is complete
      });
    } catch (e) {
      print("Error loading model or labels: $e");
    }
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

  Future<void> diagnoseImage(File imageFile) async {
    try {
      // Prepare input image
      img.Image? oriImage = img.decodeImage(imageFile.readAsBytesSync());
      img.Image resizedImage =
          img.copyResize(oriImage!, width: 224, height: 224);

      var inputImage = List.generate(
        1, // Batch size
        (batch) => List.generate(
          224, // Height
          (i) => List.generate(
            224, // Width
            (j) {
              final pixel = resizedImage.getPixel(j, i);
              return [
                pixel.r / 255.0, // Normalize red channel
                pixel.g / 255.0, // Normalize green channel
                pixel.b / 255.0, // Normalize blue channel
              ];
            },
          ),
        ),
      );

      var outputShape = interpreter.getOutputTensors()[0].shape;
      int numClasses = outputShape[1];

      var output = List.filled(numClasses, 0.0).reshape([1, numClasses]);

      interpreter.run(inputImage, output);

      List<double> outputValues = List<double>.from(output[0]);

      int predictedIndex = 0;
      double maxConfidence = outputValues[0];
      for (int i = 1; i < outputValues.length; i++) {
        if (outputValues[i] > maxConfidence) {
          predictedIndex = i;
          maxConfidence = outputValues[i];
        }
      }

      if (predictedIndex < labels.length) {
        String predictedLabel = labels[predictedIndex];
        double confidence = maxConfidence;

        setState(() {
          lastDetectedDisease = predictedLabel;
          lastConfidence = confidence;
          hasDetectedDisease = true;
        });

        // Get brief disease explanation from Gemini
        String briefExplanation =
            await getDiseaseExplanationFromGemini(predictedLabel);

        String diagnosis =
            "I've detected: $predictedLabel\nConfidence: ${(confidence * 100).toStringAsFixed(2)}%\n\n$briefExplanation\n\nFeel free to ask if you have any questions. I'm here to help.";

        setState(() {
          prompt.add(ModelMessage(
            isPrompt: false,
            message: diagnosis,
            time: DateTime.now(),
          ));
        });

        await saveChatMessage(imageFile.path, diagnosis, imageFile.path);
      }
    } catch (e) {
      print("Error diagnosing image: $e");
      setState(() {
        prompt.add(ModelMessage(
          isPrompt: false,
          message: "Error during image diagnosis. Please try again.",
          time: DateTime.now(),
        ));
      });
    }
  }

// Function to get brief disease explanation from Gemini
  Future<String> getDiseaseExplanationFromGemini(String disease) async {
    try {
      // Create the request prompt for Gemini (language model)
      String prompt =
          "Please provide a brief explanation of the disease '$disease'. Include a short description of what the disease is and any key characteristics.";

      final response = await model.generateContent([Content.text(prompt)]);

      return response.text ??
          "Sorry, I couldn't retrieve information at the moment.";
    } catch (e) {
      print("Error getting explanation from Gemini: $e");
      return "Sorry, I encountered an error when retrieving the explanation.";
    }
  }

  Future<void> generateChatBotResponse(String userMessage) async {
    if (!hasDetectedDisease) {
      setState(() {
        prompt.add(ModelMessage(
          isPrompt: false,
          message: "Please upload an image first so I can help you better.",
          time: DateTime.now(),
        ));
      });
      return;
    }

    // Generate a context-aware prompt for the user's question
    final String contextPrompt = """
Role: You are a professional dermatologist AI.
The patient has been diagnosed with: $lastDetectedDisease.
The question from the patient is: $userMessage

Important Instructions:
- If the question is about skin conditions, diseases, treatments, symptoms, causes, or prevention, provide a medically accurate and relevant response.
- If the question is unrelated to dermatology (such as asking about non-skin-related topics), inform the user that you only answer dermatology-related questions.
- Always give answers related to dermatology, either general (skin conditions, treatment) or specific (like $lastDetectedDisease).
""";

    try {
      final response =
          await model.generateContent([Content.text(contextPrompt)]);
      final botResponse = response.text ??
          "I apologize, but I couldn't generate a response. Please try asking your question differently.";

      setState(() {
        prompt.add(ModelMessage(
          isPrompt: false,
          message: botResponse,
          time: DateTime.now(),
        ));
      });

      await saveChatMessage(userMessage, botResponse, lastDetectedDisease);
    } catch (e) {
      print("Error generating response: $e");
      setState(() {
        prompt.add(ModelMessage(
          isPrompt: false,
          message:
              "I encountered an error. Please try asking your question again.",
          time: DateTime.now(),
        ));
      });
    }
  }

  void sendMessage() async {
    final message = promptController.text.trim();

    if (message.isNotEmpty) {
      // Add user message to chat
      setState(() {
        prompt.add(ModelMessage(
          isPrompt: true,
          message: message,
          time: DateTime.now(),
        ));
      });

      promptController.clear();

      // Create the base prompt for the AI
      String contextPrompt;

      if (hasDetectedDisease && lastDetectedDisease != null) {
        // Case: Image uploaded with detected disease
        contextPrompt = """
You are a professional dermatologist AI. The patient has been diagnosed with: $lastDetectedDisease.
The question from the patient is: $message

Please provide a relevant response based on this diagnosis.

If the user asks about skin diseases in general, such as causes, symptoms, or treatments, answer with general, accurate, and simple dermatology information.
If the user asks about a specific skin condition or disease, provide a detailed, helpful response related to $lastDetectedDisease.

If the user asks a question that is not related to dermatology or skin conditions, provide a friendly response but guide them back to dermatology-related topics.
""";
      } else {
        // Case: No image uploaded - handle general dermatology questions
        contextPrompt = """
You are a professional dermatologist AI. 
The question from the patient is: $message

Please provide helpful dermatology-related information:
- For general questions about skin diseases, provide accurate and simple dermatological information
- For specific skin conditions, provide detailed information about symptoms, causes, and general treatment approaches
- For questions about skin care and prevention, provide helpful advice
- For non-dermatology questions, provide a friendly response but guide them back to dermatology-related topics

Remember to maintain a professional but friendly tone while focusing on dermatology expertise.
""";
      }

      try {
        final response =
            await model.generateContent([Content.text(contextPrompt)]);
        final botResponse = response.text ??
            "I apologize, I couldn't generate a response. Please try rephrasing your question.";

        setState(() {
          prompt.add(ModelMessage(
            isPrompt: false,
            message: botResponse,
            time: DateTime.now(),
          ));
        });

        await saveChatMessage(message, botResponse, lastDetectedDisease);
      } catch (e) {
        print("Error generating response: $e");
        setState(() {
          prompt.add(ModelMessage(
            isPrompt: false,
            message:
                "I encountered an error. Please try asking your question again.",
            time: DateTime.now(),
          ));
        });
      }
    }
  }

  // Store caht
  Future<void> saveChatMessage(
      String userMessage, String botResponse, String? imagePath) async {
    try {
      var sessionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .collection('chats')
          .doc(widget.sessionID);

      var message = {
        'userMessage': userMessage,
        'botResponse': botResponse,
        'imagePath': imagePath ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      };

      await sessionRef.collection('chatlist').add(message);
      print("Chat message saved under session successfully!");
    } catch (e) {
      print("Error saving chat message: $e");
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
                  builder: (context) => Home(
                    userName: widget.userName,
                    userID: widget.userID,
                  ),
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
