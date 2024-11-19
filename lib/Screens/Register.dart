import 'package:flutter/material.dart';
import 'package:wellio/Screens/Login.dart';
import 'package:wellio/Widgets/TextField.dart';
import 'package:wellio/Widgets/buttom.dart';


class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Avoid overflow when keyboard is shown
      body: Stack(
        children: [

          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff452C63),
                  Color(0xff3D2C8D)],
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
                    const CustomerTextField(
                      label: 'Full Name',
                      icon: Icons.check,
                    ),
                    const SizedBox(height: 20),
                    // Email or Phone Field
                    const CustomerTextField(
                      label: 'Gmail',
                      icon: Icons.check,
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    const CustomerTextField(
                      label: 'Password',
                      icon: Icons.visibility_off,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Confirm Password Field

                    const SizedBox(height: 30),
                    // Sign Up Button

                      CustomButton(
                        text: 'SIGN UP ',
                        onTap: () {  },
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
    );
  }
}
