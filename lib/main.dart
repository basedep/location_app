
import 'package:flutter/material.dart';
import 'package:location_app/screens/HomePage.dart';
import 'package:location_app/screens/LoginPage.dart';
import 'package:location_app/screens/SignUpPage.dart';

import 'controllers/Controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => const CheckSession(),
        "/home": (context) => const Homepage(),
        "/signup": (context) => const SignUpPage(),
        "/login": (context) => const LoginPage(),
      },
    );
  }
}

// Check Session Page
class CheckSession extends StatefulWidget {
  const CheckSession({super.key});

  @override
  State<CheckSession> createState() => _CheckSessionState();
}

class _CheckSessionState extends State<CheckSession> {
  @override
  void initState() {
    checkSessions().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.restorablePushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}