import 'package:app_flutter/apis/workout_api.dart';
import 'package:app_flutter/models/workout.dart';
import 'package:app_flutter/pages/workout_edit_page.dart';
import 'package:flutter/material.dart';

import '../widgets/muscle_group_display.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WorkoutPage();
}

class _WorkoutPage extends State {
  // variables
  static const Color backgroundColor = Color(0xFFECF0FE);
  static const Color textColor = Color(0xFF020A22);
  static const Color buttonColor = Color(0xFF698CD3);
  static const Color bgColor = Color(0xFFCEDBFD);
  bool isEditing = false;
  static const int zero = 0;

  List<MuscleGroup> muscleGroupList = [];

  @override
  void initState() {
    super.initState();
    _getMuscleGroups();
  }

  void _getMuscleGroups() {
    WorkoutApi.fetchMuscleGroups().then((result) {
      setState(() {
        muscleGroupList = result;
      });
    });
    setState(() {
      isEditing = false;
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        child: isEditing
                            ? const Icon(
                                Icons.arrow_back,
                                color: buttonColor,
                                size: 38,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (!isEditing) {
                            _navigateToEditor(zero, isEditing);
                          }
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          minimumSize: const Size(70, 45),
                        ),
                        child: isEditing
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : const Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Choose a',
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const Text(
                    'Workout',
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Area of Focus',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: buttonColor),
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (muscleGroupList.isEmpty)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (muscleGroupList.isNotEmpty)
                    MuscleGroupListWidget(
                      muscleGroupList: muscleGroupList,
                      isEditing: isEditing,
                      refreshMuscleGroups: _getMuscleGroups,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditor(int id, bool isEditing) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutEditPage(id: id, isEditing: isEditing),
      ),
    );
    _getMuscleGroups();
  }
}
