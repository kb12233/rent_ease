// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rent_ease/views/auth_page.dart';
import 'package:rent_ease/views/available_properties_UI.dart';
import 'package:rent_ease/views/edit_profile_UI.dart';
import 'package:rent_ease/views/forgotpassword_page.dart';
import 'package:rent_ease/views/login_UI.dart';
import 'package:rent_ease/views/manage_properties_UI.dart';
import 'package:rent_ease/views/register_UI.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:rent_ease/views/reservation_requests_UI.dart';
import 'package:rent_ease/views/view_properties.dart';
import 'package:rent_ease/views/view_tenants_UI.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color(0xFF532D29), useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      routes: {
        '/auth': (context) => AuthPage(),
        '/login': (context) => LoginUI(),
        '/register': (context) => RegisterUI(),
        '/forgotpassword': (context) => ForgotPasswordPage(),
        '/manageproperties': (context) => ManagePropertiesUI(),
        '/reservations': (context) => ReservationRequestsUI(),
        '/availableproperties': (context) => AvailablePropertiesUI(),
        '/viewtenants': (context) => ViewTenantsUI(),
        '/viewproperties': (context) => ViewProperties(),
        // '/edit_profile': (context) => EditProfileUI()
      },
    );
  }
}
