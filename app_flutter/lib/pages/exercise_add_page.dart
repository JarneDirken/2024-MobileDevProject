import 'package:app_flutter/apis/workout_api.dart';
import 'package:app_flutter/models/workout.dart';
import 'package:app_flutter/pages/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExerciseAddPage extends StatefulWidget {
  final int muscleGroup;
  const ExerciseAddPage({Key? key, required this.muscleGroup})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExerciseAddPageState();
}

class _ExerciseAddPageState extends State<ExerciseAddPage> {
  static const Color textColor = Color(0xFF020A22);
  static const Color backgroundColor = Color(0xFFECF0FE);
  static const Color buttonColor = Color(0xFF698CD3);

  TextEditingController exerciseName = TextEditingController();
  TextEditingController exerciseFocus = TextEditingController();
  TextEditingController exerciseDescription = TextEditingController();
  Exercise? exercise;

  @override
  void initState() {
    super.initState();
    exercise = Exercise(
      id: 0,
      musclegroupId: widget.muscleGroup,
      name: "",
      description: "",
      focus: "",
      image: "exercise_image_default.png",
      url: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(45.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // Add your navigation logic here
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WorkoutPage(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: buttonColor,
                  size: 38,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/globals/image_add_exercise.svg',
                width: 200,
                height: 200,
              ),
            ),
            const Text(
              'Create a new',
              style: TextStyle(
                  fontSize: 42, fontWeight: FontWeight.bold, color: textColor),
            ),
            const Text(
              'exercise',
              style: TextStyle(
                  fontSize: 42, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 20),
            const Text(
              "Name",
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            const SizedBox(height: 2),
            Container(
              width: 300,
              padding: const EdgeInsets.only(
                  left: 10.0, top: 2.0, right: 10.0, bottom: 2.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: exerciseName,
                decoration: InputDecoration(
                  hintText: 'Enter your new exercise name',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Focus",
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            const SizedBox(height: 2),
            Container(
              width: 300,
              padding: const EdgeInsets.only(
                  left: 10.0, top: 2.0, right: 10.0, bottom: 2.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: exerciseFocus,
                decoration: InputDecoration(
                  hintText: 'Enter exercise focus',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, color: textColor),
            ),
            const SizedBox(height: 2),
            Container(
              width: 300,
              padding: const EdgeInsets.only(
                  left: 10.0, top: 2.0, right: 10.0, bottom: 2.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: exerciseDescription,
                decoration: InputDecoration(
                  hintText: 'Enter description',
                  hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _createExercise();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(290, 45),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createExercise() {
    exercise!.name = exerciseName.text;
    exercise!.focus = exerciseFocus.text;
    exercise!.description = exerciseDescription.text;
    WorkoutApi.createExercise(exercise!).then((result) {
      Navigator.pop(context, true);
    });
  }
}
