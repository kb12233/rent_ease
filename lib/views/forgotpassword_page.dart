// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = const Color(0xFF532D29);
    Color borderColor = const Color.fromARGB(255, 210, 209, 195);

    return Scaffold (

      
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Forgot Password?",
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.bold,
                ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,       
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios,
              color: textColor,
              size: 25,
            ),
          ),
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            children: [

              Image.asset(
                'lib/images/forgot_pass.png',
                width: 200,
                ),
                const SizedBox(height: 10),

                Text('Enter your email to receive an email \n to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: borderColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: borderColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                
                MaterialButton(
                  onPressed: passwordReset,
                  color: textColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: textColor),
                    ),
                  child: Text(
                    'Reset Password',
                    style: TextStyle(color: Colors.white),
                    ),
                ),

            ],
          ),
        )
      ),

      
          );
        }
      }