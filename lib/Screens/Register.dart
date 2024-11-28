import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:wellio/Screens/Login.dart';
import 'package:wellio/Services/Authentication.dart';
import 'package:wellio/Widgets/PasswordTextField.dart';
import 'package:wellio/Widgets/TextField.dart';
import 'package:wellio/Widgets/buttom.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void despose() {
    super.dispose();
    gmailController.dispose();
    fullnameController.dispose();
    passwordController.dispose();
  }

  void signUpUser() async {
    if (fullnameController.text.isEmpty ||
        gmailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      EasyLoading.showError('All fields are required.');
      return;
    }

    // Show the loader overlay
    context.loaderOverlay.show();

    final res = await AuthServices().signUpUser(
      name: fullnameController.text,
      gmail: gmailController.text,
      password: passwordController.text,
    );
    
    context.loaderOverlay.hide(); // Hide the loader overlay
    if (res == "success") {
      EasyLoading.showSuccess("Registration successful!");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      EasyLoading.showError(res); // Show the exact error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Avoid overflow when keyboard is shown
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff452C63), Color(0xff3D2C8D)],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Create Your\nAccount',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Foreground content
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      // Full Name Field
                      CustomerTextField(
                        controller: fullnameController,
                        label: 'Full Name',
                        icon: Icons.check,
                      ),
                      const SizedBox(height: 20),
                      // Email or Phone Field
                      CustomerTextField(
                        controller: gmailController,
                        label: 'Gmail',
                        icon: Icons.check,
                      ),
                      const SizedBox(height: 20),
                      // Password Field
                      PasswordTextField(
                        controller: passwordController,
                        label: 'Password',
                      ),
                      const SizedBox(height: 20),
                      // Confirm Password Field
      
                      const SizedBox(height: 30),
                      // Sign Up Button
      
                      CustomButton(
                        text: 'SIGN UP ',
                        onTap: signUpUser,
                      ),
                      const SizedBox(height: 30),
                      // Already Have an Account
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Text(
                              "I already have an account",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to LoginScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}