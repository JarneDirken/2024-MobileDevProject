import 'package:flutter/material.dart';
import '../widgets/aronetarget.dart';

class ArExercisePage extends StatefulWidget {
  const ArExercisePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArExercisePageState();
}

class _ArExercisePageState extends State<ArExercisePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          // Here we load the Widget with the Gym Exercise Experience
          child: ArOneTargetWidget()),
    );
  }
}