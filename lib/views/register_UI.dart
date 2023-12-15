// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:rent_ease/components/my_button.dart';
import 'package:rent_ease/components/my_textfield.dart';
import 'package:rent_ease/controllers/register_controller.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({Key? key}) : super(key: key);

  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  Color buttonColor = Color(0xFF532D29);
  Color bC2 = Color(0xFFD2D1D3);

  int selectedUserType = 0; // Default to 0 (lessor)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: buttonColor,
            fontSize: 22,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white, // Set the app bar color to white
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: buttonColor,
            size: 25,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 1,
                  width: 300,
                  color: buttonColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Create New Account",
                style: TextStyle(
                  color: buttonColor,
                  fontSize: 20,
                  fontFamily: 'Open Sans',
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/login'),
                child: Text(
                  "Already Have an Account? Sign In",
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 12,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              MyTextField(
                controller: firstNameController,
                hintText: "First Name",
                obscureText: false,
              ),
              SizedBox(height: 10),
              MyTextField(
                controller: lastNameController,
                hintText: "Last Name",
                obscureText: false,
              ),
              SizedBox(height: 10),
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              SizedBox(height: 10),
              MyTextField(
                controller: phoneNumController,
                hintText: "Phone Number",
                obscureText: false,
              ),
              SizedBox(height: 10),
              MyTextField(
                controller: userNameController,
                hintText: "Username",
                obscureText: false,
              ),
              SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              SizedBox(height: 20),
              DropdownButton<int>(
                value: selectedUserType,
                onChanged: (int? value) {
                  setState(() {
                    selectedUserType = value!;
                  });
                },
                items: [
                  DropdownMenuItem<int>(
                    value: 0,
                    child: Text('Lessor'),
                  ),
                  DropdownMenuItem<int>(
                    value: 1,
                    child: Text('Tenant'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyButton(
                buttonColor: buttonColor,
                buttonText: "SIGN UP",
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                  String? errorMessage = await RegisterControl.signUp(
                    firstNameController.text.trim(),
                    lastNameController.text.trim(),
                    phoneNumController.text.trim(),
                    userNameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    selectedUserType,
                  );
                  Navigator.pop(context);
                  if (errorMessage == 'Success') {
                    Navigator.pushNamed(context, '/login');
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text(errorMessage as String),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
