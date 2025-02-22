import 'package:flutter/material.dart';
import 'custom_painter_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MyWidget(), // This will show your circle with slider
        ),
      ),
    );
  }
}
