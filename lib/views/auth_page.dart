// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_ease/models/user_model.dart';
import 'package:rent_ease/views/lessor_home_UI.dart';
import 'package:rent_ease/views/login_UI.dart';
import 'package:rent_ease/views/tenant_home_UI.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  
  Future<StatefulWidget> checkUserType() async {
    final user_auth = FirebaseAuth.instance.currentUser!;
    UserModel currentUser = (await UserModel.getUserData(user_auth.uid))!;

    if (currentUser.userType == 1) {
      // Navigator.push(context,
      //     MaterialPageRoute(
      //       builder: (context) => TenantHomeUI(user: currentUser)
      //     ));
      return TenantHomeUI(user: currentUser);
    } else {
      // Navigator.push(context,
      //     MaterialPageRoute(
      //       builder: (context) => LessorHomeUI(user: currentUser)
      //     ));
      return LessorHomeUI(user: currentUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // if user is logged in
            //return HomePage();
            return FutureBuilder<StatefulWidget>(
              future: checkUserType(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while waiting for the future to complete
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Show an error message if the future throws an error
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Return the widget based on the future's result
                  return snapshot.data!;
                }
              },
            );
          } else {
            // if user is not logged in
            return LoginUI();
          }
        },
      ),
    );
  }
}
