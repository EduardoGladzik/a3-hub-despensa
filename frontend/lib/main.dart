import 'package:flutter/material.dart';
import 'views/login_view.dart';

void main() {
  runApp(const HellpCookApp());
}

class HellpCookApp extends StatelessWidget {
  const HellpCookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HELLp Cook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}