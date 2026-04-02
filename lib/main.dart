import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DesapegoApp());
}

class DesapegoApp extends StatelessWidget {
  const DesapegoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desapego de Usados',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
