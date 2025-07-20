import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() {
  runApp(CyberthreyaApp());
}

class CyberthreyaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyberthreya',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
