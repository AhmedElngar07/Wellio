import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wellio/Screens/Home.dart';
import 'package:wellio/Widgets/model.dart';

class Geminichatbot extends StatefulWidget {
  final String userName;
  final String userID;
  const Geminichatbot({super.key, required this.userName, required this.userID});

  @override
  State<Geminichatbot> createState() => _GeminichatbotState();
}

class _GeminichatbotState extends State<Geminichatbot> {
  TextEditingController promptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  final List<ModelMessage> prompt = [];

  Future<void> sendMessage() async {
    final message = promptController.text;

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

    // Add your chatbot logic or API call here to process the message.
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          prompt.add(
            ModelMessage(
              isPrompt: true,
              message: 'Image uploaded.',
              time: DateTime.now(),
            ),
          );
        });
      }
    } catch (e) {
      print("Error picking image: $e");
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xff5b457c),
          shadowColor: Colors.black.withOpacity(0.7),
          elevation: 5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: prompt.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final message = prompt[index];
                  return Align(
                    alignment: message.isPrompt
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(),
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
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  Expanded(
                    flex: 20,
                    child: TextField(
                      controller: promptController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: "Ask a question",
                        hintStyle: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: const Color(0xF9694AFF),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: sendMessage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: const Color(0xF9694AFF),
                    child: IconButton(
                      icon: const Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: _pickImage,
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
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 1)
          .copyWith(left: isPrompt ? 80 : 15, right: isPrompt ? 15 : 80),
      decoration: BoxDecoration(
        color: isPrompt ? const Color(0xF9694AFF) : const Color(0x882E2E3D),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: isPrompt ? const Radius.circular(20) : Radius.zero,
          bottomRight: isPrompt ? Radius.zero : const Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            date,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
