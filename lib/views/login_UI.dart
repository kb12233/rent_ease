// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_ease/components/my_button.dart';
import 'package:rent_ease/components/my_textfield.dart';
import 'package:rent_ease/controllers/login_controller.dart';
import 'package:rent_ease/models/user_model.dart';
import 'package:rent_ease/views/lessor_home_UI.dart';
import 'package:rent_ease/views/tenant_home_UI.dart';

class LoginUI extends StatefulWidget {
  LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final Color buttonColor = Color(0xFF532D29);

  Future<void> signInUser() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    //sign in
    String? result = await LoginControl.signIn(
        emailController.text.trim(), passwordController.text.trim());
    if (!mounted) return;
    Navigator.pop(context);
    if (result == 'Success') {
      // Navigator.pushNamed(context, '/home');
      final user_auth = FirebaseAuth.instance.currentUser!;
      UserModel? user = await UserModel.getUserData(user_auth.uid);
      print(user!.userType);
      if (user.userType == 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TenantHomeUI(user: user)));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LessorHomeUI(user: user)));
      }
    }
    if (result != 'Success') {
      // Handle the error. For example, show a dialog with the error message.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(result!),
        ),
      );
    }
  }

  void displaySignInError(String errorCode) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(errorCode));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              // for spacing
              SizedBox(
                height: 100,
              ),

              // LOGO
              Icon(
                Icons.person,
                size: 200,
              ),

              // for spacing
              SizedBox(
                height: 10,
              ),

              // SIGN UP LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Sign up!',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              // for spacing
              SizedBox(
                height: 20,
              ),

              // USERNAME
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),

              // for spacing
              SizedBox(
                height: 10,
              ),

              // PASSWORD
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),

              // for spacing
              SizedBox(
                height: 10,
              ),

              // FORGOT PASSWORD LINK
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgotpassword');
                      },
                      child: Container(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          //
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // for spacing
              SizedBox(
                height: 25,
              ),

              // SIGN IN BUTTON
              MyButton(
                buttonText: "Sign in",
                onTap: signInUser,
                buttonColor: buttonColor,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
