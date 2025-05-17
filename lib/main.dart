import 'package:flutter/material.dart';
import 'view/typing_practice_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Typing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Ubuntu Mono',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 36,
            fontFamily: 'Ubuntu Mono',
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            fontSize: 20,
              fontFamily: 'Ubuntu Mono',
            fontWeight: FontWeight.w400,
          ),
          titleMedium: TextStyle(
            fontSize: 30,
            fontFamily: 'Ubuntu Mono',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const TypingPracticePage(),
    );
  }
}

