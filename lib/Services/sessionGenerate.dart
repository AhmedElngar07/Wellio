import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wellio/Screens/newChatbot.dart';
import 'package:wellio/Services/timeException.dart';

class ChatServices {
  static Future<void> startNewChatSession({
    required BuildContext context,
    required String userID,
    required String userName,
  }) async {
    try {
      // Show loading state
      EasyLoading.show(status: 'Loading...');

      String sessionID = DateTime.now().millisecondsSinceEpoch.toString();

      // Attempt Firestore operation with timeout
      await Future.any([
        FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('chats')
            .doc(sessionID)
            .set({
          'createdAt': FieldValue.serverTimestamp(),
          'sessionID': sessionID,
          'status': 'active',
        }),
        Future.delayed(const Duration(seconds: 10))
            .then((_) => throw TimeoutException('Operation timed out')),
      ]);

      EasyLoading.dismiss();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SkinDiagnosisChatBot(
            userName: userName,
            userID: userID,
            sessionID: sessionID,
          ),
        ),
      );
    } catch (e) {
      EasyLoading.dismiss();
      await Future.delayed(const Duration(milliseconds: 100));
      EasyLoading.showError(
        'Connection error. Please check your internet connection.',
        duration: const Duration(seconds: 2),
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: true,
      );
    }
  }
}
