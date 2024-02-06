import 'package:flutter/material.dart';
import './pages/home.dart';

void main() {
  runApp(const ArFitnessApp());
}

class ArFitnessApp extends StatelessWidget {
  const ArFitnessApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ar Fitness App',
      home: HomePage(),
    );
  }
}