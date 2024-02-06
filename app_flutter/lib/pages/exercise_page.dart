import 'package:app_flutter/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../apis/workout_api.dart';
import '../widgets/exercise_display.dart';
import 'exercise_add_page.dart';
import 'workout_page.dart';

class ExercisePage extends StatefulWidget {
  final int muscleGroup;

  const ExercisePage({
    super.key,
    required this.muscleGroup,
  });

  @override
  State<StatefulWidget> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  List<Exercise> exerciseList = [];
  List<MuscleGroup> muscleGroupList = [];

  static const Color textColor = Color(0xFF020A22);
  static const Color backgroundColor = Color(0xFFECF0FE);
  static const Color buttonColor = Color(0xFF698CD3);

  @override
  void initState() {
    super.initState();
    _fetchExercisesForMuscleGroup(widget.muscleGroup);
    _getMuscleGroups();
  }

  void _getMuscleGroups() {
    WorkoutApi.fetchMuscleGroups().then((result) {
      setState(() {
        muscleGroupList = result;
      });
    });
  }

  void _fetchExercisesForMuscleGroup(int id) {
    setState(() {
      exerciseList = [];
    });

    WorkoutApi.fetchExercisesForMuscleGroup(id).then((result) {
      setState(() {
        exerciseList = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(45.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
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
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              _navigateToAdd(widget.muscleGroup);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              minimumSize: const Size(70, 45),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (exerciseList.isEmpty && muscleGroupList.isEmpty)
                        const CircularProgressIndicator(),
                      if ((exerciseList.isNotEmpty &&
                              muscleGroupList.isNotEmpty) ||
                          (exerciseList.isEmpty && muscleGroupList.isNotEmpty))
                        SvgPicture.asset(
                          'assets/images/${muscleGroupList[widget.muscleGroup - 1].image}',
                          width: 250,
                          height: 250,
                        ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  if (exerciseList.isEmpty && muscleGroupList.isEmpty)
                    const CircularProgressIndicator(),
                  if ((exerciseList.isNotEmpty && muscleGroupList.isNotEmpty) ||
                      (exerciseList.isEmpty && muscleGroupList.isNotEmpty))
                    Text(
                      muscleGroupList[widget.muscleGroup - 1].name,
                      style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                  const SizedBox(height: 20),
                  if (exerciseList.isEmpty && muscleGroupList.isEmpty)
                    const CircularProgressIndicator(),
                  if (exerciseList.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "No exercises available",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _navigateToAdd(widget.muscleGroup);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text("Make your first exercise"),
                          ),
                        ],
                      ),
                    ),
                  ExerciseListWidget(
                    exerciseListFuture: Future.value(exerciseList),
                    fetchExercisesCallback: _fetchExercisesForMuscleGroup,
                    getMuscleGroupsCallback: _getMuscleGroups,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAdd(int muscleGroup) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExerciseAddPage(muscleGroup: muscleGroup)));
    _fetchExercisesForMuscleGroup(widget.muscleGroup);
  }
}
