import 'package:app_flutter/pages/exercise_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/models/workout.dart';

class ExerciseListWidget extends StatefulWidget {
  final Future<List<Exercise>> exerciseListFuture;
  final Function(int) fetchExercisesCallback;
  final Function() getMuscleGroupsCallback;

  const ExerciseListWidget(
      {super.key,
      required this.exerciseListFuture,
      required this.fetchExercisesCallback,
      required this.getMuscleGroupsCallback});

  @override
  State<StatefulWidget> createState() => _ExerciseDisplayPageState();
}

class _ExerciseDisplayPageState extends State<ExerciseListWidget> {
  static const Color textColor = Color(0xFF020A22);
  static const Color buttonColor = Color(0xFF698CD3);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
        future: widget.exerciseListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Column(
              children: [
                for (var exercise in snapshot.data!)
                  GestureDetector(
                    onTap: () {
                      _navigateToDetail(
                          exercise.id, exercise.musclegroupId, exercise.url);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/${exercise.image}',
                            width: 65,
                            height: 65,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                exercise.focus,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: buttonColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        });
  }

  void _navigateToDetail(int exercise, int musclegroup, String url) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExerciseDetailPage(
                  exerciseId: exercise,
                  musclegroupId: musclegroup,
                  url: url,
                )));
    widget.fetchExercisesCallback(musclegroup);
    widget.getMuscleGroupsCallback();
  }
}
