import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wellio/Screens/Home.dart';
import 'package:wellio/Screens/Register.dart';
import 'package:wellio/Widgets/ForegetPassword.dart';
import 'package:wellio/Widgets/TextField.dart';
import 'package:wellio/Widgets/buttom.dart';
import '../Services/Authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController gmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void despose() {
    super.dispose();
    gmailController.dispose();
    passwordController.dispose();
  }

  void loginUsers() async {
    if (gmailController.text.isEmpty || passwordController.text.isEmpty) {
      EasyLoading.showError('All fields are required.');
      return; // Stop execution if validation fails
    }

    setState(() {
      isLoading = true; // Show loading indicator
    });

    final res = await AuthServices().loginUser(
      gmail: gmailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() {
      isLoading = false; // Hide loading indicator
    });

    if (res == "success") {
      EasyLoading.showSuccess("Login successful!");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    } else {
      // Show the specific error message returned from loginUser
      EasyLoading.showError(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures the layout adapts when the keyboard opens
      body: Stack(
        children: [
          // Background gradient
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
                'Hello\nSign in!',
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
                  mainAxisSize:
                      MainAxisSize.min, // Adjust to the content height
                  children: [
                    const SizedBox(height: 50),
                    // Email field
                    CustomerTextField(
                      controller: gmailController,
                      label: 'Gmail',
                      icon: Icons.check,
                    ),
                    const SizedBox(height: 20),
                    // Password field
                    CustomerTextField(
                      controller: passwordController,
                      label: 'Password',
                      icon: Icons.visibility_off,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Forgot Password link
                    const Align(
                      alignment: Alignment.centerRight,
                      child: ForgetPassword(),

                      // Text(
                      //   'Forgot Password?',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 17,
                      //     color: Color(0xff281537),
                      //   ),
                      // ),
                    ),
                    const SizedBox(height: 40),

                    CustomButton(
                      text: 'SIGN IN ',
                      onTap: loginUsers,
                    ),
                    SizedBox(height: 30),

                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Text(
                            "Create new account ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the signup page
                            },
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to the RegisterPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
